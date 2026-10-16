# 05_rq34_heterogeneity.R -- RQ3 (do LA-specific thresholds exist?) and RQ4 (which market institutions
# explain heterogeneity?). One modelling framework, three estimators:
#  (a) split-sample Hansen thresholds by moderator group (is the threshold location different?)
#  (b) index-threshold model: tau_i = tau0 - theta * (Z_i - mean Z), estimated by 2-D grid search with an
#      LA-cluster bootstrap for theta (a parametric analogue of a hierarchical threshold, Seo & Linton 2007)
#  (c) multilevel random-coefficient model: LA-specific slopes on new supply (partial pooling) with
#      cross-level interactions with pre-registered moderators (RQ4)
# Moderators (fixed before estimation, 4 theory-driven ones + London):
#   prs_share11   rental-sector size (Census 2011 private-rented share of households)
#   refusal_major supply restrictiveness (major residential refusal rate 1979-2013)
#   ar_share_new  price proximity / openness (Affordable Rent share of new social lets)
#   vac_rate_2014 market slack (vacancy rate, 2014, pre-sample -> not a mediator)
#   dissim21      spatial concentration of social housing (LSOA dissimilarity, Census 2021)
source("code/00_setup.R")
source("code/threshold_functions.R")
suppressPackageStartupMessages(library(lme4))
NB <- as.integer(Sys.getenv("NBOOT", "299"))
ctrl <- strsplit(CTRL, " \\+ ")[[1]]
A <- fread(file.path(ROOT, "data", "clean", "analysis_with_flows.csv"))
MODS <- c(prs_share11 = "Private-rented share (2011)", refusal_major = "Planning refusal rate",
          ar_share_new = "Affordable Rent share of new lets", vac_rate_2014 = "Vacancy rate (2014)",
          dissim21 = "Social housing concentration")
for (m in names(MODS)) A[, paste0(m, "_z") := (get(m) - mean(get(m))) / sd(get(m))]

## (a) split-sample thresholds ------------------------------------------------------
split_res <- list(); split_coef <- list()
for (m in c(names(MODS), "london")) {
  for (grp in c("low", "high")) {
    sub <- if (m == "london") A[london == as.integer(grp == "high")] else
      A[if (grp == "high") get(m) > median(get(m)) else get(m) <= median(get(m))]
    if (uniqueN(sub$code) < 20) next
    h <- hansen_fe(sub, "dlnrent_all", "soc2", "sh_share_l1", c(ctrl, "aq2", "rtb2"), nboot = NB, double = FALSE,
                   trim = 0.15)
    lab <- paste0(m, ":", grp)
    split_res[[lab]] <- cbind(moderator = m, group = grp, n_la = uniqueN(sub$code),
                              summarise_hansen(h, lab))
    ct <- coeftable(h$fit)
    split_coef[[lab]] <- data.table(moderator = m, group = grp, term = rownames(ct), est = ct[, 1], se = ct[, 2], p = ct[, 4])
    # also the linear (no-threshold) slope within the group
    lin <- feols(as.formula(paste("dlnrent_all ~ soc2 + aq2 + rtb2 +", CTRL, "| code + region_year")), sub, cluster = ~code)
    cl <- coeftable(lin)
    split_coef[[paste0(lab, ":lin")]] <- data.table(moderator = m, group = grp, term = paste0(rownames(cl), "_linear"),
                                                    est = cl[, 1], se = cl[, 2], p = cl[, 4])
  }
}
split_res <- rbindlist(split_res); split_coef <- rbindlist(split_coef)
fwrite(split_res, file.path(TAB, "rq3_split_thresholds.csv")); fwrite(split_coef, file.path(TAB, "rq3_split_coefs.csv"))

