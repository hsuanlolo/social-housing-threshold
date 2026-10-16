"""13_tables.py -- Markdown tables for the manuscript, generated from model output (output/tables/*.csv)."""
import os
import pandas as pd

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TAB = os.path.join(ROOT, "output", "tables")
MD = os.path.join(TAB, "md")
os.makedirs(MD, exist_ok=True)


def st(p):
    return "***" if p < 0.01 else "**" if p < 0.05 else "*" if p < 0.10 else ""


def c(est, se, p, d=3):
    return f"{est:.{d}f}{st(p)} ({se:.{d}f})"


def write(name, lines, note):
    open(os.path.join(MD, name + ".md"), "w").write("\n".join(lines) + "\n\n" + note + "\n")


NOTE = ("*** p<0.01, ** p<0.05, * p<0.10. Standard errors clustered by local authority in parentheses"
        " (heteroskedasticity-robust in the cross-section).")

# Table 1: descriptives ------------------------------------------------------------------------------
import numpy as np
P = pd.read_csv(os.path.join(ROOT, "data", "clean", "panel_la_year_2010_2025.csv"))
G = P[P.year.between(2016, 2025)]
L = P[P.year.between(2015, 2025)]
rows = [("Private rent growth, PIPR (% per year)", G.dlnrent_all), ("Average private rent (£ per month)", L.rentlvl_all),
        ("Annual rent as % of median FT earnings", L.rent_to_pay), ("Social housing share of stock, t-1 (%)", G.sh_share_l1),
        ("  council-owned (% of stock)", G.la_share_l1), ("  housing-association-owned (% of stock)", G.prp_share_l1),
        ("Social/affordable rent new build per 1,000 dwellings", G.soc_nb_pk), ("Right to Buy sales per 1,000 dwellings", G.rtb_pk),
        ("Median FT earnings (£ per year)", L.pay), ("Unemployment rate (%)", L.unemp), ("Population growth (%)", G.dlnpop),
        ("Population density (persons per km², log)", L.ln_density), ("Net additional dwellings per 1,000", G.netadd_pk),
        ("IMD 2019 average score", G.imd19), ("Private-rented share of households, 2011 (%)", G.prs_share11),
        ("Vacancy rate, 2014 (%)", G.vac_rate_2014), ("Major residential refusal rate, 1979-2013 (%)", G.refusal_major)]
lines = ["| Variable | Mean | SD | P10 | Median | P90 |", "|---|---|---|---|---|---|"]
for lab, s in rows:
    s = s.dropna()
    lines.append(f"| {lab} | {s.mean():,.2f} | {s.std():,.2f} | {s.quantile(.1):,.2f} | {s.median():,.2f} | {s.quantile(.9):,.2f} |")
w = G.groupby("code").sh_share_l1
write("table1", lines, f"Notes: 294 English local authorities. Growth variables 2016-2025 (N = 2,940); levels 2015-2025 (N = 3,234)."
      f" The SH share varies mostly between LAs: between-LA SD {w.mean().std():.2f} pp, within-LA SD"
      f" {(G.sh_share_l1 - w.transform('mean')).std():.2f} pp.")

# Table 2: RQ1 relationship ------------------------------------------------------------------------
r = pd.read_csv(os.path.join(TAB, "rq1_relationship_coefs.csv"))
def get(m, t="sh_share_l1"):
    x = r[(r.model == m) & (r.term == t)]
    return c(x.est.iloc[0], x.se.iloc[0], x.p.iloc[0]) if len(x) else ""
