# 04_rq2_nonlinear.R -- RQ2: is the relationship nonlinear, and is there an identifiable threshold?
# Step 1: let the data draw the curve (restricted cubic splines / GAM), without pre-specifying cut points
# Step 2: formal threshold estimation (Hansen 1999 FE panel threshold; Hansen 2000 cross-section)
# Three complementary objects:
#   (L) level:  private rent growth as a function of the lagged SH share (between + within variation)
#   (F) flow-by-regime: does the rent effect of new social supply / RTB losses depend on the stock share?
#   (X) long difference: 2015-25 cumulative growth on the 2014 share (pure cross-section)
source("code/00_setup.R")
source("code/threshold_functions.R")
suppressPackageStartupMessages({ library(mgcv); library(splines) })
NB <- as.integer(Sys.getenv("NBOOT", "499"))
ctrl <- strsplit(CTRL, " \\+ ")[[1]]

setkey(P, code, year)
P[, `:=`(soc_l1 = shift(soc_nb_pk), aq_l1 = shift(aq_pk), rtb_l1 = shift(rtb_pk)), by = code]
A <- merge(A, P[, .(code, year, soc_l1, aq_l1, rtb_l1)], by = c("code", "year"))
A[, `:=`(soc2 = soc_nb_pk + soc_l1, aq2 = aq_pk + aq_l1, rtb2 = rtb_pk + rtb_l1)]  # 2-year cumulative flows
A[, code_f := factor(code)]; A[, ry_f := factor(region_year)]
fwrite(A, file.path(ROOT, "data", "clean", "analysis_with_flows.csv"))

## ---------------- Step 1: splines / GAM ------------------------------------------
# (L1) pooled GAM with LA random intercepts and region-year fixed effects
g1 <- gam(as.formula(paste("dlnrent_all ~ s(sh_share_l1, k = 8) +", CTRL, "+ ry_f + s(code_f, bs = 're')")),
          data = A, method = "REML")
# (L2) within-LA restricted cubic spline (LA + region-year FE): identified only from within-LA changes
A[, paste0("ns", 1:3) := as.data.table(ns(sh_share_l1, df = 3))]
l2 <- feols(as.formula(paste("dlnrent_all ~ ns1 + ns2 + ns3 +", CTRL, "| code + region_year")), A, cluster = ~code)
# (X1) cross-section GAM on long differences
LD <- fread(file.path(ROOT, "data", "clean", "long_difference_2015_2025.csv"))
LD[, region_f := factor(region)]
x1 <- gam(cumg ~ s(sh14, k = 8) + dlnpop + dlnpay + unemp + netadd + lvl15 + region_f, data = LD, method = "REML")
# (F1) varying-coefficient GAM: marginal effect of flows as a smooth function of the SH share
f1 <- gam(as.formula(paste("dlnrent_all ~ s(sh_share_l1, k = 6) + s(sh_share_l1, by = soc2, k = 6) +",
                           "s(sh_share_l1, by = rtb2, k = 6) + aq2 +", CTRL, "+ ry_f + s(code_f, bs = 're')")),
          data = A, method = "REML")
sink(file.path(TAB, "rq2_gam_summaries.txt"))
cat("=== (L1) pooled GAM ===\n"); print(summary(g1)$s.table)
cat("\n=== (L2) within-LA natural spline (LA + region-year FE) ===\n"); print(coeftable(l2)[1:3, ])
cat("Joint test spline terms:\n"); print(wald(l2, keep = "^ns", print = FALSE)[c("stat", "p")])
cat("\n=== (X1) long-difference GAM ===\n"); print(summary(x1)$s.table); print(summary(x1)$p.table[2:6, ])
cat("\n=== (F1) varying-coefficient GAM ===\n"); print(summary(f1)$s.table); print(summary(f1)$p.table["aq2", ])
sink()

# curves for plotting
grid_sh <- seq(quantile(A$sh_share_l1, .01), quantile(A$sh_share_l1, .99), length.out = 120)
pred_smooth <- function(m, term, xname, xs, by = NULL) {
  nd <- as.data.frame(lapply(m$model, function(v) if (is.numeric(v)) rep(mean(v), length(xs)) else rep(v[1], length(xs))))
  nd[[xname]] <- xs
  if (!is.null(by)) nd[[by]] <- 1
  lp <- predict(m, nd, type = "lpmatrix")
  cols <- grep(term, colnames(lp), fixed = TRUE)
  fit <- lp[, cols, drop = FALSE] %*% coef(m)[cols]
  se <- sqrt(rowSums((lp[, cols, drop = FALSE] %*% m$Vp[cols, cols]) * lp[, cols, drop = FALSE]))
  data.table(x = xs, fit = as.numeric(fit), se = se)
}
cv <- rbind(
  cbind(panel = "(a) Pooled GAM: rent growth vs SH share", pred_smooth(g1, "s(sh_share_l1)", "sh_share_l1", grid_sh)),
  cbind(panel = "(b) Long difference 2015-25 vs 2014 share",
        pred_smooth(x1, "s(sh14)", "sh14", seq(quantile(LD$sh14, .01), quantile(LD$sh14, .99), length.out = 120))),
  cbind(panel = "(c) Marginal effect of social new build (2-yr, per 1,000)",
        pred_smooth(f1, "s(sh_share_l1):soc2", "sh_share_l1", grid_sh, by = "soc2")),
  cbind(panel = "(d) Marginal effect of Right to Buy sales (2-yr, per 1,000)",
        pred_smooth(f1, "s(sh_share_l1):rtb2", "sh_share_l1", grid_sh, by = "rtb2")))
