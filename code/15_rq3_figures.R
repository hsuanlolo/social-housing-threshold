# 15_rq3_figures.R -- Figures 6 (Gelbach decomposition) and 7 (moderator slopes) from RQ3 output
source("code/00_setup.R")
gb <- fread(file.path(TAB, "rq3_gelbach.csv")); mr <- fread(file.path(TAB, "rq3_moderator_slopes.csv"))
gp <- gb[!term %in% c("base", "full")]; gp[, outcome := factor(outcome, c("Rent level", "Rent growth"))]
g2 <- ggplot(gp, aes(est, reorder(term, est))) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_col(fill = "#9dc3e6") + geom_errorbarh(aes(xmin = est - 1.96 * se, xmax = est + 1.96 * se), height = 0.2, colour = "#1f4e79") +
  facet_wrap(~outcome, scales = "free_x") +
  labs(x = "Contribution to (raw minus controlled) SH-share coefficient", y = NULL) + theme_paper
ggsave(file.path(FIG, "fig6_gelbach.png"), g2, width = 9, height = 4.2, dpi = 300)
hi <- c("London", "High earnings", "Slack (high vacancy)", "Large PRS", "Restrictive", "Mainly council-owned", "More deprived")
mr[, side := fifelse(group %in% hi, "High / London / council", "Low / rest / housing association")]
mr[, outcome := factor(outcome, c("level", "growth"), c("(a) Rent level: % per 1 pp of SH share", "(b) Rent growth: pp per 1 pp of SH share"))]
g <- ggplot(mr, aes(slope, moderator, colour = side)) + geom_vline(xintercept = 0, colour = "grey50") +
  geom_pointrange(aes(xmin = slope - 1.96 * se, xmax = slope + 1.96 * se), position = position_dodge(width = 0.5)) +
  facet_wrap(~outcome, scales = "free_x") + scale_colour_manual(values = c("#c55a11", "#1f4e79")) +
  labs(x = "Slope of the share-rent relationship within subgroup", y = NULL, colour = NULL) + theme_paper
ggsave(file.path(FIG, "fig7_moderators.png"), g, width = 9, height = 4.8, dpi = 300)
cat("RQ3 figures done\n")