lines = ["| | (1) Region x year FE only | (2) + demand | (3) + urban structure | (4) + deprivation | (5) Within LA (LA FE) |", "|---|---|---|---|---|---|"]
lines.append("| **A. Log private rent level (x100), 2015-2025** | " + " | ".join(get(f"level_{k}") for k in ["M0", "M1", "M2", "M3", "within"]) + " |")
lines.append("| **B. Private rent growth (pp), 2016-2025** | " + " | ".join(get(f"growth_{k}") for k in ["M0", "M1", "M2", "M3", "within"]) + " |")
ld = r[(r.model == "long_difference") & (r.term == "sh14")].iloc[0]
af = r[(r.model == "affordability") & (r.term == "sh_share_l1")].iloc[0]
write("table2", lines, "Notes: Coefficient on the lagged social housing (SH) share (percentage points). Panel A: 100 x log average private"
      " rent, so coefficients read approximately as percent differences per 1 pp of SH share. Controls: (2) log median earnings,"
      " unemployment, population growth (panel B: earnings growth instead of log earnings); (3) adds log population density and net"
      " additions per 1,000 dwellings (panel B also the lagged log rent level); (4) adds the IMD 2019 score. All controls lagged one"
      " year. Column (5) adds LA fixed effects (panel A with column-3 controls; panel B with column-2 controls), so it uses only the"
      f" small within-LA changes in the share. Long-difference cross-section (average annual growth 2015-2025 on 2014 share, full"
      f" controls, region FE, N = 294): {c(ld.est, ld.se, ld.p)}. Affordability (annual rent as % of median earnings, column-4"
      f" controls without earnings): {c(af.est, af.se, af.p)}. " + NOTE)

# Table 3: intervals ----------------------------------------------------------------------------------
iv = pd.read_csv(os.path.join(TAB, "rq2_interval_coefs.csv")); bn = pd.read_csv(os.path.join(TAB, "rq2_bin_counts.csv"))
order = ["<10%", "10-15%", "15-20%", "20-25%", "25-30%", ">=30%"]
lines = ["| SH share interval | LAs | Level: raw | Level: full controls | Growth: raw | Growth: full controls |", "|---|---|---|---|---|---|"]
for b in order:
    n = int(bn[bn.shbin == b].LAs.iloc[0])
    if b == "10-15%":
        lines.append(f"| {b} (reference) | {n} | 0 | 0 | 0 | 0 |"); continue
    cells = []
    for m in ["level_raw", "level_full", "growth_raw", "growth_full"]:
        x = iv[(iv.model == m) & (iv.term == f"shbin::{b}")].iloc[0]; cells.append(c(x.est, x.se, x.p, 2 if "level" in m else 3))
    lines.append(f"| {b} | {n} | " + " | ".join(cells) + " |")
write("table3", lines, "Notes: Differences relative to LAs with a 10-15% share in the previous year; region-by-year fixed effects; full"
      " controls as in Table 2 column (4). LAs = number of LAs observed in the interval at least once (LAs can move between"
      " intervals). Level coefficients in log points x 100. " + NOTE)

# Table 4: threshold and kink tests ---------------------------------------------------------------------
th = pd.read_csv(os.path.join(TAB, "rq2_threshold_tests.csv")); kk = pd.read_csv(os.path.join(TAB, "rq2_kink_tests.csv"))
lt = pd.read_csv(os.path.join(TAB, "rq2_linearity_tests.csv"))
lines = ["| Test | Outcome | Estimated location (%) | 95% CI (LR) | F | Bootstrap p | Slope below | Slope above |", "|---|---|---|---|---|---|---|---|"]
tc = pd.read_csv(os.path.join(TAB, "rq2_threshold_coefs.csv"))
for _, x in th.iterrows():
    mod = "level_threshold" if x.outcome == "Rent level" else "growth_threshold"
    b1 = tc[(tc.model == mod) & (tc.term == "sh_share_l1_r1")].iloc[0]; b2 = tc[(tc.model == mod) & (tc.term == "sh_share_l1_r2")].iloc[0]
    lines.append(f"| Threshold with jump (Hansen) | {x.outcome} | {x.gamma1:.1f} | [{x.ci_lo:.1f}, {x.ci_hi:.1f}] | {x.F1:.1f} | {x.p_boot1:.3f} |"
                 f" {c(b1.est, b1.se, b1.p)} | {c(b2.est, b2.se, b2.p)} |")