fwrite(cv, file.path(TAB, "rq2_curves.csv"))

## ---------------- Step 2: Hansen threshold models --------------------------------
t0 <- Sys.time()
hL <- hansen_fe(A, "dlnrent_all", "sh_share_l1", "sh_share_l1", ctrl, nboot = NB)
hF <- hansen_fe(A, "dlnrent_all", c("soc2", "rtb2"), "sh_share_l1", c(ctrl, "aq2"), nboot = NB)
hFs <- hansen_fe(A, "dlnrent_all", "soc2", "sh_share_l1", c(ctrl, "aq2", "rtb2"), nboot = NB)
hFr <- hansen_fe(A, "dlnrent_all", "rtb2", "sh_share_l1", c(ctrl, "aq2", "soc2"), nboot = NB)
# Alternative regime variable: Census 2021 social-rented share of households (time-invariant; validates the
# threshold location against measurement error in Table 100)
hFsc <- hansen_fe(A, "dlnrent_all", "soc2", "soc_hh_share21", c(ctrl, "aq2", "rtb2"), nboot = NB)
hFrc <- hansen_fe(A, "dlnrent_all", "rtb2", "soc_hh_share21", c(ctrl, "aq2", "soc2"), nboot = NB)
hX <- hansen_cs(LD, "cumg", "sh14", "sh14", c("dlnpop", "dlnpay", "unemp", "netadd", "lvl15"), fe = "region", nboot = 999)
cat("threshold models took", format(Sys.time() - t0), "\n")

th <- rbind(summarise_hansen(hL, "L: level (x = q = SH share)"),
            summarise_hansen(hF, "F: new build + RTB, regime by SH share"),
            summarise_hansen(hFs, "F1: new build only, regime by SH share"),
            summarise_hansen(hFr, "F2: RTB only, regime by SH share"),
            summarise_hansen(hFsc, "F1c: new build only, regime by Census 2021 social share"),
            summarise_hansen(hFrc, "F2c: RTB only, regime by Census 2021 social share"),
            data.frame(model = "X: long difference (cross-section)", gamma1 = hX$gamma1, ci_lo = hX$ci1[1], ci_hi = hX$ci1[2],
                       F1 = hX$F1, p_boot1 = hX$p1, gamma2 = NA, F2 = NA, p_boot2 = NA, n = hX$n,
                       regimes_obs = NA, regimes_la = NA))
fwrite(th, file.path(TAB, "rq2_threshold_tests.csv"))
save_coefs(list(L = hL$fit, F = hF$fit, F1 = hFs$fit, F2 = hFr$fit, F1c = hFsc$fit, F2c = hFrc$fit, L2_spline = l2), "rq2_threshold_coefs.csv")
lr <- rbind(data.table(model = "L: level", gamma = hL$grid, LR = hL$LR),
            data.table(model = "F: flows (new build + RTB)", gamma = hF$grid, LR = hF$LR),
            data.table(model = "F1: new build", gamma = hFs$grid, LR = hFs$LR),
            data.table(model = "F2: RTB", gamma = hFr$grid, LR = hFr$LR),
            data.table(model = "X: long difference", gamma = hX$grid, LR = hX$LR))
fwrite(lr, file.path(TAB, "rq2_lr_profiles.csv"))
etable(hL$fit, hF$fit, hFs$fit, hFr$fit, tex = TRUE, file = file.path(TAB, "rq2_threshold_coefs.tex"), replace = TRUE,
       title = "RQ2: regime-specific coefficients at the estimated threshold")
saveRDS(list(hL = hL, hF = hF, hFs = hFs, hFr = hFr, hX = hX), file.path(TAB, "rq2_threshold_objects.rds"))
sink(file.path(TAB, "rq2_threshold_summary.txt")); print(th); print(etable(hL$fit, hF$fit, hFs$fit, hFr$fit)); sink()

## ---------------- Figures -------------------------------------------------------------
cv[, panel := factor(panel, levels = unique(panel))]
vl <- data.table(panel = factor(levels(cv$panel)[3:4], levels = levels(cv$panel)), g = c(hFs$gamma1, hFr$gamma1))
g <- ggplot(cv, aes(x, fit)) + geom_hline(yintercept = 0, colour = "grey50") +
  geom_ribbon(aes(ymin = fit - 1.96 * se, ymax = fit + 1.96 * se), fill = "#9dc3e6", alpha = 0.6) +
  geom_line(colour = "#1f4e79", size = 0.9) +
  geom_vline(data = vl, aes(xintercept = g), linetype = 2, colour = "#c55a11") +
  facet_wrap(~panel, scales = "free", ncol = 2) +
  labs(x = "Social housing share of dwelling stock (%)", y = "Effect on private rent growth (pp)",
       title = "Figure 3. Nonlinear relationships between social housing and private rent growth") + theme_paper
ggsave(file.path(FIG, "fig3_nonlinear_curves.png"), g, width = 8, height = 6, dpi = 300)

g <- ggplot(lr, aes(gamma, LR)) + geom_line(colour = "#1f4e79") +
  geom_hline(yintercept = 7.35, linetype = 2, colour = "#c55a11") + facet_wrap(~model, scales = "free_x") +
  labs(x = "Candidate threshold: SH share (%)", y = "Likelihood ratio LR(gamma)",
       title = "Figure 4. Threshold likelihood-ratio profiles (95% critical value 7.35)") + theme_paper
ggsave(file.path(FIG, "fig4_lr_profiles.png"), g, width = 8, height = 5, dpi = 300)
cat("RQ2 done\n")
