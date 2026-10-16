# 06_rq5_mechanisms.R -- RQ5: through which channels does social housing affect private rents?
#  (a) Additional supply vs tenure conversion: compare new build (adds stock) with acquisitions (moves
#      existing dwellings into the sub-market sector) and Right to Buy (moves social dwellings out)
#  (b) Competition: effects by rent segment. New social/affordable homes are 67% one/two-bedroom vs 25% of
#      private completions, and only 4% are 4+ bed: if competition drives the effect it should concentrate
#      in 1-2 bed segments and be ~0 for 4+ bed (a within-LA placebo). Social Rent vs Affordable Rent
#      (<=80% of market rent, a closer substitute) is a second competition test.
#  (c) Demand displacement and crowd-out: waiting lists, private completions, total net additions,
#      house prices; national CORE shares of new social tenants coming from private renting.
source("code/00_setup.R")
A <- fread(file.path(ROOT, "data", "clean", "analysis_with_flows.csv"))
setkey(P, code, year)
P[, `:=`(sr_l1 = shift(sr_nb_pk), ar_l1 = shift(ar_nb_pk), soc_l1 = shift(soc_nb_pk), soc_l2 = shift(soc_nb_pk, 2),
         rtb_l1 = shift(rtb_pk), aq_l1 = shift(aq_pk)), by = code]
A <- merge(A, P[, .(code, year, sr_l1, ar_l1, soc_l2)], by = c("code", "year"))
A[, `:=`(sr2 = sr_nb_pk + sr_l1, ar2 = ar_nb_pk + ar_l1)]
fr <- function(dep, rhs, d = A) feols(as.formula(paste(dep, "~", rhs, "+", CTRL, "| code + region_year")), d, cluster = ~code)

## (a) supply-mode decomposition -------------------------------------------------------
a1 <- fr("dlnrent_all", "soc2 + aq2 + rtb2")
a2 <- fr("dlnrent_all", "sr2 + ar2 + aq2 + rtb2")
lc <- function(m, w) {  # linear combination w'b with clustered SE
  b <- coef(m)[names(w)]; V <- vcov(m)[names(w), names(w)]; est <- sum(w * b); se <- sqrt(t(w) %*% V %*% w)
  data.table(est = est, se = as.numeric(se), p = 2 * pnorm(-abs(est / as.numeric(se))))
}
d_nb_aq <- lc(a1, c(soc2 = 1, aq2 = -1)); d_sr_ar <- lc(a2, c(sr2 = 1, ar2 = -1)); d_nb_rtb <- lc(a1, c(soc2 = 1, rtb2 = 1))
tests <- rbind(cbind(test = "soc2 - aq2 (new build minus acquisition)", d_nb_aq),
               cbind(test = "sr2 - ar2 (Social Rent minus Affordable Rent new build)", d_sr_ar),
               cbind(test = "soc2 + rtb2 (symmetry: gain of one unit vs loss of one unit)", d_nb_rtb))
fwrite(tests, file.path(TAB, "rq5_supply_tests.csv"))

## (b) competition: segment-specific outcomes ----------------------------------------
segs <- c(b1 = "1 bed", b2 = "2 bed", b3 = "3 bed", b4 = "4+ bed", flat = "Flat/maisonette", terr = "Terraced",
          semi = "Semi-detached", det = "Detached")
seg_mods <- lapply(names(segs), function(s) fr(paste0("dlnrent_", s), "soc2 + aq2 + rtb2"))
names(seg_mods) <- names(segs)
seg_tab <- rbindlist(lapply(names(segs), function(s) {
  ct <- coeftable(seg_mods[[s]]); data.table(segment = segs[s], term = rownames(ct)[1:3], est = ct[1:3, 1], se = ct[1:3, 2], p = ct[1:3, 4])
}))
fwrite(seg_tab, file.path(TAB, "rq5_segment_coefs.csv"))
# stacked test: is the new-build effect larger (more negative) for 1-2 bed than for 4+ bed?
L <- melt(A[, c("code", "year", "region_year", "soc2", "aq2", "rtb2", strsplit(CTRL, " \\+ ")[[1]],
                paste0("dlnrent_", c("b1", "b2", "b4"))), with = FALSE],
          measure.vars = paste0("dlnrent_", c("b1", "b2", "b4")), variable.name = "seg", value.name = "y")
