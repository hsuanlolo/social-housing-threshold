# 12_rq3_why.R -- RQ3: why is (or isn't) there a threshold? Which variables shape the share-rent relationship?
# (a) Confounding: Gelbach (2016) decomposition of how the share coefficient changes when controls are added,
#     and the within- vs between-LA split (Mundlak) of the association.
# (b) Moderation: does the relationship -- and the existence/location of a threshold -- differ by market
#     context? Split-sample interval slopes and Hansen tests; continuous share x moderator interactions.
# (c) Statistical power: how large a change in slope could the data detect, by interval?
source("code/00_setup.R")
source("code/threshold_functions.R")
NB <- as.integer(Sys.getenv("NBOOT", "299"))
L <- L[complete.cases(L[, c("lnrent100", "sh_share_l1", CTRL_L$M3), with = FALSE])]
G <- G[complete.cases(G[, c("dlnrent_all", "sh_share_l1", CTRL_G$M3), with = FALSE])]

## (a) Gelbach decomposition ------------------------------------------------------------------
gelbach <- function(d, dep, xs, groups, nboot = 199, seed = 1) {
  set.seed(seed)
  one <- function(dd) {
    base <- feols(as.formula(paste(dep, "~", "sh_share_l1 | region_year")), dd)
    full <- feols(as.formula(paste(dep, "~ sh_share_l1 +", paste(xs, collapse = "+"), "| region_year")), dd)
    gam_k <- coef(full)[xs]
    del_k <- sapply(xs, function(x) coef(feols(as.formula(paste(x, "~ sh_share_l1 | region_year")), dd))["sh_share_l1"])
    contrib <- gam_k * del_k
    c(base = unname(coef(base)["sh_share_l1"]), full = unname(coef(full)["sh_share_l1"]),
      sapply(groups, function(g) sum(contrib[g])))
  }
  est <- one(d)
  las <- unique(d$code)
  bt <- t(replicate(nboot, { s <- sample(las, length(las), TRUE)
    db <- rbindlist(lapply(seq_along(s), function(k) { x <- d[code == s[k]]; x[, code := paste0(code, "_", k)]; x }))
    one(db) }))
  data.table(term = names(est), est = est, se = apply(bt, 2, sd))
}
grpL <- list(`Earnings` = "ln_pay_l1", `Unemployment` = "unemp_l1", `Population growth` = "dlnpop_l1",
             `Density` = "ln_density_l1", `Net additions` = "netadd_pk_l1", `Deprivation (IMD)` = "imd19")
grpG <- list(`Earnings growth` = "dlnpay_l1", `Unemployment` = "unemp_l1", `Population growth` = "dlnpop_l1",
             `Density` = "ln_density_l1", `Net additions` = "netadd_pk_l1", `Initial rent level` = "ln_rentlvl_l1",
             `Deprivation (IMD)` = "imd19")
gl <- gelbach(L, "lnrent100", CTRL_L$M3, grpL); gg <- gelbach(G, "dlnrent_all", CTRL_G$M3, grpG)
gb <- rbind(cbind(outcome = "Rent level", gl), cbind(outcome = "Rent growth", gg))
fwrite(gb, file.path(TAB, "rq3_gelbach.csv"))

# within vs between (Mundlak): which part of the association comes from changes within LAs?
L[, sh_bar := mean(sh_share_l1), by = code]; G[, sh_bar := mean(sh_share_l1), by = code]
for (v in CTRL_L$M3) L[, paste0(v, "_bar") := mean(get(v)), by = code]
for (v in CTRL_G$M3) G[, paste0(v, "_bar") := mean(get(v)), by = code]  # (lagged rent mean unused below)
mk <- function(d, dep, ctrl) feols(as.formula(paste(dep, "~ sh_share_l1 + sh_bar +", paste(ctrl, collapse = "+"), "+",
                                                    paste(paste0(setdiff(ctrl, "imd19"), "_bar"), collapse = "+"), "| region_year")), d, cluster = ~code)
# growth: drop the lagged rent level (a lagged dependent variable would bias the within-LA coefficient)
mund <- list(level_mundlak = mk(L, "lnrent100", CTRL_L$M3), growth_mundlak = mk(G, "dlnrent_all", setdiff(CTRL_G$M3, "ln_rentlvl_l1")))
wb <- rbindlist(lapply(names(mund), function(n) { m <- mund[[n]]; b <- coef(m); V <- vcov(m)
  data.table(model = n, within = b["sh_share_l1"], within_se = sqrt(V["sh_share_l1", "sh_share_l1"]),
             between = b["sh_share_l1"] + b["sh_bar"],
             between_se = sqrt(V["sh_share_l1", "sh_share_l1"] + V["sh_bar", "sh_bar"] + 2 * V["sh_share_l1", "sh_bar"])) }))
fwrite(wb, file.path(TAB, "rq3_within_between.csv"))

