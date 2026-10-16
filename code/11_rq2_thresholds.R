# 11_rq2_thresholds.R -- RQ2: is there a threshold (or interval) of the SH share beyond which the association
# with private rents changes? In which interval is it strongest, and does it reverse?
# (a) interval (binned) model, (b) GAM smooth and its derivative, (c) Hansen threshold (with level jump) and
# continuous kink models with wild-cluster bootstrap, for rent levels and rent growth;
# (d) where does ADDING (new build) or LOSING (Right to Buy) social housing move rents most? Flow effects by
#     share interval, identified within LAs (LA + region-by-year FE).
source("code/00_setup.R")
source("code/threshold_functions.R")
suppressPackageStartupMessages(library(mgcv))
NB <- as.integer(Sys.getenv("NBOOT", "499"))
L <- L[complete.cases(L[, c("lnrent100", "sh_share_l1", CTRL_L$M3), with = FALSE])]
G <- G[complete.cases(G[, c("dlnrent_all", "sh_share_l1", "soc2", "rtb2", "aq2", CTRL_G$M3), with = FALSE])]
cat("level N =", nrow(L), " growth N =", nrow(G), "\n")
L[, shbin := cut(sh_share_l1, SHBINS, SHLAB, right = FALSE)]
G[, shbin := cut(sh_share_l1, SHBINS, SHLAB, right = FALSE)]
L[, shbin := relevel(shbin, "10-15%")]; G[, shbin := relevel(shbin, "10-15%")]
binN <- G[, .(LAs = uniqueN(code), obs = .N, london = sum(region == "London") / .N), by = shbin][order(shbin)]
fwrite(binN, file.path(TAB, "rq2_bin_counts.csv"))

## (a) interval model --------------------------------------------------------------------
fb <- function(dep, ctrl, d) feols(as.formula(paste(dep, "~ i(shbin, ref = '10-15%')", if (length(ctrl)) "+", paste(ctrl, collapse = "+"),
                                                    "| region_year")), d, cluster = ~code)
bins <- list(level_raw = fb("lnrent100", NULL, L), level_full = fb("lnrent100", CTRL_L$M3, L),
             growth_raw = fb("dlnrent_all", NULL, G), growth_full = fb("dlnrent_all", CTRL_G$M3, G))
save_coefs(bins, "rq2_interval_coefs.csv")

## (b) smooth curve and its derivative --------------------------------------------------------
# Natural cubic spline in the share (df = 4, knots at quantiles) estimated with the same region-by-year FE,
# controls and LA-clustered SEs as the other models; the local slope (derivative) and its pointwise and
# simultaneous (sup-t, simulated) 95% bands are computed with the delta method. A penalised GAM (mgcv,
# no LA random effect, so that between-LA variation is used as in all other models) checks the shape.
suppressPackageStartupMessages(library(splines))
spl_curve <- function(d, dep, ctrl, lab, df = 4) {
  kn <- quantile(d$sh_share_l1, seq(0, 1, length.out = df + 1))[-c(1, df + 1)]; bk <- range(d$sh_share_l1)
  B <- ns(d$sh_share_l1, knots = kn, Boundary.knots = bk); colnames(B) <- paste0("ns", 1:df)
  dd <- cbind(d, B)
  m <- feols(as.formula(paste(dep, "~", paste(colnames(B), collapse = "+"), "+", paste(ctrl, collapse = "+"), "| region_year")),
             dd, cluster = ~code)
  xs <- seq(quantile(d$sh_share_l1, .01), quantile(d$sh_share_l1, .99), length.out = 150)
  Bx <- ns(xs, knots = kn, Boundary.knots = bk); Bx2 <- ns(xs + 0.01, knots = kn, Boundary.knots = bk)
  x0 <- ns(12.5, knots = kn, Boundary.knots = bk)   # curve normalised to 0 at 12.5% (middle of the reference interval)
  b <- coef(m)[colnames(B)]; V <- vcov(m)[colnames(B), colnames(B)]
  Fm <- sweep(Bx, 2, x0); D <- (Bx2 - Bx) / 0.01
  dfit <- as.numeric(D %*% b); dse <- sqrt(rowSums((D %*% V) * D))
  sims <- MASS::mvrnorm(5000, b, V); crit <- quantile(apply(abs((D %*% t(sims) - dfit) / dse), 2, max), 0.95)
  lin <- wald(m, keep = "^ns[2-9]", print = FALSE)  # not a linearity test (ns basis); see Wald on linear model below
  data.table(outcome = lab, x = xs, fit = as.numeric(Fm %*% b), se = sqrt(rowSums((Fm %*% V) * Fm)),
             deriv = dfit, dse = dse, crit = crit)
}
cv <- rbind(spl_curve(L, "lnrent100", CTRL_L$M3, "Log private rent level (x100)"),
            spl_curve(G, "dlnrent_all", CTRL_G$M3, "Private rent growth (pp)"))