for _, x in kk.iterrows():
    pb = 2 * (1 - __import__('scipy.stats', fromlist=['norm']).norm.cdf(abs(x.slope_below / x.se_below)))
    pa = 2 * (1 - __import__('scipy.stats', fromlist=['norm']).norm.cdf(abs(x.slope_above / x.se_above)))
    lines.append(f"| Continuous kink | {x.outcome} | {x.gamma:.1f} | [{x.ci_lo:.1f}, {x.ci_hi:.1f}] | {x.F:.1f} | {x.p_boot:.3f} |"
                 f" {c(x.slope_below, x.se_below, pb)} | {c(x.slope_above, x.se_above, pa)} |")
for _, x in lt.iterrows():
    lines.append(f"| Spline deviation from linearity (Wald) | {x.outcome} | - | - | {x.stat:.2f} | {x.p:.3f} (asymptotic) | | |")
write("table4", lines, "Notes: All models include region-by-year fixed effects and full controls; N = 3,234 (level) and 2,940 (growth)."
      " Threshold-with-jump: Hansen (2000)-type sample split in the slope and intercept on the SH share; kink: continuous"
      " piecewise-linear (hinge) model. Bootstrap p-values from 499 wild cluster (Rademacher, by LA) replications under the null"
      " of a linear relationship; candidate locations trimmed to the 10th-90th percentiles of the share. The LR confidence set"
      " is reported for completeness; when the threshold is not significant it is not informative about location. Slopes are"
      " per 1 pp of SH share (log points x 100 for levels; pp for growth). " + NOTE)

# Table 5: flows by interval ---------------------------------------------------------------------------
fc = pd.read_csv(os.path.join(TAB, "rq2_flow_coefs.csv")); cnt = pd.read_csv(os.path.join(TAB, "rq2_flow_interval_counts.csv"))
eq = pd.read_csv(os.path.join(TAB, "rq2_flow_equality_tests.csv")); ft = pd.read_csv(os.path.join(TAB, "rq2_flow_threshold_tests.csv"))
lines = ["| SH share interval | LAs | Adding: new build | Losing: Right to Buy |", "|---|---|---|---|"]
for b in ["<12%", "12-16%", "16-22%", ">=22%"]:
    a = fc[(fc.model == "flow_intervals") & (fc.term == f"iv::{b}:soc2")].iloc[0]; z = fc[(fc.model == "flow_intervals") & (fc.term == f"iv::{b}:rtb2")].iloc[0]
    lines.append(f"| {b} | {int(cnt[cnt.iv == b].LAs.iloc[0])} | {c(a.est, a.se, a.p)} | {c(z.est, z.se, z.p)} |")
la = fc[(fc.model == "flow_linear") & (fc.term == "soc2")].iloc[0]; lr_ = fc[(fc.model == "flow_linear") & (fc.term == "rtb2")].iloc[0]
lines.append(f"| All LAs (no intervals) | 294 | {c(la.est, la.se, la.p)} | {c(lr_.est, lr_.se, lr_.p)} |")
lines.append(f"| Equality across intervals: F (p) | | {eq.stat.iloc[0]:.2f} ({eq.p.iloc[0]:.3f}) | {eq.stat.iloc[1]:.2f} ({eq.p.iloc[1]:.3f}) |")
lines.append(f"| Hansen threshold in SH share: location, bootstrap p | | {ft.gamma1.iloc[0]:.1f}%, p = {ft.p_boot1.iloc[0]:.3f} | {ft.gamma1.iloc[1]:.1f}%, p = {ft.p_boot1.iloc[1]:.3f} |")
write("table5", lines, "Notes: Dependent variable is annual private rent growth. Flows are completions or sales in the current and previous"
      " financial year per 1,000 dwellings. LA and region-by-year fixed effects; controls: lagged earnings growth, unemployment,"
      " population growth, net additions, and rental acquisitions. Coefficients are the change in rent growth (pp) per additional"
      " unit per 1,000 dwellings within each interval of the lagged share. " + NOTE)

# Table 6: why -- decomposition + within/between ---------------------------------------------------------
gb = pd.read_csv(os.path.join(TAB, "rq3_gelbach.csv")); wb = pd.read_csv(os.path.join(TAB, "rq3_within_between.csv"))
terms = [t for t in gb.term.unique() if t not in ("base", "full")]
lines = ["| | Rent level (x100) | Rent growth (pp) |", "|---|---|---|"]
def g(o, t):
    x = gb[(gb.outcome == o) & (gb.term == t)]
    if not len(x): return ""
    x = x.iloc[0]; p = 2 * (1 - __import__('scipy.stats', fromlist=['norm']).norm.cdf(abs(x.est / x.se))) if x.se > 0 else 1
    return c(x.est, x.se, p)
