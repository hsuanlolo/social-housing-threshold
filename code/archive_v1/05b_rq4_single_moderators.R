# 05b_rq4_single_moderators.R -- RQ4 complement: one moderator at a time (the joint model in 05 includes all
# moderators simultaneously, which are mutually correlated), plus the moderator correlation matrix.
source("code/00_setup.R")
A <- fread(file.path(ROOT, "data", "clean", "analysis_with_flows.csv"))
MODS <- c(prs_share11 = "Private-rented share (2011)", refusal_major = "Planning refusal rate",
          ar_share_new = "Affordable Rent share of new lets", vac_rate_2014 = "Vacancy rate (2014)",
          dissim21 = "Social housing concentration", sh_share_2014 = "SH share (2014)")
for (m in names(MODS)) A[, paste0(m, "_z") := (get(m) - mean(get(m))) / sd(get(m))]
res <- rbindlist(lapply(names(MODS), function(m) {
  z <- paste0(m, "_z")
  f <- feols(as.formula(paste("dlnrent_all ~ soc2 + aq2 + rtb2 + soc2:", z, "+ rtb2:", z, "+", CTRL, "| code + region_year")),
             A, cluster = ~code)
  ct <- coeftable(f); k <- grep(":", rownames(ct))
  data.table(moderator = MODS[m], term = sub(paste0(":", z), "", rownames(ct)[k]), est = ct[k, 1], se = ct[k, 2], p = ct[k, 4])
}))
fwrite(res, file.path(TAB, "rq4_single_moderator_interactions.csv"))
cm <- round(cor(unique(A[, names(MODS), with = FALSE])), 2)
fwrite(as.data.table(cm, keep.rownames = "var"), file.path(TAB, "rq4_moderator_correlations.csv"))
sink(file.path(TAB, "rq4_single_summary.txt")); print(res); print(cm); sink()
cat("05b done\n")
