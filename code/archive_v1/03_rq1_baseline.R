# 03_rq1_baseline.R -- RQ1: does social housing reduce private rent growth?
# (a) TWFE on lagged stock share (conditional association, within-LA variation)
# (b) Flow models: new-build completions, acquisitions, Right to Buy (more within variation)
# (c) Shift-share IV for completions
# (d) Long-difference / between-LA estimates (cross-sectional variation)
# (e) Event study around the first large completion pulse (Sun & Abraham 2021 estimator)
source("code/00_setup.R")
f <- function(rhs, fe = "code + year") as.formula(paste("dlnrent_all ~", rhs, "+", CTRL, "|", fe))

## (a) stock share ---------------------------------------------------------------
m1 <- feols(f("sh_share_l1"), A, cluster = ~code)
m2 <- feols(f("sh_share_l1", "code + region_year"), A, cluster = ~code)
m3 <- feols(f("sh_share_l1 + vac_rate_l1", "code + region_year"), A, cluster = ~code)

## (b) flows ---------------------------------------------------------------------------
setkey(P, code, year)
P[, `:=`(soc_nb_pk_l1 = shift(soc_nb_pk), aq_pk_l1 = shift(aq_pk), rtb_pk_l1 = shift(rtb_pk),
         soc_nb_pk_f1 = shift(soc_nb_pk, -1), bartik_pk_l1 = shift(bartik_pk)), by = code]
A <- merge(A, P[, .(code, year, soc_nb_pk_l1, aq_pk_l1, rtb_pk_l1, soc_nb_pk_f1, bartik_pk_l1)],
           by = c("code", "year"), all.x = TRUE)
m4 <- feols(f("soc_nb_pk + aq_pk + rtb_pk"), A, cluster = ~code)
m5 <- feols(f("soc_nb_pk + aq_pk + rtb_pk", "code + region_year"), A, cluster = ~code)
m6 <- feols(f("soc_nb_pk + soc_nb_pk_l1 + aq_pk + aq_pk_l1 + rtb_pk + rtb_pk_l1", "code + region_year"), A, cluster = ~code)
# placebo: future completions should not predict current rent growth
m7 <- feols(f("soc_nb_pk_f1 + soc_nb_pk + aq_pk + rtb_pk", "code + region_year"), A[year < 2025], cluster = ~code)

## (c) shift-share IV -------------------------------------------------------------
m8_fs <- feols(as.formula(paste("soc_nb_pk ~ bartik_pk +", CTRL, "| code + year")), A, cluster = ~code)
m8 <- feols(as.formula(paste("dlnrent_all ~", CTRL, "| code + year | soc_nb_pk ~ bartik_pk")), A, cluster = ~code)

## (d) long difference: cumulative growth 2015->2025 on 2014 share ------------------
LD <- P[year == 2025, .(code, region, l25 = log(idx_all))][
  P[year == 2015, .(code, l15 = log(idx_all), lvl15 = log(rentlvl_all))], on = "code"][
  P[year == 2014, .(code, sh14 = sh_share, vac14 = vac_rate)], on = "code"]
cov <- P[year %between% c(2015, 2024), .(dlnpop = mean(dlnpop, na.rm = TRUE), dlnpay = mean(dlnpay, na.rm = TRUE),
                                         unemp = mean(unemp, na.rm = TRUE), netadd = mean(netadd_pk, na.rm = TRUE),
                                         soc_nb = mean(soc_nb_pk, na.rm = TRUE)), by = code]
LD <- merge(LD, cov, by = "code")
LD <- merge(LD, unique(P[, .(code, prs_share11, refusal_major, dissim21, ar_share_new, london)]), by = "code")
LD[, cumg := 100 * (l25 - l15) / 10]  # average annual growth, %
m9 <- feols(cumg ~ sh14 + dlnpop + dlnpay + unemp + netadd + lvl15 | region, LD, vcov = "hetero")
m10 <- feols(cumg ~ sh14 + dlnpop + dlnpay + unemp + netadd + lvl15 + prs_share11 + vac14 | region, LD, vcov = "hetero")
fwrite(LD, file.path(ROOT, "data", "clean", "long_difference_2015_2025.csv"))

## (e) Correlated random effects (Mundlak): pooled share effect with LA means ------
for (v in c("sh_share_l1", "dlnpop_l1", "dlnpay_l1", "unemp_l1", "netadd_pk_l1")) A[, paste0(v, "_bar") := mean(get(v)), by = code]
m11 <- feols(as.formula(paste("dlnrent_all ~ sh_share_l1 + sh_share_l1_bar +", CTRL,
                              "+ dlnpop_l1_bar + dlnpay_l1_bar + unemp_l1_bar + netadd_pk_l1_bar | region_year")),
             A, cluster = ~code)

mods <- list(TWFE_share = m1, TWFE_share_RY = m2, TWFE_share_RY_vac = m3, Flows = m4, Flows_RY = m5,
             Flows_lags_RY = m6, Placebo_lead = m7, IV_firststage = m8_fs, IV_2SLS = m8,
             LD_basic = m9, LD_full = m10, CRE_Mundlak = m11)
save_coefs(mods, "rq1_coefficients.csv")
etable(m1, m2, m3, m4, m5, m6, m7, tex = TRUE, file = file.path(TAB, "rq1_panel.tex"), replace = TRUE,
       title = "RQ1: social housing stock, flows and private rent growth (TWFE)")
