# 16_appendixD_identification.R -- Appendix D: why the paper does not use a causal design.
# Documents three diagnostics:
#  (1) the SH share has almost no within-LA variation (variance decomposition);
#  (2) an event study around the first large social/affordable rent completion pulse (Sun & Abraham 2021)
#      shows pre-trends that violate parallel trends, and no break in slope at the event;
#  (3) a shift-share instrument for completions has a weak first stage.
source("code/00_setup.R")

## (1) within vs between variation -----------------------------------------------------------
labs_vd <- c(sh_share_l1 = "SH share, t-1 (pp)", soc_nb_pk = "Social/affordable new build per 1,000",
             rtb_pk = "Right to Buy sales per 1,000", dlnrent_all = "Private rent growth (%)")
vd <- data.table(var = names(labs_vd), label = unname(labs_vd))
vd[, `:=`(within_sd = sapply(var, function(v) sd(G[[v]] - ave(G[[v]], G$code))),
          between_sd = sapply(var, function(v) sd(G[, mean(get(v)), by = code]$V1)))]

## (2) event study ---------------------------------------------------------------------------------
ES <- copy(P[year %between% c(2015, 2025)])
ES[, lnidx := 100 * log(idx_all)]
n_early <- uniqueN(ES[!is.na(event_year) & event_year < 2017, code])
ES <- ES[is.na(event_year) | event_year >= 2017]           # LAs first treated before 2017 have no pre-period
ES[, cohort := fifelse(is.na(event_year), 10000, event_year)]
es <- feols(lnidx ~ sunab(cohort, year, ref.p = -1) | code + region_year, ES, cluster = ~code)
es_tr <- feols(lnidx ~ sunab(cohort, year, ref.p = -1) | code[year] + region_year, ES, cluster = ~code)
coefs <- function(m, lab) {
  ct <- as.data.table(coeftable(m), keep.rownames = "term")[grepl("year::", term)]
  rbind(ct[, .(spec = lab, rel = as.integer(sub("year::", "", term)), est = Estimate, se = `Std. Error`)],
        data.table(spec = lab, rel = -1L, est = 0, se = 0))
}
est <- rbind(coefs(es, "LA and region-by-year FE"), coefs(es_tr, "Adding LA-specific linear trends"))
fwrite(est, file.path(TAB, "appendixD_event_study.csv"))
pre <- function(m) wald(m, keep = "year::-[2-6]:cohort", print = FALSE)   # all cohort-specific leads -2..-6
att <- function(m) coeftable(summary(m, agg = "att"))
et <- est[spec == "LA and region-by-year FE" & rel %between% c(-6, 6)][, post := as.integer(rel >= 0)]
brk <- summary(lm(est ~ rel + post + rel:post, et, weights = 1 / pmax(se, 0.05)^2))$coefficients

## (3) shift-share first stage --------------------------------------------------------------------
fs <- feols(as.formula(paste("soc_nb_pk ~ bartik_pk +", paste(c(CTRL_G$M1, "netadd_pk_l1"), collapse = "+"), "| code + year")),
            G, cluster = ~code)

tests <- data.table(
  test = c("Pre-trend joint test, LA and region-by-year FE", "Pre-trend joint test, with LA linear trends",
           "Average post-event effect (ATT), LA and region-by-year FE", "Average post-event effect (ATT), with LA linear trends",
           "Change in slope at the event (event-time coefficients)", "Change in level at the event (event-time coefficients)",
           "Shift-share first stage: coefficient", "Shift-share first stage: F statistic (excluded instrument, clustered)"),
  stat = c(pre(es)$stat, pre(es_tr)$stat, att(es)[1, 1], att(es_tr)[1, 1], brk["rel:post", 1], brk["post", 1],
           coef(fs)["bartik_pk"], tstat(fs)["bartik_pk"]^2),
  se = c(NA, NA, att(es)[1, 2], att(es_tr)[1, 2], brk["rel:post", 2], brk["post", 2], se(fs)["bartik_pk"], NA),
  p = c(pre(es)$p, pre(es_tr)$p, att(es)[1, 4], att(es_tr)[1, 4], brk["rel:post", 4], brk["post", 4],
        pvalue(fs)["bartik_pk"], pvalue(fs)["bartik_pk"]),
  df = c(pre(es)$df1, pre(es_tr)$df1, NA, NA, NA, NA, NA, NA))
info <- data.table(treated_las = uniqueN(ES[cohort < 10000, code]), never_treated = uniqueN(ES[cohort == 10000, code]),
                   excluded_early = n_early, first_cohort = min(ES[cohort < 10000, cohort]), last_cohort = max(ES[cohort < 10000, cohort]))
fwrite(vd, file.path(TAB, "appendixD_variance.csv")); fwrite(tests, file.path(TAB, "appendixD_tests.csv"))
fwrite(info, file.path(TAB, "appendixD_sample.csv"))
sink(file.path(TAB, "appendixD_summary.txt")); print(vd); print(tests); print(info); sink()

g <- ggplot(est[rel %between% c(-6, 6)], aes(rel, est, colour = spec, shape = spec)) +
  geom_hline(yintercept = 0, colour = "grey50") + geom_vline(xintercept = -0.5, linetype = 2, colour = "grey60") +
  geom_pointrange(aes(ymin = est - 1.96 * se, ymax = est + 1.96 * se), position = position_dodge(width = 0.4)) +
  scale_colour_manual(values = c("#548235", "#1f4e79")) +
  labs(x = "Years relative to the first large social/affordable rent completion pulse",
       y = "Log private rent index (x100), relative to year -1", colour = NULL, shape = NULL) + theme_paper
ggsave(file.path(FIG, "figD1_event_study.png"), g, width = 7.5, height = 4.3, dpi = 300)
cat("Appendix D done\n")