L[, small := as.integer(seg != "dlnrent_b4")]
L[, cs := paste(code, seg)]; L[, rys := paste(region_year, seg)]
stk <- feols(as.formula(paste("y ~ soc2 + soc2:small + aq2 + aq2:small + rtb2 + rtb2:small + (",
                              CTRL, "):i(seg) | cs + rys")), L, cluster = ~code)

## (b2) competition with DIRECT segment rents (VOA/ONS PRMS medians by bedroom, 12 months to Sept).
# PIPR segment indices are model-based and move almost one-for-one with the all-property LA index
# (within-LA correlation of 1-bed and 4+-bed growth = 0.99), so they cannot discriminate between segments.
PR <- fread(file.path(ROOT, "data", "clean", "prms_la_bedroom_2014_2023.csv"))
PRL <- melt(PR, id.vars = c("code", "year"), measure.vars = paste0("dlnprms_", c("b1", "b2", "b3", "b4")),
            variable.name = "seg", value.name = "y")
cnt <- melt(PR, id.vars = c("code", "year"), measure.vars = paste0("prms_count_", c("b1", "b2", "b3", "b4")),
            variable.name = "segc", value.name = "cnt")
cnt[, seg := sub("prms_count_", "dlnprms_", segc)]
PRL <- merge(PRL, cnt[, .(code, year, seg, cnt)], by = c("code", "year", "seg"))
PRL <- merge(PRL, A[, c("code", "year", "region_year", "soc2", "aq2", "rtb2", strsplit(CTRL, " \\+ ")[[1]]), with = FALSE],
             by = c("code", "year"))
PRL <- PRL[is.finite(y) & abs(y) < 40]  # drop extreme log changes from small cells (|change| >= 40%)
PRL[, segl := factor(seg, levels = paste0("dlnprms_", c("b1", "b2", "b3", "b4")), labels = c("1 bed", "2 bed", "3 bed", "4+ bed"))]
prms_mods <- lapply(levels(PRL$segl), function(s) feols(as.formula(paste("y ~ soc2 + aq2 + rtb2 +", CTRL, "| code + region_year")),
                                                        PRL[segl == s], weights = ~cnt, cluster = ~code))
names(prms_mods) <- levels(PRL$segl)
PRL[, small := as.integer(segl %in% c("1 bed", "2 bed"))]
PRL[, cs := paste(code, segl)]; PRL[, rys := paste(region_year, segl)]
prms_stk <- feols(as.formula(paste("y ~ soc2 + soc2:small + aq2 + aq2:small + rtb2 + rtb2:small + (", CTRL,
                                   "):i(segl) | cs + rys")), PRL[segl %in% c("1 bed", "2 bed", "4+ bed")],
                  weights = ~cnt, cluster = ~code)
prms_tab <- rbindlist(lapply(names(prms_mods), function(s) { ct <- coeftable(prms_mods[[s]])
  data.table(segment = s, term = rownames(ct)[1:3], est = ct[1:3, 1], se = ct[1:3, 2], p = ct[1:3, 4], n = nobs(prms_mods[[s]])) }))
fwrite(prms_tab, file.path(TAB, "rq5_prms_segment_coefs.csv"))
etable(prms_mods, prms_stk, tex = TRUE, file = file.path(TAB, "rq5_prms_segments.tex"), replace = TRUE,
       title = "RQ5: competition test with direct segment rents (VOA/ONS PRMS, 2015-2023)")