fwrite(cv, file.path(TAB, "rq2_spline_curves.csv"))
# formal linearity test: add spline terms to the linear model and test them jointly (LA-clustered Wald)
lin_test <- function(d, dep, ctrl) {
  B <- ns(d$sh_share_l1, df = 4); nl <- B[, 2:4] - 0; colnames(nl) <- paste0("nl", 1:3)
  # orthogonalise the nonlinear part against the linear term
  nl <- apply(nl, 2, function(v) residuals(lm(v ~ d$sh_share_l1)))
  dd <- cbind(d, nl)
  m <- feols(as.formula(paste(dep, "~ sh_share_l1 + nl1 + nl2 + nl3 +", paste(ctrl, collapse = "+"), "| region_year")), dd, cluster = ~code)
  unlist(wald(m, keep = "^nl", print = FALSE)[c("stat", "p")])
}
lt <- rbind(data.table(outcome = "Rent level", t(lin_test(L, "lnrent100", CTRL_L$M3))),
            data.table(outcome = "Rent growth", t(lin_test(G, "dlnrent_all", CTRL_G$M3))))
fwrite(lt, file.path(TAB, "rq2_linearity_tests.csv"))
L[, ry_f := factor(region_year)]; G[, ry_f := factor(region_year)]
gm_l <- gam(as.formula(paste("lnrent100 ~ s(sh_share_l1, k = 8) +", paste(CTRL_L$M3, collapse = "+"), "+ ry_f")), data = L, method = "REML")
gm_g <- gam(as.formula(paste("dlnrent_all ~ s(sh_share_l1, k = 8) +", paste(CTRL_G$M3, collapse = "+"), "+ ry_f")), data = G, method = "REML")
sink(file.path(TAB, "rq2_gam_summary.txt"))
cat("Penalised GAM shape check (edf near 1 = linear):\n"); print(summary(gm_l)$s.table); print(summary(gm_g)$s.table)
cat("\nLinearity tests (spline deviations from linear, LA-clustered Wald):\n"); print(lt)
cat("\nShare ranges where the spline slope is significantly != 0 (pointwise 95%):\n")
print(cv[, .(lo = min(x), hi = max(x)), by = .(outcome, sign = fifelse(deriv - 1.96 * dse > 0, "positive", fifelse(deriv + 1.96 * dse < 0, "negative", "n.s.")))])
sink()

## (c) Hansen threshold (jump) and kink models ----------------------------------------------
hl <- hansen_fe(L, "lnrent100", "sh_share_l1", "sh_share_l1", CTRL_L$M3, fe = "region_year", nboot = NB, shift = TRUE)
hg <- hansen_fe(G, "dlnrent_all", "sh_share_l1", "sh_share_l1", CTRL_G$M3, fe = "region_year", nboot = NB, shift = TRUE)
kl <- hansen_kink(L, "lnrent100", "sh_share_l1", CTRL_L$M3, nboot = NB)
kg <- hansen_kink(G, "dlnrent_all", "sh_share_l1", CTRL_G$M3, nboot = NB)
th <- rbind(cbind(outcome = "Rent level", summarise_hansen(hl, "Threshold (slope + jump)")),
            cbind(outcome = "Rent growth", summarise_hansen(hg, "Threshold (slope + jump)")))
