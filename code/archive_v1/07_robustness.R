# 07_robustness.R -- robustness of the core flow specification and the stabilisation (volatility) outcome
source("code/00_setup.R")
A <- fread(file.path(ROOT, "data", "clean", "analysis_with_flows.csv"))
A[, region_year := paste(region, year)]
SL <- fread(file.path(ROOT, "data", "clean", "spatial_lags.csv"))
A <- merge(A, SL, by = c("code", "year"), all.x = TRUE)
for (v in c("W_soc2", "W_aq2", "W_rtb2")) A[is.na(get(v)), (v) := 0]  # Isle of Wight: no land neighbours
PR <- fread(file.path(ROOT, "data", "clean", "prms_la_bedroom_2014_2023.csv"))
A <- merge(A, PR[, .(code, year, dlnprms_all, prms_count_all)], by = c("code", "year"), all.x = TRUE)
setkey(P, code, year); P[, sh_share_l2 := shift(sh_share, 2), by = code]
A <- merge(A, P[, .(code, year, sh_share_l2)], by = c("code", "year"), all.x = TRUE)
A <- merge(A, P[year == 2015, .(code, pop15 = pop)], by = "code")  # time-invariant weight (2025 MYE not yet published)
A[, dlnrentlvl := 100 * (log(rentlvl_all) - log(shift(rentlvl_all))), by = code]
A[year == 2016, dlnrentlvl := NA]
lv <- P[year == 2015, .(code, lvl15 = rentlvl_all)]
A <- merge(A, lv, by = "code"); A[year == 2016, dlnrentlvl := 100 * (log(rentlvl_all) - log(lvl15))]

core <- "soc2 + aq2 + rtb2"
fr <- function(rhs = core, d = A, fe = "code + region_year", dep = "dlnrent_all", w = NULL, cl = ~code)
  feols(as.formula(paste(dep, "~", rhs, "+", CTRL, "|", fe)), d, cluster = cl, weights = w)
R <- list(
  `Baseline` = fr(),
  `Year FE only` = fr(fe = "code + year"),
  `Excl. London` = fr(d = A[london == 0]),
  `Excl. 2020-21` = fr(d = A[!year %in% 2020:2021]),
  `Pop.-weighted (2015)` = fr(w = ~pop15),
  `LA linear trends` = fr(fe = "code[year] + region_year"),
  `Two-way cluster` = fr(cl = ~code + region_year),
  `Spatial lags` = fr(rhs = paste(core, "+ W_soc2 + W_aq2 + W_rtb2")),
  `Outcome: PIPR rent level` = fr(dep = "dlnrentlvl"),
  `Outcome: PRMS median` = fr(dep = "dlnprms_all", d = A[is.finite(dlnprms_all) & abs(dlnprms_all) < 40], w = ~prms_count_all)
)
Rs <- list(`Share t-1 (baseline)` = fr(rhs = "sh_share_l1"), `Share t-2` = fr(rhs = "sh_share_l2"),
           `Share t-1, excl. London` = fr(rhs = "sh_share_l1", d = A[london == 0]),
           `Share t-1, year FE` = fr(rhs = "sh_share_l1", fe = "code + year"))
save_coefs(c(R, Rs), "robustness_coefs.csv")
etable(R, keep = c("soc2", "aq2", "rtb2", "W_"), tex = TRUE, file = file.path(TAB, "robustness_flows.tex"), replace = TRUE,
       title = "Robustness of the flow specification")
etable(Rs, keep = c("SH share", "sh_share"), tex = TRUE, file = file.path(TAB, "robustness_share.tex"), replace = TRUE,
       title = "Robustness of the stock-share specification")

## stabilisation: does a higher social share dampen rent / house-price VOLATILITY? (cross-section)
V <- fread(file.path(ROOT, "data", "clean", "volatility_2016_2025.csv"))
LD <- fread(file.path(ROOT, "data", "clean", "long_difference_2015_2025.csv"))
V <- merge(V, LD, by = "code")
v1 <- feols(rent_yoy_sd ~ sh14 + dlnpop + dlnpay + unemp + netadd + lvl15 | region, V, vcov = "hetero")
v2 <- feols(rent_yoy_sd ~ sh14 + I(sh14^2) + dlnpop + dlnpay + unemp + netadd + lvl15 | region, V, vcov = "hetero")
v3 <- feols(hp_yoy_sd ~ sh14 + dlnpop + dlnpay + unemp + netadd + lvl15 | region, V, vcov = "hetero")
v4 <- feols(hp_yoy_sd ~ sh14 + I(sh14^2) + dlnpop + dlnpay + unemp + netadd + lvl15 | region, V, vcov = "hetero")
save_coefs(list(rent_vol = v1, rent_vol_quad = v2, hp_vol = v3, hp_vol_quad = v4), "stabilisation_coefs.csv")
etable(v1, v2, v3, v4, tex = TRUE, file = file.path(TAB, "stabilisation.tex"), replace = TRUE,
       title = "Stabilisation: SD of year-on-year growth (2016-2025) and the 2014 social housing share")
sink(file.path(TAB, "robustness_summary.txt"))
print(etable(R, keep = c("soc2", "aq2", "rtb2", "W_"))); print(etable(Rs, keep = c("SH share", "sh_share"))); print(etable(v1, v2, v3, v4))
sink()

# coefficient plot
rc <- rbindlist(lapply(names(R), function(n) { ct <- coeftable(R[[n]])
  data.table(spec = n, term = rownames(ct), est = ct[, 1], se = ct[, 2]) }))[term %in% c("soc2", "rtb2", "aq2")]
rc[, term := factor(term, c("soc2", "aq2", "rtb2"), c("Social/affordable new build", "Rental acquisitions", "Right to Buy sales"))]
rc[, spec := factor(spec, levels = rev(names(R)))]
g <- ggplot(rc, aes(est, spec)) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_pointrange(aes(xmin = est - 1.96 * se, xmax = est + 1.96 * se), colour = "#1f4e79", size = 0.3) +
  facet_wrap(~term, scales = "free_x") +
  labs(x = "Effect on private rent growth (pp per 1,000 dwellings, 2-year cumulative flow)", y = NULL,
       title = "Figure 8. Robustness of flow effects") + theme_paper
ggsave(file.path(FIG, "fig8_robustness.png"), g, width = 9, height = 4.5, dpi = 300)
cat("robustness done\n")