etable(m8_fs, m8, m9, m10, m11, tex = TRUE, file = file.path(TAB, "rq1_iv_ld_cre.tex"), replace = TRUE,
       title = "RQ1: shift-share IV, long differences and correlated random effects")
sink(file.path(TAB, "rq1_summary.txt"))
print(etable(m1, m2, m3, m4, m5, m6, m7)); print(etable(m8_fs, m8, m9, m10, m11))
cat("\nFirst-stage F (IV):\n"); print(fitstat(m8, ~ ivf + ivwald))
sink()

## (f) event study --------------------------------------------------------------
ES <- copy(P[year %between% c(2015, 2025)])
ES[, lnidx := 100 * log(idx_all)]
ES <- ES[is.na(event_year) | event_year >= 2017]          # drop LAs first treated before rent data start
ES[, cohort := fifelse(is.na(event_year), 10000, event_year)]
ES <- merge(ES, A[, .(code, year, dlnpop_l1, dlnpay_l1, unemp_l1, netadd_pk_l1)], by = c("code", "year"), all.x = TRUE)
es1 <- feols(lnidx ~ sunab(cohort, year, ref.p = -1) | code + year, ES, cluster = ~code)
es2 <- feols(lnidx ~ sunab(cohort, year, ref.p = -1) | code + region_year, ES, cluster = ~code)
es_tab <- rbindlist(lapply(list(`LA + year FE` = es1, `LA + region-year FE` = es2), function(m) {
  ct <- as.data.table(coeftable(m), keep.rownames = "term")
  ct[grepl("year::", term)][, .(rel = as.integer(sub("year::", "", term)), est = Estimate, se = `Std. Error`)]
}), idcol = "spec")
es_tab <- rbind(es_tab, data.table(spec = unique(es_tab$spec), rel = -1L, est = 0, se = 0))
fwrite(es_tab, file.path(TAB, "rq1_event_study.csv"))
att <- rbindlist(lapply(list(`LA + year FE` = es1, `LA + region-year FE` = es2), function(m) {
  s <- summary(m, agg = "att"); ct <- coeftable(s)
  data.table(term = rownames(ct), est = ct[, 1], se = ct[, 2], p = ct[, 4])
}), idcol = "spec")
fwrite(att, file.path(TAB, "rq1_event_att.csv"))
# pre-trend joint test (all leads -2..-6) and trend-break test
pre <- function(m) unlist(wald(m, keep = "year::-[2-6]:cohort", print = FALSE)[c("stat", "p", "df1")])  # cohort-specific leads
# Sensitivity: LA-specific linear trends estimated jointly (absorbs differential pre-trends, but may also
# absorb part of a dynamic treatment effect -- reported as a bound, not as the preferred estimate)
es3 <- feols(lnidx ~ sunab(cohort, year, ref.p = -1) | code[year] + region_year, ES, cluster = ~code)
es_tab3 <- as.data.table(coeftable(es3), keep.rownames = "term")[grepl("year::", term)][
  , .(spec = "LA trends + region-year FE", rel = as.integer(sub("year::", "", term)), est = Estimate, se = `Std. Error`)]
es_tab <- rbind(es_tab, es_tab3, data.table(spec = "LA trends + region-year FE", rel = -1L, est = 0, se = 0))
fwrite(es_tab, file.path(TAB, "rq1_event_study.csv"))
s3 <- coeftable(summary(es3, agg = "att"))
att <- rbind(att, data.table(spec = "LA trends + region-year FE", term = rownames(s3), est = s3[, 1], se = s3[, 2], p = s3[, 4]))
fwrite(att, file.path(TAB, "rq1_event_att.csv"))
# Slope-break test: linear pre-trend vs post-trend in event time (region-year FE spec)
et <- es_tab[spec == "LA + region-year FE" & rel %between% c(-6, 6)]
et[, post := as.integer(rel >= 0)]
brk <- lm(est ~ rel + post + rel:post, et, weights = 1 / pmax(se, 0.05)^2)
sink(file.path(TAB, "rq1_event_pretrend.txt"))
cat("Joint test of all cohort-specific leads -2..-6 = 0 (LA+year FE; LA+region-year FE; LA trends)\n"); print(pre(es1)); print(pre(es2)); print(pre(es3))
cat("\nATT (average post-treatment effect)\n"); print(att)
cat("\nSlope break in event-time coefficients (WLS on estimates, rel -6..6)\n"); print(summary(brk)$coefficients)
cat("\nNumber of treated LAs by cohort\n"); print(ES[cohort < 10000, uniqueN(code), by = cohort][order(cohort)])
cat("Never-treated LAs:", ES[cohort == 10000, uniqueN(code)], "\n")
sink()

g <- ggplot(es_tab[rel %between% c(-6, 6)], aes(rel, est, colour = spec, shape = spec)) +
  geom_hline(yintercept = 0, colour = "grey50") + geom_vline(xintercept = -0.5, linetype = 2, colour = "grey60") +
  geom_pointrange(aes(ymin = est - 1.96 * se, ymax = est + 1.96 * se), position = position_dodge(width = 0.4)) +
  scale_colour_manual(values = c("#1f4e79", "#c55a11", "#548235")) +
  labs(x = "Years relative to first large social-rent completion pulse", y = "Log private rent index (x100)",
       colour = NULL, shape = NULL,
       title = "Figure 2. Private rents around a large social/affordable rent completion pulse") + theme_paper
ggsave(file.path(FIG, "fig2_event_study.png"), g, width = 7, height = 4.2, dpi = 300)
cat("RQ1 done\n")