## (b) Moderation ----------------------------------------------------------------------------
MODS <- list(
  london = list(lab = "London vs rest of England", f = function(d) d$london == 1, hi = "London", lo = "Rest of England"),
  pay = list(lab = "Earnings (demand)", f = function(d) d$pay_base > median(unique(d[, .(code, pay_base)])$pay_base), hi = "High earnings", lo = "Low earnings"),
  vac = list(lab = "Vacancy rate 2014 (slack)", f = function(d) d$vac_rate_2014 > median(unique(d[, .(code, vac_rate_2014)])$vac_rate_2014), hi = "Slack (high vacancy)", lo = "Tight (low vacancy)"),
  prs = list(lab = "Private-rented share 2011", f = function(d) d$prs_share11 > median(unique(d[, .(code, prs_share11)])$prs_share11), hi = "Large PRS", lo = "Small PRS"),
  ref = list(lab = "Planning refusal rate", f = function(d) d$refusal_major > median(unique(d[, .(code, refusal_major)])$refusal_major), hi = "Restrictive", lo = "Permissive"),
  cou = list(lab = "Council share of social stock", f = function(d) d$council_base >= 50, hi = "Mainly council-owned", lo = "Mainly housing-association"),
  imd = list(lab = "Deprivation (IMD 2019)", f = function(d) d$imd19 > median(unique(d[, .(code, imd19)])$imd19), hi = "More deprived", lo = "Less deprived"))
add_base <- function(d) {
  d[, pay_base := mean(ln_pay[year %in% 2015:2016], na.rm = TRUE), by = code]
  d[, council_base := mean(council_share_soc[year %in% 2015:2016], na.rm = TRUE), by = code]
  d
}
L <- add_base(L); G <- add_base(G)
modres <- list(); modthr <- list()
for (nm in names(MODS)) {
  M <- MODS[[nm]]
  for (out in c("level", "growth")) {
    d <- if (out == "level") L else G; dep <- if (out == "level") "lnrent100" else "dlnrent_all"
    ctrl <- if (out == "level") CTRL_L$M3 else CTRL_G$M3
    d[, grp := fifelse(M$f(d), M$hi, M$lo)]
    # slope by group (interaction) + test of equal slopes
    mi <- feols(as.formula(paste(dep, "~ i(grp, sh_share_l1) +", paste(ctrl, collapse = "+"), "| region_year^grp")), d, cluster = ~code)
    ct <- coeftable(mi); k <- grep("sh_share_l1", rownames(ct))
    b <- coef(mi)[k]; V <- vcov(mi)[k, k]; dz <- (b[1] - b[2]) / sqrt(V[1, 1] + V[2, 2] - 2 * V[1, 2])
    modres[[paste(nm, out)]] <- data.table(moderator = M$lab, outcome = out, group = sub(".*::(.*):sh_share_l1", "\\1", rownames(ct)[k]),
                                           slope = ct[k, 1], se = ct[k, 2], p = ct[k, 4], p_equal = 2 * pnorm(-abs(dz)),
                                           LAs = sapply(sub(".*::(.*):sh_share_l1", "\\1", rownames(ct)[k]), function(g) uniqueN(d[grp == g, code])))
    # does a threshold appear within each group?
    for (g in unique(d$grp)) {
      sub <- d[grp == g]; if (uniqueN(sub$code) < 25) next
      h <- tryCatch(hansen_fe(sub, dep, "sh_share_l1", "sh_share_l1", ctrl, fe = "region_year", nboot = NB, double = FALSE,
                              shift = TRUE, trim = 0.15), error = function(e) NULL)
      if (is.null(h)) next
      modthr[[paste(nm, out, g)]] <- data.table(moderator = M$lab, outcome = out, group = g, LAs = uniqueN(sub$code),
                                                gamma = h$gamma1, ci_lo = h$ci1[1], ci_hi = h$ci1[2], F = h$F1, p_boot = h$p1)
    }
  }
}
modres <- rbindlist(modres); modthr <- rbindlist(modthr)
fwrite(modres, file.path(TAB, "rq3_moderator_slopes.csv")); fwrite(modthr, file.path(TAB, "rq3_moderator_thresholds.csv"))

## (c) power: minimum detectable difference (80% power, 5% two-sided) by interval -----------------
L[, shbin := relevel(cut(sh_share_l1, SHBINS, SHLAB, right = FALSE), "10-15%")]
G[, shbin := relevel(cut(sh_share_l1, SHBINS, SHLAB, right = FALSE), "10-15%")]
pw <- rbindlist(lapply(list(level = list(L, "lnrent100", CTRL_L$M3), growth = list(G, "dlnrent_all", CTRL_G$M3)), function(a) {
  m <- feols(as.formula(paste(a[[2]], "~ i(shbin, ref = '10-15%') +", paste(a[[3]], collapse = "+"), "| region_year")), a[[1]], cluster = ~code)
  ct <- as.data.table(coeftable(m), keep.rownames = "term")[grepl("shbin", term)]
  ct[, .(bin = sub("shbin::", "", term), se = `Std. Error`, mdd = 2.8 * `Std. Error`, LAs = sapply(sub("shbin::", "", term), function(b) uniqueN(a[[1]][shbin == b, code])))]
}), idcol = "outcome")
fwrite(pw, file.path(TAB, "rq3_power.csv"))
sink(file.path(TAB, "rq3_summary.txt")); print(gb); print(wb); print(modres); print(modthr); print(pw); sink()

# figures are produced by code/15_rq3_figures.R (from the CSVs written above)
cat("RQ3 done\n")