kk <- rbindlist(lapply(list(`Rent level` = kl, `Rent growth` = kg), function(k)
  data.table(model = "Kink (continuous)", gamma = k$gamma, ci_lo = k$ci[1], ci_hi = k$ci[2], F = k$F, p_boot = k$p,
             slope_below = k$slope_below, se_below = k$se_below, slope_above = k$slope_above, se_above = k$se_above)), idcol = "outcome")
fwrite(th, file.path(TAB, "rq2_threshold_tests.csv")); fwrite(kk, file.path(TAB, "rq2_kink_tests.csv"))
save_coefs(list(level_threshold = hl$fit, growth_threshold = hg$fit, level_kink = kl$fit, growth_kink = kg$fit), "rq2_threshold_coefs.csv")
lr <- rbind(data.table(outcome = "Rent level", model = "Threshold", gamma = hl$grid, LR = hl$LR),
            data.table(outcome = "Rent growth", model = "Threshold", gamma = hg$grid, LR = hg$LR),
            data.table(outcome = "Rent level", model = "Kink", gamma = kl$grid, LR = kl$LR),
            data.table(outcome = "Rent growth", model = "Kink", gamma = kg$grid, LR = kg$LR))
fwrite(lr, file.path(TAB, "rq2_lr_profiles.csv"))

## (d) flows by share interval (within-LA) ---------------------------------------------------
G[, iv := cut(sh_share_l1, c(0, 12, 16, 22, 100), c("<12%", "12-16%", "16-22%", ">=22%"), right = FALSE)]
fl_ctrl <- c(CTRL_G$M1, "netadd_pk_l1", "aq2")
fi <- feols(as.formula(paste("dlnrent_all ~ i(iv, soc2) + i(iv, rtb2) +", paste(fl_ctrl, collapse = "+"), "| code + region_year")),
            G, cluster = ~code)
flin <- feols(as.formula(paste("dlnrent_all ~ soc2 + rtb2 +", paste(fl_ctrl, collapse = "+"), "| code + region_year")), G, cluster = ~code)
eq <- rbind(data.table(test = "New build equal across intervals", t(unlist(wald(fi, keep = "soc2", print = FALSE)[c("stat", "p")]))),
            data.table(test = "RTB equal across intervals", t(unlist(wald(fi, keep = "rtb2", print = FALSE)[c("stat", "p")]))))
# note: wald() above tests joint nullity; equality tests below
eqt <- function(m, v) { k <- grep(paste0(":", v, "$"), names(coef(m)), value = TRUE); b <- coef(m)[k]; V <- vcov(m)[k, k]
  R <- cbind(-1, diag(length(k) - 1)); w <- t(R %*% b) %*% solve(R %*% V %*% t(R)) %*% (R %*% b)
  c(stat = as.numeric(w) / (length(k) - 1), p = pf(as.numeric(w) / (length(k) - 1), length(k) - 1, fi$nobs - 1, lower.tail = FALSE)) }
eq <- rbind(data.table(test = "New-build effect equal across intervals", t(eqt(fi, "soc2"))),
            data.table(test = "RTB effect equal across intervals", t(eqt(fi, "rtb2"))))
ivN <- G[, .(LAs = uniqueN(code), mean_soc2 = mean(soc2), mean_rtb2 = mean(rtb2)), by = iv][order(iv)]
fhs <- hansen_fe(G, "dlnrent_all", "soc2", "sh_share_l1", c(fl_ctrl, "rtb2"), nboot = NB)
fhr <- hansen_fe(G, "dlnrent_all", "rtb2", "sh_share_l1", c(fl_ctrl, "soc2"), nboot = NB)
fth <- rbind(summarise_hansen(fhs, "New build, regime by SH share"), summarise_hansen(fhr, "RTB, regime by SH share"))
fwrite(fth, file.path(TAB, "rq2_flow_threshold_tests.csv")); fwrite(eq, file.path(TAB, "rq2_flow_equality_tests.csv"))
fwrite(ivN, file.path(TAB, "rq2_flow_interval_counts.csv"))
save_coefs(list(flow_intervals = fi, flow_linear = flin, flow_thr_nb = fhs$fit, flow_thr_rtb = fhr$fit), "rq2_flow_coefs.csv")
sink(file.path(TAB, "rq2_summary.txt")); print(binN); print(etable(bins)); print(th); print(kk); print(etable(fi, flin)); print(eq); print(ivN); print(fth); sink()

