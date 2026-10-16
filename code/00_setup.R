# 00_setup.R -- common setup sourced by all model scripts (run from project root)
suppressPackageStartupMessages({ library(data.table); library(fixest); library(ggplot2) })
ROOT <- normalizePath(".")
stopifnot(dir.exists(file.path(ROOT, "data", "clean")))
TAB <- file.path(ROOT, "output", "tables"); FIG <- file.path(ROOT, "output", "figures")
dir.create(TAB, showWarnings = FALSE, recursive = TRUE); dir.create(FIG, showWarnings = FALSE, recursive = TRUE)

P <- fread(file.path(ROOT, "data", "clean", "panel_la_year_2010_2025.csv"))
setkey(P, code, year)
P[, region_year := paste(region, year)]
# two-year cumulative flows (current + previous financial year), per 1,000 dwellings
P[, `:=`(soc2 = soc_nb_pk + shift(soc_nb_pk), rtb2 = rtb_pk + shift(rtb_pk), aq2 = aq_pk + shift(aq_pk)), by = code]
# analysis samples
G <- P[year %between% c(2016, 2025)]   # rent growth, 2016-2025 (N = 2,940)
L <- P[year %between% c(2015, 2025)]   # rent level, 2015-2025 (N = 3,234)
L[is.na(ln_pay_l1), ln_pay_l1 := ln_pay]; L[is.na(unemp_l1), unemp_l1 := unemp]
L[is.na(dlnpop_l1), dlnpop_l1 := dlnpop]

# Sequential control sets (used to show which variables shape the share-rent relationship)
CTRL_L <- list(M0 = character(0),
               M1 = c("ln_pay_l1", "unemp_l1", "dlnpop_l1"),
               M2 = c("ln_pay_l1", "unemp_l1", "dlnpop_l1", "ln_density_l1", "netadd_pk_l1"),
               M3 = c("ln_pay_l1", "unemp_l1", "dlnpop_l1", "ln_density_l1", "netadd_pk_l1", "imd19"))
CTRL_G <- list(M0 = character(0),
               M1 = c("dlnpay_l1", "unemp_l1", "dlnpop_l1"),
               M2 = c("dlnpay_l1", "unemp_l1", "dlnpop_l1", "ln_density_l1", "netadd_pk_l1", "ln_rentlvl_l1"),
               M3 = c("dlnpay_l1", "unemp_l1", "dlnpop_l1", "ln_density_l1", "netadd_pk_l1", "ln_rentlvl_l1", "imd19"))
L[, lnrent100 := 100 * ln_rentlvl]   # rent level in log points x 100 => coefficients read as % differences

setFixest_dict(c(dlnrent_all = "Private rent growth (%)", lnrent100 = "Log private rent (x100)",
  sh_share_l1 = "SH share (t-1, pp)", soc2 = "Social/affordable new build (2-yr, per 1,000)",
  rtb2 = "Right to Buy sales (2-yr, per 1,000)", aq2 = "Rental acquisitions (2-yr, per 1,000)",
  ln_pay_l1 = "Log median earnings (t-1)", dlnpay_l1 = "Earnings growth (t-1)", unemp_l1 = "Unemployment (t-1)",
  dlnpop_l1 = "Population growth (t-1)", ln_density_l1 = "Log density (t-1)", netadd_pk_l1 = "Net additions per 1,000 (t-1)",
  imd19 = "IMD 2019 score", ln_rentlvl_l1 = "Log rent level (t-1)", code = "LA", region_year = "Region x Year"))
setFixest_etable(digits = 3, fitstat = ~ n + r2)
theme_paper <- theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(), plot.title = element_text(face = "bold", size = 11), legend.position = "bottom")
save_coefs <- function(models, file) {
  out <- rbindlist(lapply(names(models), function(nm) { m <- models[[nm]]; ct <- coeftable(m)
    data.table(model = nm, term = rownames(ct), est = ct[, 1], se = ct[, 2], p = ct[, 4], n = nobs(m)) }))
  fwrite(out, file.path(TAB, file)); invisible(out)
}
SHBINS <- c(0, 10, 15, 20, 25, 30, 100)
SHLAB <- c("<10%", "10-15%", "15-20%", "20-25%", "25-30%", ">=30%")