## (b) index threshold: q_it = SH_share_it + theta * Z_i  (so tau_i = tau0 - theta*Z_i) ------------
index_threshold <- function(d, zvar, thetas = seq(-6, 6, by = 0.5), nboot = NB) {
  d <- as.data.frame(d)
  fit_grid <- function(dd) {
    fe_df <- dd[, c("code", "region_year")]
    Y <- .dm(dd[, "dlnrent_all", drop = FALSE], fe_df)[, 1]
    Zd <- .dm(dd[, c(ctrl, "aq2", "rtb2")], fe_df)
    X <- as.matrix(dd[, "soc2", drop = FALSE]); colnames(X) <- "soc2"
    best <- c(ssr = Inf, theta = NA, tau = NA)
    for (th in thetas) {
      q <- dd$sh_share_l1 + th * dd[[zvar]]
      for (g in .make_grid(q, 0.15, 0.025)) {
        s <- .ssr(Y, cbind(.dm(.regime_X(X, q, g), fe_df), Zd))
        if (s < best["ssr"]) best <- c(ssr = s, theta = th, tau = g)
      }
    }
    best
  }
  est <- fit_grid(d)
  # LA-cluster pairs bootstrap for theta and tau0
  las <- unique(d$code); bt <- matrix(NA, nboot, 2)
  for (b in seq_len(nboot)) {
    draw <- sample(las, length(las), replace = TRUE)
    db <- do.call(rbind, lapply(seq_along(draw), function(k) { x <- d[d$code == draw[k], ]; x$code <- paste0(x$code, "_", k); x }))
    bt[b, ] <- fit_grid(db)[c("theta", "tau")]
  }
  data.frame(moderator = zvar, theta = est["theta"], tau0 = est["tau"],
             theta_lo = quantile(bt[, 1], .025), theta_hi = quantile(bt[, 1], .975),
             tau_lo = quantile(bt[, 2], .025), tau_hi = quantile(bt[, 2], .975),
             share_boot_theta0 = mean(bt[, 1] == 0), row.names = NULL)
}
NBI <- as.integer(Sys.getenv("NBOOT_INDEX", "99"))
idx <- rbindlist(lapply(paste0(names(MODS), "_z"), function(z) { cat("index threshold:", z, "\n"); index_threshold(A, z, nboot = NBI) }))
fwrite(idx, file.path(TAB, "rq3_index_threshold.csv"))

## (c) multilevel random-coefficient model with cross-level interactions (RQ4) -----------
# Within-transform outcome and flows by LA and region-year first (equivalent to the FE models), then
# allow LA-specific slopes on new supply with partial pooling.
fe_df <- as.data.frame(A[, .(code, region_year)])
W <- as.data.table(.dm(A[, c("dlnrent_all", "soc2", "rtb2", "aq2", ctrl), with = FALSE], fe_df))
setnames(W, paste0(names(W), "_w"))
W[, code := A$code]
for (m in names(MODS)) W[, paste0(m, "_z") := A[[paste0(m, "_z")]]]
W[, sh_share_l1_c := (A$sh_share_l1 - mean(A$sh_share_l1)) / 10]  # per 10 pp
fml0 <- paste("dlnrent_all_w ~ soc2_w + rtb2_w + aq2_w +", paste(paste0(ctrl, "_w"), collapse = " + "))
mm0 <- lmer(as.formula(paste(fml0, "+ (0 + soc2_w | code)")), W, REML = TRUE)
inter <- paste(c("sh_share_l1_c", paste0(names(MODS), "_z")), collapse = " + ")
fml1 <- paste(fml0, "+ soc2_w:(", inter, ") + rtb2_w:(", inter, ") + (0 + soc2_w | code)")
mm1 <- lmer(as.formula(fml1), W, REML = TRUE)
# Also the same cross-level interactions in the FE framework (cluster-robust inference) for comparison
for (m in names(MODS)) A[, paste0(m, "_z") := (get(m) - mean(get(m))) / sd(get(m))]
A[, sh10 := (sh_share_l1 - mean(sh_share_l1)) / 10]
fe_int <- feols(as.formula(paste("dlnrent_all ~ soc2 + rtb2 + aq2 + soc2:(sh10 +", paste(paste0(names(MODS), "_z"), collapse = " + "),
                                 ") + rtb2:(sh10 +", paste(paste0(names(MODS), "_z"), collapse = " + "), ") +", CTRL,
                                 "| code + region_year")), A, cluster = ~code)