lines.append(f"| SH-share coefficient, region x year FE only | {g('Rent level', 'base')} | {g('Rent growth', 'base')} |")
lines.append(f"| SH-share coefficient, full controls | {g('Rent level', 'full')} | {g('Rent growth', 'full')} |")
lines.append("| *Contribution to (raw - controlled) of:* | | |")
for t in terms:
    lines.append(f"| {t} | {g('Rent level', t)} | {g('Rent growth', t)} |")
lines.append("| *Within vs between LAs (Mundlak):* | | |")
for lab, col in [("Within-LA association", "within"), ("Between-LA association", "between")]:
    cells = []
    for m in ["level_mundlak", "growth_mundlak"]:
        x = wb[wb.model == m].iloc[0]; est, se = x[col], x[col + "_se"]
        p = 2 * (1 - __import__('scipy.stats', fromlist=['norm']).norm.cdf(abs(est / se)))
        cells.append(c(est, se, p))
    lines.append(f"| {lab} | " + " | ".join(cells) + " |")
write("table6", lines, "Notes: Gelbach (2016) decomposition: the difference between the raw and controlled SH-share coefficients equals the"
      " sum over controls of (effect of the control on rents) x (association of the control with the SH share). A positive"
      " contribution means the control accounts for part of a positive raw association; a negative contribution means it masks"
      " a positive association. Standard errors from 199 LA-cluster bootstrap replications. Mundlak: within = coefficient on the"
      " share with LA means of the share and controls included; between = within + coefficient on the LA mean share."
      " The growth Mundlak model excludes the lagged rent level. " + NOTE)

# Table 7: moderators ---------------------------------------------------------------------------------
mr = pd.read_csv(os.path.join(TAB, "rq3_moderator_slopes.csv")); mt = pd.read_csv(os.path.join(TAB, "rq3_moderator_thresholds.csv"))
lines = ["| Moderator | Group | LAs | Level: slope | Level: threshold (p) | Growth: slope | Growth: threshold (p) |", "|---|---|---|---|---|---|---|"]
pe = mr.groupby(["moderator", "outcome"]).p_equal.first().unstack()
for mod in mr.moderator.unique():
    for k, grp in enumerate(mr[mr.moderator == mod].group.unique()):
        a = mr[(mr.moderator == mod) & (mr.group == grp) & (mr.outcome == "level")].iloc[0]
        b = mr[(mr.moderator == mod) & (mr.group == grp) & (mr.outcome == "growth")].iloc[0]
        ta = mt[(mt.moderator == mod) & (mt.group == grp) & (mt.outcome == "level")]
        tb = mt[(mt.moderator == mod) & (mt.group == grp) & (mt.outcome == "growth")]
        fa = f"{ta.gamma.iloc[0]:.1f}% ({ta.p_boot.iloc[0]:.3f})" if len(ta) else "-"
        fb = f"{tb.gamma.iloc[0]:.1f}% ({tb.p_boot.iloc[0]:.3f})" if len(tb) else "-"
        lines.append(f"| {mod if k == 0 else ''} | {grp} | {int(a.LAs)} | {c(a.slope, a.se, a.p)} | {fa} | {c(b.slope, b.se, b.p)} | {fb} |")
    lines.append(f"| | *p (equal slopes)* | | *{pe.loc[mod, 'level']:.3f}* | | *{pe.loc[mod, 'growth']:.3f}* | |")
write("table7", lines, "Notes: Slopes of rent level (log points x 100) and rent growth (pp) per 1 pp of SH share within each subgroup,"
      " from a pooled model with group-specific slopes, group-by-region-by-year fixed effects and full controls. Groups are split"
      " at the median LA unless stated (council share: at least 50% of social stock owned by the council). Threshold: Hansen"
      " threshold-with-jump estimated within the subgroup (15% trimming, 299 wild cluster bootstrap replications); with 28"
      " subgroup tests, about 1-3 rejections at the 10% level are expected by chance. " + NOTE)