## (c) displacement / crowd-out ----------------------------------------------------------
c1 <- fr("dlnwait", "soc_nb_pk + soc_l1 + aq_pk + rtb_pk", A[is.finite(dlnwait) & abs(dlnwait) < 100])
A[, netadd_pk_now := netadd_pk]
c2 <- fr("priv_compl_pk", "soc_nb_pk + soc_l1 + soc_l2 + aq_pk + rtb_pk")
c3 <- fr("netadd_pk_now", "soc_nb_pk + soc_l1 + soc_l2 + aq_pk + rtb_pk")
c4 <- fr("dlnhp", "soc2 + aq2 + rtb2")
etable(a1, a2, c1, c2, c3, c4, tex = TRUE, file = file.path(TAB, "rq5_mechanisms.tex"), replace = TRUE,
       title = "RQ5: supply channels, displacement and crowd-out")
etable(seg_mods, tex = TRUE, file = file.path(TAB, "rq5_segments.tex"), replace = TRUE,
       title = "RQ5: competition -- rent growth by segment")
save_coefs(c(list(supply = a1, supply_SR_AR = a2, waitlist = c1, private_completions = c2, net_additions = c3,
                  house_prices = c4, stacked_segments = stk), seg_mods), "rq5_coefficients.csv")
sink(file.path(TAB, "rq5_summary.txt"))
print(etable(a1, a2, c1, c2, c3, c4)); print(tests); print(seg_tab); print(coeftable(stk)[1:6, ])
cat("\n=== PRMS direct segment rents ===\n"); print(prms_tab); print(coeftable(prms_stk)[1:6, ])
sink()

## figures ------------------------------------------------------------------------------------
st <- rbind(cbind(src = "PIPR (model-based index)", seg_tab), cbind(src = "VOA/ONS PRMS (direct medians)", prms_tab[, -"n"]))[term %in% c("soc2", "rtb2")]
st[, term := fifelse(term == "soc2", "Social/affordable new build", "Right to Buy sales")]
st[, segment := factor(segment, levels = rev(unique(c(segs, "1 bed", "2 bed", "3 bed", "4+ bed"))))]
st <- st[segment %in% c("1 bed", "2 bed", "3 bed", "4+ bed")]
g <- ggplot(st, aes(est, segment)) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_pointrange(aes(xmin = est - 1.96 * se, xmax = est + 1.96 * se, colour = src), position = position_dodge(width = 0.5)) +
  scale_colour_manual(values = c("#9dc3e6", "#1f4e79")) + facet_wrap(~term, scales = "free_x") +
  labs(x = "Effect on segment rent growth (pp per 1,000 dwellings, 2-year cumulative flow)", y = NULL, colour = NULL,
       title = "Figure 6. Competition test: rent effects by bedroom count and property type") + theme_paper
ggsave(file.path(FIG, "fig6_segments.png"), g, width = 8.5, height = 4.2, dpi = 300)

core <- fread(file.path(ROOT, "data", "clean", "core_previous_tenure_national.csv"))
core <- core[prev == "Private sector tenancy"]
cm <- melt(core, id.vars = c("fy", "prev"), measure.vars = c("SR General Needs PRP", "AR General Needs PRP", "SR General Needs LA", "AR General Needs LA"),
           variable.name = "type", value.name = "pct")
cm[, pct := as.numeric(pct)]; cm[, yr := as.integer(substr(fy, 1, 4)) + 1]
fwrite(cm, file.path(TAB, "rq5_core_prs_share.csv"))
g <- ggplot(cm[!is.na(pct) & pct > 0], aes(yr, pct, colour = type)) + geom_line(size = 0.8) + geom_point(size = 1.2) +
  scale_colour_manual(values = c("#1f4e79", "#c55a11", "#9dc3e6", "#f4b183")) +
  labs(x = "Financial year ending", y = "% of new general-needs lettings", colour = NULL,
       title = "Figure 7. New social tenants previously renting privately (CORE, England)") + theme_paper
ggsave(file.path(FIG, "fig7_core_prs.png"), g, width = 7, height = 4, dpi = 300)
cat("RQ5 done\n")