# also: do moderators shift the LEVEL association with the SH share? (SH share x Z, within LA)
fe_lvl <- feols(as.formula(paste("dlnrent_all ~ sh_share_l1 + sh_share_l1:(", paste(paste0(names(MODS), "_z"), collapse = " + "),
                                 ") +", CTRL, "| code + region_year")), A, cluster = ~code)
ml_tab <- function(m, lab) { ct <- summary(m)$coefficients; data.table(model = lab, term = rownames(ct), est = ct[, 1], se = ct[, 2],
                                                                       t = ct[, 3]) }
fwrite(rbind(ml_tab(mm0, "ML: random slope, no moderators"), ml_tab(mm1, "ML: cross-level interactions")),
       file.path(TAB, "rq4_multilevel_coefs.csv"))
save_coefs(list(FE_interactions_flows = fe_int, FE_interactions_level = fe_lvl), "rq4_fe_interaction_coefs.csv")
vc <- as.data.frame(VarCorr(mm0)); vc1 <- as.data.frame(VarCorr(mm1))
re <- ranef(mm0)$code; names(re) <- "u"; re$code <- rownames(re)
re <- merge(re, unique(A[, .(code, name, region, sh_share_2014, prs_share11, refusal_major, ar_share_new, vac_rate_2014, dissim21)]), by = "code")
re$slope <- fixef(mm0)["soc2_w"] + re$u
fwrite(re, file.path(TAB, "rq3_la_specific_slopes.csv"))
lrt <- anova(update(mm0, REML = FALSE), lm(as.formula(fml0), W))
sink(file.path(TAB, "rq34_summary.txt"))
cat("=== (a) split-sample thresholds (new build regime by SH share) ===\n"); print(split_res)
cat("\n=== (b) index thresholds tau_i = tau0 - theta*Z_i (Z standardised) ===\n"); print(idx)
cat("\n=== (c) multilevel: random-slope SD on new build ===\n"); print(vc); print(summary(mm0)$coefficients)
cat("\nLR test random slope vs none (chi2, approx; boundary => conservative):\n"); print(lrt)
cat("\nCross-level interactions:\n"); print(summary(mm1)$coefficients); print(vc1)
cat("\n=== FE cross-level interactions (clustered SE) ===\n"); print(etable(fe_int, fe_lvl))
sink()

## figure: moderator-specific linear slopes of new build and RTB ----------------------
sc <- split_coef[grepl("_linear$", term) & term %in% c("soc2_linear", "rtb2_linear")]
sc[, lab := fifelse(moderator == "london", "London vs rest", MODS[moderator])]
sc[, term := fifelse(term == "soc2_linear", "Social/affordable new build (2-yr, per 1,000)", "Right to Buy sales (2-yr, per 1,000)")]
sc[, group := factor(group, levels = c("low", "high"), labels = c("Below median / rest of England", "Above median / London"))]
g <- ggplot(sc, aes(est, lab, colour = group)) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_pointrange(aes(xmin = est - 1.96 * se, xmax = est + 1.96 * se), position = position_dodge(width = 0.5)) +
  facet_wrap(~term, scales = "free_x") + scale_colour_manual(values = c("#1f4e79", "#c55a11")) +
  labs(x = "Effect on private rent growth (pp)", y = NULL, colour = NULL,
       title = "Figure 5. Heterogeneity in rent effects of social housing flows by market institutions") + theme_paper
ggsave(file.path(FIG, "fig5_heterogeneity.png"), g, width = 9, height = 4.8, dpi = 300)
cat("RQ3-4 done\n")