# Table C1: robustness -------------------------------------------------------------------------------
rb = pd.read_csv(os.path.join(TAB, "robustness_C1.csv"))
lines = ["| Outcome | Specification | N | Linear slope | Threshold location | Bootstrap p | Slope below | Slope above |", "|---|---|---|---|---|---|---|---|"]
for _, x in rb.iterrows():
    lines.append(f"| {x.outcome} | {x.spec} | {int(x.n)} | {c(x.slope, x.se, x.p)} | {x.gamma:.1f}% | {x.p_boot:.3f} |"
                 f" {c(x.b_below, x.se_below, x.p_below)} | {c(x.b_above, x.se_above, x.p_above)} |")
write("tableC1", lines, "Notes: Linear slope per 1 pp of the social housing measure with region-by-year fixed effects and full controls."
      " Threshold: slope-and-intercept threshold model, 299 wild cluster bootstrap replications. Slopes below/above are the regime-"
      "specific slopes at the estimated location. " + NOTE)

# Table D1: identification diagnostics ------------------------------------------------------------------
vd = pd.read_csv(os.path.join(TAB, "appendixD_variance.csv")); td = pd.read_csv(os.path.join(TAB, "appendixD_tests.csv"))
info = pd.read_csv(os.path.join(TAB, "appendixD_sample.csv")).iloc[0]
lines = ["| Diagnostic | Estimate | SE | p-value |", "|---|---|---|---|"]
lines.append("| *A. Variation available for designs that rely on change over time* | | | |")
for _, x in vd.iterrows():
    lines.append(f"| {x.label}, within-LA SD / between-LA SD | {x.within_sd:.2f} / {x.between_sd:.2f} | | |")
lines.append("| *B. Event study around the first large completion pulse* | | | |")
for _, x in td.iterrows():
    if x.test.startswith("Shift-share"):
        continue
    stat = f"F = {x.stat:.2f} (df = {int(x.df)})" if x.test.startswith("Pre-trend") else f"{x.stat:.3f}"
    se = "" if pd.isna(x.se) else f"{x.se:.3f}"
    lines.append(f"| {x.test} | {stat} | {se} | {x.p:.3f} |" if x.p >= 0.001 else f"| {x.test} | {stat} | {se} | <0.001 |")
lines.append("| *C. Shift-share instrument for new social/affordable rent completions* | | | |")
for _, x in td[td.test.str.startswith("Shift-share")].iterrows():
    se = "" if pd.isna(x.se) else f"{x.se:.3f}"
    lines.append(f"| {x.test.replace('Shift-share first stage: ', 'First stage, ')} | {x.stat:.2f} | {se} | {x.p:.3f} |")
write("tableD1", lines, f"Notes: Panel A uses the 2016-2025 growth sample. Panel B uses the Sun and Abraham (2021) interaction-weighted"
      f" estimator on 100 x log PIPR rent index, 2015-2025. Treated LAs ({int(info.treated_las)}) are those whose first financial year"
      f" with at least 3 social/affordable rent completions per 1,000 dwellings falls in {int(info.first_cohort)}-{int(info.last_cohort)};"
      f" controls are {int(info.never_treated)} never-treated LAs; {int(info.excluded_early)} LAs first treated before 2017 have no"
      " pre-period in the rent data and are excluded. Pre-trend tests are joint Wald tests that all cohort-specific coefficients"
      " for event years -2 to -6 equal zero. The changes in slope and level at the event come from a weighted regression of the"
      " event-time coefficients (years -6 to 6) on event time, a post-event indicator and their interaction. Panel C: first stage"
      " of new social/affordable rent completions per 1,000 dwellings on a shift-share predictor (pre-period LA share of national"
      " completions x leave-one-out national completions), with LA and year fixed effects and the Table 2 growth controls; the F"
      " statistic is the squared clustered t-statistic of the excluded instrument. Standard errors clustered by LA.")
print("tables:", sorted(os.listdir(MD)))
