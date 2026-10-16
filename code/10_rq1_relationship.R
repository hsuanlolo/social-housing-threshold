# 10_rq1_relationship.R -- RQ1: how is the social housing (SH) share associated with private rents?
# Two outcomes: (i) the LEVEL of private rents (log average monthly rent, PIPR), 2015-2025;
#               (ii) annual private rent GROWTH, 2016-2025.
# The SH share varies almost only between LAs (within-LA SD 0.43 pp vs between 6.05 pp), so the relationship
# is estimated from cross-LA variation with region-by-year fixed effects and LA-clustered SEs. It is an
# association, not a causal effect. A within-LA (LA fixed effects) column is shown only to document that
# the data contain too little within-LA variation to estimate it.
source("code/00_setup.R")

fit <- function(dep, ctrl, d, fe = "region_year", rhs = "sh_share_l1")
  feols(as.formula(paste(dep, "~", paste(c(rhs, ctrl), collapse = " + "), "|", fe)), d, cluster = ~code)

lev <- lapply(CTRL_L, function(cc) fit("lnrent100", cc, L)); names(lev) <- paste0("level_", names(CTRL_L))
gro <- lapply(CTRL_G, function(cc) fit("dlnrent_all", cc, G)); names(gro) <- paste0("growth_", names(CTRL_G))
lev$level_within <- fit("lnrent100", CTRL_L$M2, L, fe = "code + region_year")
gro$growth_within <- fit("dlnrent_all", CTRL_G$M1, G, fe = "code + region_year")

# affordability outcome: annual rent as % of local median full-time earnings
aff <- fit("rent_to_pay", setdiff(CTRL_L$M3, "ln_pay_l1"), L)

# long-difference cross-section of growth 2015 -> 2025 (one observation per LA)
LD <- P[year == 2025, .(code, region, l25 = log(idx_all))][P[year == 2015, .(code, l15 = log(idx_all),
       lvl15 = log(rentlvl_all), dens15 = ln_density, pay15 = ln_pay)], on = "code"][P[year == 2014, .(code, sh14 = sh_share)], on = "code"]
LD <- merge(LD, P[year %between% c(2015, 2024), .(dlnpop = mean(dlnpop, na.rm = TRUE), dlnpay = mean(dlnpay, na.rm = TRUE),
                                                  unemp = mean(unemp, na.rm = TRUE), netadd = mean(netadd_pk, na.rm = TRUE)), by = code], by = "code")
LD <- merge(LD, unique(P[, .(code, imd19)]), by = "code")
LD[, cumg := 100 * (l25 - l15) / 10]
ld <- feols(cumg ~ sh14 + dlnpop + dlnpay + unemp + netadd + lvl15 + dens15 + imd19 | region, LD, vcov = "hetero")
fwrite(LD, file.path(ROOT, "data", "clean", "long_difference_2015_2025.csv"))

save_coefs(c(lev, gro, list(affordability = aff, long_difference = ld)), "rq1_relationship_coefs.csv")
sink(file.path(TAB, "rq1_summary.txt"))
print(etable(lev)); print(etable(gro)); print(etable(aff, ld))
cat("\nWithin-LA SD of SH share:", round(sd(P[year %between% c(2015, 2024), sh_share - mean(sh_share), by = code]$V1), 3), "\n")
sink()

# binned scatter (residualised on region-year FE) for Figure 2
bs <- function(d, y) {
  d <- copy(d); d[, ry := residuals(feols(as.formula(paste(y, "~ 1 | region_year")), d))]
  d[, xr := residuals(feols(sh_share_l1 ~ 1 | region_year, d))]
  d[, bin := cut(sh_share_l1, quantile(sh_share_l1, 0:20 / 20), include.lowest = TRUE)]
  d[, .(x = mean(sh_share_l1), y = mean(ry), n = .N), by = bin]
}
bsd <- rbind(cbind(outcome = "(a) Log private rent level (x100), 2015-2025", bs(L, "lnrent100")),
             cbind(outcome = "(b) Private rent growth (%), 2016-2025", bs(G, "dlnrent_all")))
fwrite(bsd, file.path(TAB, "rq1_binscatter.csv"))
g <- ggplot(bsd, aes(x, y)) + geom_hline(yintercept = 0, colour = "grey60") + geom_point(colour = "#1f4e79", size = 2) +
  geom_smooth(method = "loess", se = FALSE, colour = "#c55a11", size = 0.7, span = 0.9) +
  facet_wrap(~outcome, scales = "free_y") +
  labs(x = "Social housing share of dwelling stock, t-1 (%)", y = "Mean (net of region-by-year effects)") + theme_paper
ggsave(file.path(FIG, "fig2_binscatter.png"), g, width = 8.5, height = 4, dpi = 300)
cat("RQ1 done\n")