## figures ------------------------------------------------------------------------------------
bc <- rbindlist(lapply(c("level_full", "growth_full"), function(m) { ct <- as.data.table(coeftable(bins[[m]]), keep.rownames = "term")[grepl("shbin", term)]
  ct[, .(outcome = m, bin = sub("shbin::", "", term), est = Estimate, se = `Std. Error`)] }))
bc <- rbind(bc, data.table(outcome = c("level_full", "growth_full"), bin = "10-15%", est = 0, se = 0))
bc[, bin := factor(bin, SHLAB)]
bc[, outcome := factor(outcome, c("level_full", "growth_full"), c("(a) Log private rent level (x100)", "(b) Private rent growth (pp)"))]
bc <- merge(bc, binN[, .(bin = shbin, LAs)], by = "bin")
g1 <- ggplot(bc, aes(bin, est)) + geom_hline(yintercept = 0, colour = "grey50") +
  geom_pointrange(aes(ymin = est - 1.96 * se, ymax = est + 1.96 * se), colour = "#1f4e79") +
  geom_text(aes(y = est + 1.96 * se, label = paste0("n=", LAs)), vjust = -0.6, size = 2.8, colour = "grey30") +
  facet_wrap(~outcome, scales = "free_y") +
  labs(x = "Social housing share interval (t-1); reference = 10-15%", y = "Difference from 10-15% interval") + theme_paper
ggsave(file.path(FIG, "fig3_intervals.png"), g1, width = 8.5, height = 4.2, dpi = 300)
cv[, sig := fifelse(deriv - 1.96 * dse > 0 | deriv + 1.96 * dse < 0, "95% pointwise CI excludes 0", "n.s.")]
g2 <- ggplot(cv, aes(x, deriv)) + geom_hline(yintercept = 0, colour = "grey50") +
  geom_ribbon(aes(ymin = deriv - 1.96 * dse, ymax = deriv + 1.96 * dse), fill = "#9dc3e6", alpha = 0.6) +
  geom_ribbon(aes(ymin = deriv - crit * dse, ymax = deriv + crit * dse), fill = NA, colour = "#9dc3e6", linetype = 2) +
  geom_line(colour = "#1f4e79", size = 0.9) +
  geom_vline(data = data.table(outcome = c("Log private rent level (x100)", "Private rent growth (pp)"), g = c(kl$gamma, kg$gamma)),
             aes(xintercept = g), colour = "#c55a11", linetype = 3) +
  facet_wrap(~outcome, scales = "free_y") +
  labs(x = "Social housing share, t-1 (%)", y = "Slope: change in outcome per 1 pp of SH share") + theme_paper
ggsave(file.path(FIG, "fig4_gam_derivative.png"), g2, width = 8.5, height = 4.2, dpi = 300)
fc <- as.data.table(coeftable(fi), keep.rownames = "term")[grepl("iv::", term)]
fc[, `:=`(interval = factor(sub("iv::(.*):.*", "\\1", term), c("<12%", "12-16%", "16-22%", ">=22%")),
          flow = fifelse(grepl("soc2", term), "Adding: social/affordable new build", "Losing: Right to Buy sales"))]
fc <- merge(fc, ivN[, .(interval = iv, LAs)], by = "interval")
g3 <- ggplot(fc, aes(interval, Estimate)) + geom_hline(yintercept = 0, colour = "grey50") +
  geom_pointrange(aes(ymin = Estimate - 1.96 * `Std. Error`, ymax = Estimate + 1.96 * `Std. Error`), colour = "#1f4e79") +
  facet_wrap(~flow, scales = "free_y") +
  labs(x = "Social housing share interval (t-1)", y = "Effect on rent growth (pp per 1,000 dwellings, 2-yr flow)") + theme_paper
ggsave(file.path(FIG, "fig5_flows_by_interval.png"), g3, width = 8.5, height = 4.2, dpi = 300)
cat("RQ2 done\n")
