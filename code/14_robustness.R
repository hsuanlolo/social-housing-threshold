# 14_robustness.R -- Appendix Table C1: linear slope and threshold test under alternative measures and samples
source("code/00_setup.R"); source("code/threshold_functions.R")
NB <- as.integer(Sys.getenv("NBOOT", "299"))
L <- L[complete.cases(L[, c("lnrent100", "sh_share_l1", CTRL_L$M3), with = FALSE])]
G <- G[complete.cases(G[, c("dlnrent_all", "sh_share_l1", CTRL_G$M3), with = FALSE])]
L[, lnrent2b := 100 * ln_rentlvl_b2]
specs <- list(
  list(lab = "Baseline", d = L, y = "lnrent100", q = "sh_share_l1", z = CTRL_L$M3, out = "Rent level"),
  list(lab = "Census 2021 social-rented share of households", d = L, y = "lnrent100", q = "soc_hh_share21", z = CTRL_L$M3, out = "Rent level"),
  list(lab = "Excluding London", d = L[london == 0], y = "lnrent100", q = "sh_share_l1", z = CTRL_L$M3, out = "Rent level"),
  list(lab = "Two-bedroom rent level", d = L, y = "lnrent2b", q = "sh_share_l1", z = CTRL_L$M3, out = "Rent level"),
  list(lab = "Rent as % of median earnings", d = L, y = "rent_to_pay", q = "sh_share_l1", z = setdiff(CTRL_L$M3, "ln_pay_l1"), out = "Affordability"),
  list(lab = "Baseline", d = G, y = "dlnrent_all", q = "sh_share_l1", z = CTRL_G$M3, out = "Rent growth"),
  list(lab = "Census 2021 social-rented share of households", d = G, y = "dlnrent_all", q = "soc_hh_share21", z = CTRL_G$M3, out = "Rent growth"),
  list(lab = "Excluding London", d = G[london == 0], y = "dlnrent_all", q = "sh_share_l1", z = CTRL_G$M3, out = "Rent growth"),
  list(lab = "Excluding 2020-2021", d = G[!year %in% 2020:2021], y = "dlnrent_all", q = "sh_share_l1", z = CTRL_G$M3, out = "Rent growth"))
res <- rbindlist(lapply(specs, function(s) {
  m <- feols(as.formula(paste(s$y, "~", s$q, "+", paste(s$z, collapse = "+"), "| region_year")), s$d, cluster = ~code)
  h <- hansen_fe(s$d, s$y, s$q, s$q, s$z, fe = "region_year", nboot = NB, double = FALSE, shift = TRUE)
  ct <- coeftable(h$fit); r1 <- ct[paste0(s$q, "_r1"), ]; r2 <- ct[paste0(s$q, "_r2"), ]
  data.table(outcome = s$out, spec = s$lab, slope = coef(m)[s$q], se = se(m)[s$q], p = pvalue(m)[s$q], n = nobs(m),
             gamma = h$gamma1, p_boot = h$p1, b_below = r1[1], se_below = r1[2], p_below = r1[4],
             b_above = r2[1], se_above = r2[2], p_above = r2[4])
}))
fwrite(res, file.path(TAB, "robustness_C1.csv")); print(res)
