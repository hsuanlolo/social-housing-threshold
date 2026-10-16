---
title: "Is There a Social Housing Threshold? Market Share, Rental Competition, and Private Rent Growth across English Local Authorities"
author: "Hsuan Lo"
date: "Draft, October 2026 — not for circulation"
---

# Abstract

Advocates of large-scale social housing often argue that non-market rental housing must reach a "critical mass" before it disciplines private rents. We test this proposition with a balanced panel of all 294 English local authorities from 2016 to 2025. The panel links an administrative index of private rents to the social housing stock and to annual flows of new social/affordable rental completions, acquisitions and Right to Buy sales. One fixed-effects framework answers five questions: the average effect, nonlinearity and thresholds, threshold heterogeneity, its institutional correlates, and mechanisms. Three findings stand out. First, the stock share varies almost entirely across places rather than over time, so its effect cannot be credibly separated from place characteristics. Flows provide the usable variation. Each additional social or affordable rental completion per 1,000 dwellings, cumulated over two years, is associated with about 0.07 percentage points slower annual private rent growth. Losses through Right to Buy point the other way. Second, there is no statistically identifiable threshold. Spline, generalized additive and Hansen panel-threshold estimates all fail to reject linearity, and if anything marginal effects are largest where social housing is scarce. Third, the rent response concentrates in the one- and two-bedroom segments where new social homes are concentrated. New supply also does not crowd out private completions. Both patterns are consistent with direct competition and net supply rather than a market-share tipping point. The policy implication is that the rent dividend of social housing accrues incrementally, at any baseline share.

**Keywords:** social housing; private rents; threshold regression; rental market integration; Right to Buy; England

# 1. Introduction

Social housing is back on the policy agenda in high-cost housing markets. In England, governments have committed to the largest social and affordable house-building programme in a generation. US jurisdictions such as Seattle and Montgomery County, Maryland, have created public developers inspired in part by Vienna. A recurring argument in these debates is that social housing does more than house its own tenants: by competing with private landlords it restrains rents throughout the market. A stronger version holds that this happens only once the non-market sector is large enough to "lead" or "dominate" the rental market (Kemeny, 1995; Kemeny, Kersloot, & Thalmann, 2005). On this view small programmes are a transfer to their lucky tenants, while a programme that crosses some threshold — often loosely placed at 20 to 30 percent of the stock — changes how the whole rental market prices housing.

Whether such a threshold exists matters for policy design. If rent effects appear only above a critical mass, scarce subsidy should be concentrated where social housing is already close to the threshold, and incremental programmes elsewhere will disappoint. If effects are roughly proportional, every additional unit delivers a similar market-wide dividend and the case for spreading supply rests on other grounds. Despite its prominence, the threshold claim has rarely been tested directly. The most relevant evidence comes from Austria. A long panel of microcensus data suggests that non-profit housing dampens unregulated private rents by about 5 percent, with a rent differential that narrows nonlinearly as the non-profit share rises (Klien et al., 2023). Neighbourhood-level analysis of Vienna finds that subdistricts with more limited-profit housing are more likely to follow lower private rent trajectories (Banabak, 2023). These studies cover a single high-share regime, and they do not estimate where — or whether — the effect switches on.

This paper asks five connected questions. **RQ1:** does social housing reduce private rent growth on average? **RQ2:** is the relationship nonlinear, and is there a statistically identifiable threshold? **RQ3:** do thresholds differ across places? **RQ4:** which market institutions explain any heterogeneity? **RQ5:** through which mechanisms — additional supply, competition, or displacement of demand — do effects arise? We answer them within one panel framework rather than five separate models, using England as the laboratory.

England is well suited to the questions. Social housing shares across its 294 local authorities (LAs) range from about 5 percent (Castle Point) to almost 40 percent (Islington, Southwark, Hackney), and up to 43 percent earlier in the decade — wider support than any single country's city set and almost the full range over which thresholds have been conjectured. All LAs share one national legal framework: private rents are unregulated, allocation rules and the welfare system are common, and the national funding programme is the same everywhere. Institutional differences that confound cross-national comparisons are therefore held constant. Three sources of variation in the social stock coexist, mapping directly onto the mechanisms of interest. New construction adds to the total stock. Acquisitions convert existing private dwellings to sub-market tenure without adding units. Right to Buy (RTB) sales convert council dwellings into owner occupation, and often subsequently into private renting (Jones & Murie, 2006; Sprigings & Smith, 2012). Finally, since 2024 the Office for National Statistics (ONS) has published an administrative, quality-adjusted Price Index of Private Rents (PIPR) for every LA back to 2015. For the first time this allows a consistent local panel of private rent growth.

Our results are, in one sense, deflationary for the threshold hypothesis. We find no evidence of a critical mass. Spline and generalized additive models (GAMs) draw essentially linear or flat curves. Hansen (1999) panel threshold tests do not reject linearity for the stock share, for the rent effect of new supply, or for the rent effect of RTB losses (bootstrap p-values 0.17-0.47). The descriptive regime pattern runs opposite to the critical-mass story: both the rent-reducing effect of new build and the rent-raising effect of RTB losses are largest in LAs with *below-median* social shares. The results are not deflationary about social housing itself. New social and affordable rental supply is robustly associated with slower private rent growth. Losing social dwellings through RTB is associated with faster growth. The effect concentrates in the small-dwelling segments where new social homes compete most directly. New social supply adds roughly one-for-one to net housing supply rather than crowding out private construction.

The paper makes three contributions. Substantively, it provides the first systematic test of the social housing threshold hypothesis across a wide and policy-relevant range of market shares, and it separates statistical thresholds from policy-relevant magnitudes. Methodologically, it shows that the stock share — the variable usually used in cross-city comparisons — varies almost entirely between places (between-LA SD 6.0 percentage points against within-LA SD 0.4). Its effects are therefore not separately identifiable from place characteristics with fixed-effects designs, and much of the existing cross-sectional evidence should be read as conditional association. Flows of new supply and losses offer more credible variation, and threshold questions can be reframed as whether the effect of flows depends on the stock regime. Finally, the mechanism tests — new build versus acquisition versus RTB, segment-specific rents from direct (unmodelled) rent data, and crowd-out of private completions — move the literature beyond reduced-form associations.

The remainder of the paper is organised as follows. Section 2 reviews theory and evidence. Section 3 describes the data and the cleaning process. Section 4 sets out the empirical framework. Section 5 presents results for each research question, and Section 6 assesses robustness and an extension to price stabilisation. Section 7 discusses policy implications and limitations.

# 2. Theory and Evidence

## 2.1 Why social housing might affect private rents

Three channels link the size of the social sector to private rents. They have different implications for nonlinearity.

**Additional supply.** If social housing adds to the total housing stock rather than crowding out private construction, it shifts the rental supply curve outward and lowers market rents like any other new supply. Under standard assumptions this effect is proportional to the number of units added and implies no threshold. The empirical question is the degree of crowd-out: US estimates range from near-complete crowd-out of LIHTC housing in some settings (Malpezzi & Vandell, 2002; Eriksen & Rosenthal, 2010) to partial crowd-out in others, with roughly a third of subsidised units adding to the occupied stock (Sinai & Waldfogel, 2005; see also Murray, 1999). New market-rate supply has been shown to reduce nearby rents in US cities (Asquith, Mast, & Reed, 2023; Li, 2022), while LIHTC developments can raise or lower nearby prices depending on neighbourhood context (Baum-Snow & Marion, 2009; Diamond & McQuade, 2019).

**Competition (market integration).** Kemeny's (1995) theory of "unitary" rental markets holds that a cost-rent non-profit sector open to a broad population competes directly with for-profit landlords. Once the non-profit sector matures — its historic-cost rents fall below market rents and its stock is large — it can "influence", "lead" and eventually "dominate" rent-setting (Kemeny et al., 2005). This channel is the theoretical source of the threshold hypothesis: competition matters only if enough tenants have a realistic non-market option. Competition also implies *segment specificity*: effects should be strongest in the market segments where social dwellings are close substitutes for private ones. In England these are the one- and two-bedroom segments. In "dual" rental markets, by contrast, social housing is residualised and rationed by need, so its competitive influence on private landlords is weak (Kemeny, 1995; Stephens, 2020). England is usually classified as dual, which makes it a demanding test of the competition channel.

**Demand displacement.** Social lettings can lower private rents by removing households from private-rental demand. In England roughly one in six new general-needs social tenants previously rented privately (Section 5.5). The effect is proportional to lettings, and it implies falling waiting lists where supply is added.

These channels predict different patterns. A pure supply effect is linear, symmetric between gains and losses, and similar for new build and acquisitions only to the extent that acquisitions add to effective supply. Competition can be nonlinear and segment-specific. Displacement scales with lettings and should be visible in housing registers. Our mechanism tests in Section 5.5 are designed around these contrasts.

## 2.2 Evidence on market-share effects

Direct evidence on market-wide rent effects of the social housing share is thin. Klien et al. (2023) pool five decades of Austrian microcensus data and estimate that a 10 percent increase in the limited-profit share lowers private rents by €0.30-0.40 per square metre. They document a narrowing rent gap at higher shares. Banabak (2023) links Viennese subdistricts' private rent trajectories to their tenure structure and finds a dampening association that is strongest in peripheral, low-pressure locations, and weaker for municipal than for limited-profit housing. In France, the SRU law's 20-25 percent municipal quota is a policy threshold. It raised social construction in deficit municipalities but had no detectable effect on resale prices (Gobillon & Vignolles, 2016), and it did little for income mixing (Chapelle, Gobillon, & Vignolles, 2022). Evidence from the reverse direction — losses of regulated units — is emerging. In Berlin, the staggered expiry of social-housing commitments raised advertised rents in affected tracts by 4-5 percent (Günnewig-Mönert, 2025). The literature therefore suggests dampening effects exist. What it has not established is whether they are proportional or switch on beyond a share, nor which mechanism drives them.

# 3. Data

## 3.1 Unit of analysis and sample

The unit is the English local authority district on April-2023 boundaries. All LA reorganisations between 2010 and 2023 were mergers of whole districts (e.g., Buckinghamshire 2020; North and West Northamptonshire 2021; Cumberland, Westmorland and Furness, North Yorkshire and Somerset 2023). Predecessor districts therefore aggregate exactly into current LAs without areal interpolation. City of London and the Isles of Scilly are excluded because PIPR does not cover them. The estimation sample is a balanced panel of 294 LAs over 2016-2025 (N = 2,940); rent levels from 2015 and stock and flow data from 2010 are used for lags. Appendix A documents every cleaning step. The full log is generated automatically by the replication code.

## 3.2 Private rents

The outcome is annual private rent growth from the ONS Price Index of Private Rents (PIPR). PIPR is built from administrative rent data covering new and existing tenancies, mix-adjusted, and published monthly from January 2015 for every LA. We average the twelve monthly index values within each calendar year and define rent growth as 100 times the change in the log annual index. We drop 2026 because only eight months are available. Because PIPR covers the stock of tenancies, it is smoother than asking-rent series and captures rents actually paid. Average rent growth was 3.8 percent per year, ranging from 1.7 percent in 2018-2020 to 7.6 percent in 2024 (Table 1).

PIPR also reports bedroom- and property-type indices for each LA. We found that within-LA changes in these segment indices are almost perfectly correlated (r = 0.99 between one-bed and four-plus-bed growth after removing LA and region-year means). This is consistent with segment indices that inherit LA-level dynamics from the estimation model, so they cannot discriminate between segments. For segment-specific tests we therefore use the Valuation Office Agency/ONS Private Rental Market Statistics (PRMS). These report direct LA median monthly rents of new lettings by bedroom count for twelve-month windows to September. We assemble ten non-overlapping releases (2014-2023). The PRMS series are noisier, but within-LA segment growth rates are only moderately correlated (0.26-0.60), so they carry independent segment information.

## 3.3 Social housing stock and flows

The social housing share is the stock owned by local authorities plus private registered providers (housing associations), divided by the total dwelling stock. It comes from MHCLG Live Table 100, measured at 31 March each year. We use the share at 31 March of year *t*−1, measured 9 to 21 months before the rent observations of calendar year *t*. Computing the share from combined LA and housing-association stock ensures that large-scale voluntary transfers of council stock to housing associations — which move units between columns without changing social tenure — do not create artificial changes. We repaired two transient one-year spikes in combined stock that reverse the following year (reporting errors, Appendix A).

Flows come from the Affordable Housing Supply open data (completions by LA, tenure, and new build versus acquisition) and the Right to Buy sales open data. We distinguish four groups:

- new-build Social Rent (including London Affordable Rent);
- new-build Affordable Rent, a tenure introduced in 2011 with rents of up to 80 percent of local market rents;
- rental acquisitions of existing dwellings;
- council RTB sales.

Ownership products such as shared ownership are excluded from social rental supply. All flows are expressed per 1,000 dwellings of lagged stock and assigned to the financial year ending in March of year *t*.

## 3.4 Controls and moderators

Time-varying controls, all lagged one year, are population growth (ONS mid-year estimates), growth in median full-time earnings (ASHE), the model-based unemployment rate (APS), and net additional dwellings per 1,000 (Live Table 122). Lagging makes the controls predetermined with respect to rent shocks in *t*. It also keeps 2025 in the sample, since 2025 population and earnings estimates are not yet published. For the 2019-2023 unitary authorities and two re-coded districts, Nomis does not publish some years on 2023 boundaries. These were back-filled from predecessor districts: population is summed exactly, and earnings medians and unemployment rates use population-weighted means.

Following the recommendation to pre-specify a small number of theory-driven moderators, RQ4 uses five time-invariant LA characteristics measured before or independently of the outcome window:

1. Rental-sector size: the private-rented share of households in the 2011 Census.
2. Supply restrictiveness: the refusal rate of major residential planning applications, 1979-2013, following Hilber and Vermeulen (2016).
3. Price proximity of new social supply: the Affordable Rent share of new social/affordable rental completions. Affordable Rent is a closer substitute for private renting than Social Rent.
4. Market slack: the 2014 vacancy rate, measured pre-sample to avoid treating a potential mediator as a moderator.
5. Spatial concentration: a dissimilarity index between social-renting and other households across 2021 LSOAs.

England has no private rent regulation, so rent regulation — a moderator of interest in cross-national work — is constant by design.

## 3.5 Descriptive patterns

Table 1 summarises the data. Figure 1 maps the social housing share and 2015-2025 rent growth. Two features shape the empirical strategy. First, the social share is strongly persistent: its within-LA standard deviation over 2016-2025 is 0.43 percentage points against 6.05 between LAs. The national share drifted down only slowly, from 17.5 to 16.5 percent between 2012 and 2025. Second, flows of new supply vary as much within LAs as between them (within SD 0.89, between SD 0.77 per 1,000 dwellings). Identification from within-LA changes is therefore realistic for flows but not for the stock share. Raw correlations between the share and rent growth are close to zero (r = −0.006). Mean rent growth is flat across share bins up to 30 percent and lower above 30 percent, a group dominated by inner London.

**Table 1. Descriptive statistics, 2016-2025**

| Variable | Mean | SD | P10 | Median | P90 |
|---|---|---|---|---|---|
| Private rent growth, PIPR (% per year) | 3.79 | 2.74 | 0.80 | 3.34 | 7.54 |
| Social housing share of stock, t-1 (%) | 15.74 | 6.06 | 9.62 | 14.08 | 24.34 |
|   of which council-owned (%) | 5.77 | 6.52 | 0.00 | 4.13 | 15.26 |
|   of which housing-association-owned (%) | 9.98 | 5.52 | 3.62 | 9.26 | 17.18 |
| Social/affordable rent new build per 1,000 dwellings | 1.31 | 1.18 | 0.15 | 1.01 | 2.88 |
|   Social Rent new build per 1,000 | 0.34 | 0.65 | 0.00 | 0.04 | 1.06 |
|   Affordable Rent new build per 1,000 | 0.97 | 0.99 | 0.00 | 0.69 | 2.24 |
| Rental acquisitions per 1,000 dwellings | 0.14 | 0.28 | 0.00 | 0.02 | 0.39 |
| Right to Buy sales per 1,000 dwellings | 0.35 | 0.52 | 0.00 | 0.12 | 1.06 |
| Population growth, t-1 (%) | 0.74 | 0.71 | -0.08 | 0.69 | 1.65 |
| Median FT earnings growth, t-1 (%) | 3.18 | 5.10 | -2.66 | 3.08 | 9.37 |
| Unemployment rate, t-1 (%) | 4.04 | 1.32 | 2.60 | 3.80 | 5.90 |
| Net additional dwellings per 1,000, t-1 | 9.27 | 5.06 | 3.79 | 8.36 | 15.77 |
| Vacancy rate, t-1 (%) | 2.62 | 0.73 | 1.78 | 2.54 | 3.50 |
| House price growth, UK HPI (% per year) | 3.62 | 3.87 | -0.93 | 3.09 | 9.15 |
| Private-rented share of households, 2011 (%) | 15.91 | 5.46 | 10.95 | 14.17 | 23.55 |
| Major residential refusal rate, 1979-2013 (%) | 26.18 | 9.00 | 15.10 | 25.82 | 37.68 |
| Affordable Rent share of new social lets (%) | 72.03 | 21.08 | 37.64 | 78.12 | 94.55 |
| Dissimilarity index, social vs other households (0-100) | 40.76 | 6.42 | 32.72 | 40.94 | 48.85 |

Notes: 294 local authorities x 10 years (2016-2025), N = 2,940. Within/between standard deviations: sh_share_l1: within SD 0.433, between SD 6.049; soc_nb_pk: within SD 0.891, between SD 0.768; rtb_pk: within SD 0.197, between SD 0.483; aq_pk: within SD 0.238, between SD 0.147; dlnrent_all: within SD 2.652, between SD 0.671.


![Figure 1. Social housing shares (2025) and average annual private rent growth (2015-2025), English local authorities.](../output/figures/fig1_maps.png){width=100%}


# 4. Empirical Framework

All models share one LA-by-year panel and one baseline specification:

$$\Delta \ln R_{it} = \beta' S_{it} + \gamma' X_{i,t-1} + \alpha_i + \lambda_{r(i)t} + \varepsilon_{it}$$

$\Delta \ln R_{it}$ is private rent growth. $S_{it}$ is either the lagged stock share or a vector of social housing flows. $X_{i,t-1}$ are the lagged controls, $\alpha_i$ are LA fixed effects, and $\lambda_{r(i)t}$ are region-by-year fixed effects that absorb regional cycles, including London's distinct post-pandemic rent dynamics. Standard errors are clustered by LA. The preferred flow measure cumulates completions or sales over the current and previous financial year, because the rent response to completions builds over about two years (Table 2).

**Model 1 (RQ1).** We estimate the baseline with the stock share and with flows. Because the share has little within-LA variation, we complement it with three designs:

- a correlated-random-effects (Mundlak, 1978) model that separates within- and between-LA associations;
- a long-difference cross-section of 2015-2025 rent growth on the 2014 share;
- a shift-share predictor of completions that combines each LA's pre-sample (2010/11-2013/14) share of national social/affordable rental new build with leave-one-out national completions (Goldsmith-Pinkham, Sorkin, & Swift, 2020).

For dynamics, we estimate an event study around each LA's first "large completion pulse" (at least 3 social/affordable rental completions per 1,000 dwellings in a year, roughly the top 6 percent of LA-years). We use the Sun and Abraham (2021) interaction-weighted estimator with never-treated LAs as controls, which avoids the negative-weighting problems of two-way fixed effects under staggered adoption (Goodman-Bacon, 2021).

**Model 2 (RQ2).** We proceed in two steps. First we let the data draw the curve without pre-specified cut points. We use (a) a GAM with a penalised smooth of the share, LA random intercepts and region-year fixed effects (Wood, 2017); (b) a natural cubic spline in the share with LA fixed effects, identified only from within-LA changes; (c) a GAM on the long-difference cross-section; and (d) a varying-coefficient GAM in which the marginal effects of new build and RTB sales are smooth functions of the share. Second, we estimate Hansen (1999) fixed-effect panel threshold models:

$$\Delta \ln R_{it} = \beta_1' x_{it}\, \mathbb{1}(q_{it} \le \tau) + \beta_2' x_{it}\, \mathbb{1}(q_{it} > \tau) + \gamma' z_{it} + \alpha_i + \lambda_{r(i)t} + \varepsilon_{it}$$

The threshold variable $q_{it}$ is the lagged share. We consider three versions of the regime-dependent regressors $x_{it}$: (L) the share itself, the "level" threshold; (F) new build and RTB flows, asking whether the effect of supply changes depends on the stock regime; and (F1/F2) each flow separately. The threshold is estimated by concentrated least squares over a grid of candidate values between the 10th and 90th percentiles of the share. The test of no threshold uses a wild cluster bootstrap that resamples LAs with Rademacher weights, because the threshold is not identified under the null (Hansen, 1996). Confidence sets invert the likelihood-ratio statistic (Hansen, 2000). A second threshold is searched sequentially. We also estimate a cross-sectional threshold model on long differences (Hansen, 2000). Following the distinction proposed in the research design, we define a *statistical* threshold as a share at which the slope changes identifiably. We separately report the *policy-relevant* magnitudes implied by the estimates. The two need not coincide.

**Model 3 (RQ3-4).** Estimating a separate threshold for each LA is infeasible: no LA's share moves by more than a few points in ten years. We therefore allow thresholds to vary with LA characteristics in three ways:

- re-estimating the threshold model separately for LAs above and below the median of each moderator;
- an *index threshold* model in which the regime switches when $q_{it} + \theta Z_i > \tau_0$, so the LA-specific threshold is $\tau_i = \tau_0 - \theta Z_i$. This is a parametric analogue of a hierarchical threshold model (Seo & Linton, 2007), estimated by two-dimensional grid search with an LA-cluster bootstrap;
- a multilevel random-coefficient model in which LAs have their own slopes on new supply (partial pooling), with cross-level interactions between the flows and the standardised moderators. This model answers RQ4, and we compare it with the same interactions in the fixed-effects framework.

**Mechanisms (RQ5).** We test additional supply versus tenure conversion by comparing new build, acquisitions and RTB sales. We test competition with segment-specific PRMS rents and with the Social Rent versus Affordable Rent contrast. We test displacement and crowd-out with waiting-list growth, private-enterprise completions, net additions and house prices as outcomes.

# 5. Results

## 5.1 RQ1: average effects

Table 2 reports the main estimates. With LA and year fixed effects, a one-point higher lagged share is associated with 0.44 points slower rent growth (column 1). Adding region-by-year effects shrinks the estimate to −0.15 and makes it insignificant (column 2). Most of the column-1 association therefore reflects regional trends — chiefly that London's share and its rent growth both fell relative to other regions. The correlated-random-effects model (column 7) shows why the stock share is a poor treatment. The within coefficient is −0.15, but the coefficient on the LA mean is +0.16, so the implied between-LA association is essentially zero. In the long-difference cross-section (column 8), LAs with higher 2014 shares, if anything, saw marginally *faster* rent growth over the decade (0.010 points per point of share, p = 0.11), conditional on demand fundamentals and initial rent levels. Places with large social sectors do not, on average, have slower private rent growth.

Flows tell a clearer story. New social/affordable rental completions are associated with slower rent growth with a lag. In column 4, one additional completion per 1,000 dwellings lowers growth by 0.05 points in the year of completion and by a further 0.09 points (p < 0.05) the following year. The summed two-year coefficient used in the rest of the paper is −0.071 (SE 0.029; Table 5). Future completions do not predict current rent growth (placebo, column 5), which argues against reverse causality running from anticipated rent growth to completions. RTB sales move rents in the opposite direction: one additional sale per 1,000 dwellings is associated with 0.5 points faster rent growth in the same year. Acquisitions show a lagged negative association of similar magnitude to new build. The shift-share instrument has a weak first stage (F = 3.9), so the 2SLS estimate (−0.92, SE 1.35) is uninformative. We do not rely on it.

How large are these effects? The median LA completes about 1.0 social/affordable rental home per 1,000 dwellings per year, and the 90th percentile 2.9. Sustained delivery at 3 per 1,000 per year — which would raise a typical LA's social share by roughly 3 percentage points over a decade — implies annual rent growth about 0.43 points lower (2 × 3 × 0.071). Cumulated over ten years, that is about 4 percent lower private rents than otherwise. These are meaningful but modest magnitudes, of a similar order to local rent effects documented for new market-rate supply (Asquith et al., 2023), although the units are not directly comparable.

**Table 2. RQ1: social housing stock, flows and private rent growth**

| | (1) TWFE | (2) TWFE | (3) Flows | (4) Flows+lags | (5) Placebo | (6) 2SLS | (7) CRE | (8) Long diff. |
|---|---|---|---|---|---|---|---|---|
| SH share, t-1 (pp) | -0.436***<br>(0.105) | -0.153<br>(0.103) |  |  |  |  | -0.153<br>(0.103) |  |
| LA mean of SH share (Mundlak) |  |  |  |  |  |  | 0.158<br>(0.103) |  |
| SH share, 2014 (pp) |  |  |  |  |  |  |  | 0.010<br>(0.006) |
| Social/affordable new build, t |  |  | -0.051<br>(0.036) | -0.047<br>(0.035) | -0.067*<br>(0.036) |  |  |  |
| Social/affordable new build, t (instrumented) |  |  |  |  |  | -0.918<br>(1.354) |  |  |
| Social/affordable new build, t-1 |  |  |  | -0.094**<br>(0.039) |  |  |  |  |
| Social/affordable new build, t+1 (placebo) |  |  |  |  | -0.024<br>(0.033) |  |  |  |
| Rental acquisitions, t |  |  | 0.035<br>(0.109) | 0.062<br>(0.108) | 0.024<br>(0.108) |  |  |  |
| Rental acquisitions, t-1 |  |  |  | -0.305**<br>(0.131) |  |  |  |  |
| Right to Buy sales, t |  |  | 0.492**<br>(0.202) | 0.514***<br>(0.187) | 0.553***<br>(0.209) |  |  |  |
| Right to Buy sales, t-1 |  |  |  | -0.092<br>(0.195) |  |  |  |  |
| LA fixed effects | Yes | Yes | Yes | Yes | Yes | Yes | No (Mundlak) | No |
| Time effects | Year | Region x year | Region x year | Region x year | Region x year | Year | Region x year | Region |
| Sample | Panel | Panel | Panel | Panel | 2016-24 | Panel | Panel | LA cross-section |
| Observations | 2940 | 2940 | 2940 | 2940 | 2646 | 2940 | 2940 | 294 |

Notes: Dependent variable is annual private rent growth (100 x change in log PIPR index) unless stated. Flows are per 1,000 dwellings (lagged stock). All panel models control for lagged population growth, earnings growth, unemployment and net additions per 1,000 dwellings. Standard errors clustered by local authority in parentheses (heteroskedasticity-robust in cross-sections). *** p<0.01, ** p<0.05, * p<0.10. Column (6) instruments new build with a shift-share predictor (first-stage coefficient 0.378, SE 0.205; first-stage F = 3.9, so the instrument is weak and column (6) is reported for completeness only). Column (8): dependent variable is average annual rent growth 2015-2025; controls are period means of the panel controls, log 2015 rent, 2011 private-rented share and 2014 vacancy rate.


The event study offers a cautionary note (Figure 2; Table 2b). Private rents in LAs that experience a large completion pulse decline relative to never-treated LAs after the pulse, and the average post-treatment effect is −1.2 log points (p = 0.01) with region-by-year effects. However, the decline began well before the pulse. Pre-period coefficients fall steadily from positive values, and joint tests reject zero pre-trends (F = 4.0, p < 0.001). A test for a change in slope at the event finds none (change in slope −0.03, SE 0.06). Allowing LA-specific linear trends shrinks the effect to −0.37 (p = 0.14). We read this as evidence that large social completion programmes are located where rents were already growing relatively slowly — areas with cheaper land, where s106 and grant-funded schemes are more viable. It is not evidence of a discrete break. The event study therefore does not provide stronger causal evidence than the panel, and the flow estimates should be interpreted as conditional associations robust to LA fixed effects, regional cycles and a placebo lead (Roth, 2022; Rambachan & Roth, 2023).

**Table 2b. Event study: average effect after the first large completion pulse**

| Specification | ATT (log points x100) | SE | p |
|---|---|---|---|
| LA + year FE | -0.913 | 0.525 | 0.083 |
| LA + region-year FE | -1.225 | 0.473 | 0.010 |
| LA trends + region-year FE | -0.368 | 0.246 | 0.136 |

Notes: Sun-Abraham interaction-weighted estimator; 71 treated LAs (first pulse 2017-2025) vs 148 never-treated LAs; LAs first treated 2012-2016 excluded. Joint tests reject zero pre-period coefficients in all specifications (see text), so these ATTs are not interpreted causally.


![Figure 2. Event study: private rents around the first large social/affordable rental completion pulse (Sun-Abraham estimator, 95% CIs).](../output/figures/fig2_event_study.png){width=100%}


## 5.2 RQ2: nonlinearity and thresholds

Figure 3 shows the curves. The pooled GAM (panel a) uses a smooth with about two effective degrees of freedom that is not significantly different from a constant (p = 0.12). The within-LA spline terms are jointly insignificant (p = 0.52). The long-difference GAM (panel b) collapses to a straight line (1.04 effective degrees of freedom) with a weakly positive slope. Neither specification hints at a kink. The varying-coefficient GAM (panels c and d) shows that the marginal effect of new build is negative across the whole support, drifting from about −0.06 at a 7 percent share to −0.10 at 35 percent, with overlapping confidence bands. The marginal effect of RTB losses declines from about 0.15 at low shares to 0.06 at high shares.

![Figure 3. Nonlinear relationships: (a) pooled GAM smooth of rent growth on the lagged social share; (b) long-difference GAM; (c)-(d) marginal effects of two-year new build and RTB sales as smooth functions of the share. Dashed lines mark the (statistically insignificant) Hansen threshold estimates.](../output/figures/fig3_nonlinear_curves.png){width=100%}


The formal threshold tests in Table 3 confirm the visual impression. For no model can we reject the null of no threshold. Bootstrap p-values are 0.47 for the level model, 0.39 for the joint flow model, 0.17 for new build alone, 0.29 for RTB alone and 0.45 for the cross-sectional long-difference model. Likelihood-ratio confidence sets for the threshold location span most of the support (e.g., 9.6 to 24.3 percent for the level model; Figure 4). Under the sequential procedure, the data select a linear model. Re-estimating the flow-threshold models with the Census 2021 social-rented share of households as the regime variable — which guards against measurement error in the administrative stock share, the two measures correlating at 0.99 — gives the same conclusion (bootstrap p = 0.61 for new build and 0.25 for RTB; Table 3).

**Table 3. RQ2: threshold tests**

| Model | Threshold variable / regressor(s) | Single threshold (%) | 95% CI | F1 | Bootstrap p | 2nd threshold | F2 | Bootstrap p |
|---|---|---|---|---|---|---|---|---|
| L: level (x = q = SH share) | SH share / SH share | 22.1 | [9.6, 24.3] | 7.15 | 0.465 | 13.1 | 6.19 | 0.236 |
| F: new build + RTB, regime by SH share | SH share / new build + RTB | 14.2 | [10.3, 22.7] | 9.87 | 0.389 | 22.1 | 14.54 | 0.034 |
| F1: new build only, regime by SH share | SH share / new build | 14.2 | [13.1, 22.1] | 8.59 | 0.174 | 22.1 | 11.22 | 0.028 |
| F2: RTB only, regime by SH share | SH share / RTB | 16.1 | [9.6, 24.3] | 7.83 | 0.289 | 12.2 | 3.63 | 0.403 |
| F1c: new build only, regime by Census 2021 social share | Census 2021 share / new build | 14.0 | [10.1, 25.1] | 3.49 | 0.609 | 15.0 | 4.45 | 0.150 |
| F2c: RTB only, regime by Census 2021 social share | Census 2021 share / RTB | 14.3 | [10.1, 25.1] | 5.03 | 0.246 | 12.3 | 2.62 | 0.283 |
| X: long difference (cross-section) | 2014 SH share / 2014 SH share | 16.8 | [10.3, 22.5] | 5.51 | 0.445 |  |  |  |

Notes: Hansen (1999) fixed-effect threshold regressions with LA and region-by-year fixed effects (models L, F, F1, F2; N = 2,940) and Hansen (2000) cross-sectional threshold regression with region fixed effects (model X; N = 294). Flows are two-year cumulative completions/sales per 1,000 dwellings. Bootstrap p-values from 499 wild cluster (Rademacher, by LA) replications under the null of no threshold (F1) or one threshold (F2); 999 wild replications for model X. Candidate thresholds trimmed to the 10th-90th percentiles (15th-85th for X). Confidence intervals invert the likelihood-ratio statistic (critical value 7.35).


Conditional on a first split at 14.2 percent, a second threshold for new build at 22.1 percent is significant (p = 0.03). The regime coefficients in Table 3b are instructive. New build is associated with slower rent growth below 14.2 percent (−0.12, p < 0.01) and above 22.1 percent (−0.14, p < 0.10), but not between. RTB losses raise rent growth strongly below 16.1 percent (0.73, p < 0.01) and only weakly above. This pattern is the opposite of a critical-mass threshold, under which effects should be absent at low shares and emerge at high shares. The most robust feature is that marginal changes in social supply matter at least as much where social housing is scarce as where it is plentiful. That is what a supply-and-substitution account predicts when the marginal social unit is most valuable to the rental market where few close substitutes exist. Because the single-threshold test is not rejected, we treat the regime estimates as descriptive.

**Table 3b. RQ2: regime-specific coefficients at the estimated thresholds**

| | (L) Level | (F) Flows | (F1) New build | (F2) RTB |
|---|---|---|---|---|
| SH share x regime 1 | -0.088<br>(0.105) |  |  |  |
| SH share x regime 2 | -0.137<br>(0.102) |  |  |  |
| New build x regime 1 |  | -0.125***<br>(0.031) | -0.120***<br>(0.031) |  |
| New build x regime 2 |  | 0.047<br>(0.042) | 0.045<br>(0.040) |  |
| New build x regime 3 |  | -0.134*<br>(0.072) | -0.141*<br>(0.073) |  |
| RTB x regime 1 |  | 0.579**<br>(0.225) |  | 0.732***<br>(0.227) |
| RTB x regime 2 |  | 0.325*<br>(0.169) |  | 0.150<br>(0.135) |
| RTB x regime 3 |  | 0.119<br>(0.144) |  |  |
| Social/affordable new build (t + t-1) |  |  |  | -0.071**<br>(0.029) |
| Right to Buy sales (t + t-1) |  |  | 0.200<br>(0.128) |  |
| Rental acquisitions (t + t-1) |  | -0.115<br>(0.093) | -0.111<br>(0.092) | -0.124<br>(0.093) |
| Regimes (SH share, %) | <22.1 / >22.1 | <14.2 / 14.2-22.1 / >22.1 | <14.2 / 14.2-22.1 / >22.1 | <16.1 / >16.1 |
| LAs per regime | 258/45 | 157/117/45 | 157/117/45 | 195/109 |
| Observations | 2940 | 2940 | 2940 | 2940 |

Notes: Dependent variable is annual private rent growth (100 x change in log PIPR index) unless stated. Flows are per 1,000 dwellings (lagged stock). All panel models control for lagged population growth, earnings growth, unemployment and net additions per 1,000 dwellings. Standard errors clustered by local authority in parentheses (heteroskedasticity-robust in cross-sections). *** p<0.01, ** p<0.05, * p<0.10. Regime-specific coefficients evaluated at the estimated threshold(s); a second threshold is imposed only when its bootstrap p-value is below 0.10. Because the single-threshold test is not rejected for any model, the sequential procedure of Hansen (1999) selects zero thresholds; regime coefficients are shown to describe the pattern.


![Figure 4. Likelihood-ratio profiles for the threshold location. Values below the dashed line (7.35) form the 95% confidence set.](../output/figures/fig4_lr_profiles.png){width=100%}


Separating statistical from policy thresholds sharpens the point. Even without a statistical threshold, one can ask what share of new supply is needed for a policy-relevant effect — say, one percentage point lower annual rent growth. With a two-year coefficient of −0.071, that requires sustained completions of about 7 per 1,000 dwellings per year. This is above the 99th percentile of observed LA-years and more than six times the median. The binding constraint on the rent dividend of social housing in England is the volume of new supply, not the stock share that must be reached before effects appear.

## 5.3 RQ3: are there place-specific thresholds?

If a single national threshold is absent, thresholds might still exist in particular kinds of markets and be averaged away in the pooled estimates. Table 4a re-estimates the new-build threshold model separately for LAs above and below the median of each moderator, and in London versus the rest of England. In eleven of twelve subsamples the null of no threshold is not rejected (bootstrap p-values 0.19-0.74).

The exception is the half of LAs with small private rental sectors (2011 private-rented share at or below the median). There the test rejects linearity (p = 0.003, which survives a Bonferroni correction for twelve tests) at a share of 14.0 percent. The pattern is again not a critical mass. New build is associated with slower rent growth below 14 percent (−0.09, p = 0.02) and slightly *faster* growth above it (+0.09, p = 0.04). The split also largely separates southern from northern LAs: the modal region below the threshold is the South East, above it the North West. We therefore read it as a regional contrast rather than a market-share mechanism.

The index-threshold models (Table 4b) let the threshold shift continuously with each moderator, τ_i = τ_0 − θZ_i. They make the same point more formally. The point estimates of θ lie at or near the edges of the search grid, and the bootstrap confidence intervals span the entire grid for every moderator. The data contain no information about how a threshold would move with market characteristics — as expected if there is no threshold to move.

The multilevel random-slope model does reveal substantial heterogeneity in the *slope* of the rent response, even without a threshold. The estimated standard deviation of LA-specific new-build slopes is 0.20, against a mean of −0.08. A likelihood-ratio test strongly rejects a common slope (χ² = 14.5, p < 0.001). Places differ in how strongly private rents respond to new social supply. The difference is in the size of the response, not in a regime that switches on at some share.

**Table 4a. RQ3: thresholds and linear effects by moderator subsample**

| Moderator | Group | LAs | Threshold (%) | Bootstrap p | Linear new-build effect | Linear RTB effect |
|---|---|---|---|---|---|---|
| Private-rented share 2011 | At/below median | 147 | 14.0 | 0.003 | -0.010 (0.035) | 0.109 (0.149) |
| Private-rented share 2011 | Above median | 147 | 21.9 | 0.742 | -0.134*** (0.048) | 0.260 (0.214) |
| Planning refusal rate | At/below median | 147 | 21.9 | 0.388 | -0.066 (0.045) | 0.229 (0.168) |
| Planning refusal rate | Above median | 147 | 14.2 | 0.552 | -0.079** (0.034) | 0.085 (0.192) |
| Affordable Rent share of new lets | At/below median | 147 | 21.0 | 0.214 | -0.103** (0.042) | 0.356** (0.179) |
| Affordable Rent share of new lets | Above median | 147 | 20.1 | 0.194 | -0.041 (0.043) | 0.058 (0.170) |
| Vacancy rate 2014 | At/below median | 147 | 21.0 | 0.682 | -0.079** (0.036) | 0.342** (0.169) |
| Vacancy rate 2014 | Above median | 147 | 14.2 | 0.291 | -0.029 (0.050) | -0.202 (0.183) |
| Social housing concentration (D) | At/below median | 147 | 14.2 | 0.468 | -0.097*** (0.034) | 0.235 (0.196) |
| Social housing concentration (D) | Above median | 147 | 13.3 | 0.462 | -0.049 (0.052) | 0.194 (0.181) |
| London | Rest of England | 262 | 14.2 | 0.428 | -0.054* (0.029) | 0.192 (0.124) |
| London | London | 32 | 20.9 | 0.331 | -0.100 (0.086) | 0.322 (0.326) |

Notes: Hansen threshold regressions of rent growth on two-year cumulative new build with regime defined by the lagged SH share, estimated separately in each subsample (LA and region-by-year fixed effects; 299 wild cluster bootstrap replications; 15% trimming). The last two columns report the linear (no-threshold) coefficients in the same subsample.


**Table 4b. RQ3: index-threshold models (LA-specific thresholds)**

| Moderator Z (standardised) | theta | 95% bootstrap CI | tau0 (%) | 95% bootstrap CI |
|---|---|---|---|---|
| Private-rented share 2011 | -4.00 | [-6.00, 6.00] | 13.5 | [9.6, 22.8] |
| Planning refusal rate | 6.00 | [-5.00, 6.00] | 19.4 | [10.5, 22.0] |
| Affordable Rent share of new lets | 3.00 | [-6.00, 6.00] | 15.1 | [9.4, 23.2] |
| Vacancy rate 2014 | 2.00 | [-6.00, 6.00] | 11.3 | [9.5, 23.9] |
| Social housing concentration (D) | -5.00 | [-6.00, 6.00] | 9.4 | [7.3, 23.5] |

Notes: Index-threshold model in which the regime switches when SH share + theta x Z exceeds tau0, i.e. the LA-specific threshold is tau_i = tau0 - theta x Z_i (in percentage points per standard deviation of Z). Grid search over theta in [-6, 6] and tau0; LA-cluster pairs bootstrap.


## 5.4 RQ4: which institutions explain heterogeneity?

Which institutions explain this heterogeneity? Table 4c reports cross-level interactions between the flows and the five standardised moderators plus the social share itself, estimated jointly in the fixed-effects framework (column 1) and in the multilevel model (column 2). Table 4d adds the interactions one moderator at a time, because several moderators are correlated: for example, the Affordable Rent share correlates 0.41 with the vacancy rate and −0.36 with the private-rented share, and planning restrictiveness correlates −0.51 with the 2014 social share.

None of the moderators significantly shifts the rent effect of new build, in either the joint or the single-moderator specifications. The interaction with the social share itself is also small and insignificant, consistent with the absence of a threshold. The only robust moderator concerns losses. RTB sales raise private rent growth significantly more in tight markets: a one-standard-deviation lower 2014 vacancy rate increases the RTB effect by 0.24 points (p = 0.03). Median splits (Figure 5) point in the same direction: new build and RTB effects are both larger in low-vacancy LAs, and in LAs with larger private rental sectors and lower Affordable Rent shares. These subsample differences are not robust to the pooled interaction models, however.

The answer to RQ4 is therefore modest. Market slack conditions the rent consequences of losing social units — removing a sub-market dwelling matters most where vacant alternatives are scarce. But the observable institutional features usually invoked in the threshold debate (size of the rental sector, price proximity of the social offer, planning restrictiveness, spatial concentration) do not explain which LAs respond more strongly. Most of the heterogeneity documented in RQ3 remains unexplained by these characteristics.

**Table 4d. RQ4: moderators entered one at a time**

| Moderator (standardised) | x New build | x RTB sales |
|---|---|---|
| Private-rented share (2011) | -0.006 (0.037) | 0.043 (0.094) |
| Planning refusal rate | 0.011 (0.024) | 0.023 (0.111) |
| Affordable Rent share of new lets | 0.021 (0.028) | -0.088 (0.085) |
| Vacancy rate (2014) | 0.010 (0.032) | -0.241** (0.110) |
| Social housing concentration | -0.019 (0.020) | -0.033 (0.078) |
| SH share (2014) | -0.003 (0.026) | -0.042 (0.081) |

Notes: Each row is a separate regression of rent growth on two-year new build, acquisitions and RTB sales, their interactions with one standardised moderator, the Table 2 controls, and LA and region-by-year fixed effects. LA-clustered SEs. *** p<0.01, ** p<0.05, * p<0.10.


**Table 4c. RQ4: cross-level interactions between social housing flows and market institutions**

| | (1) FE, clustered SE | (2) Multilevel random slope |
|---|---|---|
| New build | -0.079**<br>(0.033) | -0.086***<br>(0.029) |
| RTB sales | 0.258<br>(0.181) | 0.178<br>(0.132) |
| New build x SH share (per 10 pp) | 0.040<br>(0.058) | 0.054<br>(0.054) |
| New build x Private-rented share 2011 | -0.001<br>(0.042) | -0.015<br>(0.030) |
| New build x Planning refusal rate | 0.025<br>(0.029) | 0.044<br>(0.033) |
| New build x Affordable Rent share of new lets | 0.022<br>(0.027) | 0.025<br>(0.030) |
| New build x Vacancy rate 2014 | 0.017<br>(0.033) | 0.003<br>(0.033) |
| New build x Social housing concentration (D) | -0.019<br>(0.022) | -0.015<br>(0.027) |
| RTB x SH share (per 10 pp) | -0.241<br>(0.173) | -0.110<br>(0.186) |
| RTB x Private-rented share 2011 | 0.087<br>(0.102) | 0.133<br>(0.083) |
| RTB x Planning refusal rate | -0.091<br>(0.116) | -0.049<br>(0.132) |
| RTB x Affordable Rent share of new lets | -0.053<br>(0.117) | 0.069<br>(0.118) |
| RTB x Vacancy rate 2014 | -0.284<br>(0.175) | -0.252<br>(0.155) |
| RTB x Social housing concentration (D) | 0.039<br>(0.111) | 0.007<br>(0.110) |
| Observations | 2940 | 2940 |

Notes: Moderators standardised (mean 0, SD 1); SH share centred. Column (1): LA and region-by-year fixed effects, LA-clustered SEs. Column (2): outcome and regressors within-transformed by LA and region-by-year, LA random slope on new build (REML); the random-slope SD is reported in the text. Controls as in Table 2. *** p<0.01, ** p<0.05, * p<0.10.


![Figure 5. Linear rent effects of new build and RTB sales in subsamples split at the median of each moderator.](../output/figures/fig5_heterogeneity.png){width=100%}


## 5.5 RQ5: mechanisms

**Additional supply versus tenure conversion.** If social housing worked only by adding units, acquisitions — which add no dwellings — should have no effect, and new build should matter. In Table 5a, column 1, the point estimate for acquisitions (−0.13, SE 0.09) is at least as large as for new build (−0.07, SE 0.03). The difference is not significant (0.06, SE 0.10, p = 0.56). RTB sales, which move dwellings out of social tenure without changing the total stock, are associated with faster rent growth (0.20, SE 0.13; larger and significant in the contemporaneous specification of Table 2). We cannot reject that a lost social unit raises rents by as much as a new one lowers them (sum 0.13, SE 0.12). Tenure conversion therefore appears to matter in its own right. A dwelling let at a sub-market rent to a household who would otherwise rent privately affects private rents even when total supply is unchanged. This pattern is consistent with competition and displacement channels operating alongside, not instead of, net supply. Acquisitions are rare (median 0.02 per 1,000 dwellings) and imprecisely estimated, so this conclusion is tentative.

**Crowd-out.** Social/affordable new build does not crowd out private construction. Each social completion per 1,000 dwellings coincides with 1.13 additional net dwellings (column 5) and 0.45 additional private-enterprise completions (column 4). A large share of affordable housing in England is delivered through Section 106 agreements on mixed-tenure private schemes, so social and private completions are partly co-produced rather than substitutes; the positive association should not be read as causal crowd-in. Net-supply additionality is therefore close to one-for-one, in contrast to the high crowd-out found for some US programmes (Murray, 1999; Eriksen & Rosenthal, 2010).

**Competition.** New social and affordable rental homes are concentrated in small dwellings: 67 percent are one- or two-bedroom homes, against 25 percent of private completions, and only 4 percent have four or more bedrooms (against 37 percent). If competition drives the rent effect, it should concentrate in the one- and two-bedroom segments. Table 5b and Figure 6 show exactly this gradient in the direct PRMS rents. A two-year completion per 1,000 dwellings is associated with 0.15 points slower growth of median one-bedroom rents (p = 0.04) and two-bedroom rents (p = 0.01), 0.07 points for three bedrooms (p = 0.30) and essentially zero for four or more bedrooms (−0.02, SE 0.14). The difference between small and large segments is imprecise (p = 0.34) because four-bedroom medians are noisy, but the monotone pattern matches the bedroom composition of new supply. The PIPR segment indices show no gradient at all (all coefficients −0.07), which is the expected signature of model-based indices that share LA-level dynamics. The Social Rent versus Affordable Rent comparison is inconclusive. Affordable Rent, priced closer to the market, has a precisely estimated effect (−0.064, p < 0.05). Social Rent has a similar but noisier point estimate (−0.091, SE 0.057), and the two do not differ significantly.

**Displacement.** New completions reduce housing waiting lists: one completion per 1,000 dwellings lowers the number of households on the register by about 1.1 percent in the same year (column 3). This is consistent with new lettings drawing households out of the queue, many of whom are housed in the private rented sector or in temporary accommodation while waiting. National CORE data show that 14-20 percent of new general-needs social lettings go to households previously renting privately, and up to 28 percent for some Affordable Rent lettings (Figure 7). Applied to the volume of new lettings, this proportion implies a non-trivial reduction in private rental demand. LA-level CORE microdata, which would allow a direct test, are not openly published.

Taken together, the mechanism evidence fits a picture of incremental effects working through net supply, direct competition in the small-dwelling segments, and displacement of private-rental demand. It does not fit a market-share tipping point.

**Table 5a. RQ5: supply channels, displacement and crowd-out**

| | (1) Rent growth | (2) Rent growth | (3) Waiting list growth | (4) Private completions | (5) Net additions | (6) House price growth |
|---|---|---|---|---|---|---|
| Social/affordable new build (t + t-1) | -0.071**<br>(0.029) |  |  |  |  | 0.035<br>(0.038) |
| Social Rent new build (t + t-1) |  | -0.091<br>(0.057) |  |  |  |  |
| Affordable Rent new build (t + t-1) |  | -0.064**<br>(0.031) |  |  |  |  |
| Rental acquisitions (t + t-1) | -0.130<br>(0.093) | -0.130<br>(0.093) |  |  |  | -0.003<br>(0.093) |
| Right to Buy sales (t + t-1) | 0.203<br>(0.128) | 0.202<br>(0.128) |  |  |  | 0.314*<br>(0.161) |
| Social/affordable new build, t |  |  | -1.136**<br>(0.528) | 0.446***<br>(0.052) | 1.127***<br>(0.108) |  |
| Social/affordable new build, t-1 |  |  | -0.036<br>(0.596) | -0.030<br>(0.056) | -0.009<br>(0.075) |  |
| Social/affordable new build, t-2 |  |  |  | 0.025<br>(0.051) | 0.031<br>(0.093) |  |
| Rental acquisitions, t |  |  | 3.006**<br>(1.501) | -0.549***<br>(0.153) | -0.322<br>(0.322) |  |
| Right to Buy sales, t |  |  | 2.463<br>(2.463) | -0.215<br>(0.306) | 0.182<br>(0.374) |  |
| Observations | 2940 | 2940 | 2882 | 2940 | 2940 | 2940 |

Notes: Dependent variable is annual private rent growth (100 x change in log PIPR index) unless stated. Flows are per 1,000 dwellings (lagged stock). All panel models control for lagged population growth, earnings growth, unemployment and net additions per 1,000 dwellings. Standard errors clustered by local authority in parentheses (heteroskedasticity-robust in cross-sections). *** p<0.01, ** p<0.05, * p<0.10. Columns (3)-(5) use the same controls and fixed effects; dependent variables are the percentage change in households on housing registers (3), private-enterprise completions per 1,000 dwellings (4) and net additional dwellings per 1,000 (5).


**Table 5b. RQ5: competition test by bedroom segment**

| Segment | New build: PRMS direct medians | New build: PIPR index | RTB: PRMS | RTB: PIPR |
|---|---|---|---|---|
| 1 bed | -0.154** (0.074) | -0.068** (0.029) | 0.226 (0.299) | 0.209 (0.127) |
| 2 bed | -0.149** (0.059) | -0.070** (0.029) | 0.201 (0.255) | 0.190 (0.128) |
| 3 bed | -0.065 (0.063) | -0.072** (0.029) | 0.038 (0.321) | 0.198 (0.127) |
| 4+ bed | -0.017 (0.140) | -0.073** (0.029) | 1.069 (0.995) | 0.228* (0.129) |

Notes: Segment-specific regressions with LA and region-by-year fixed effects and the Table 2 controls. PRMS: VOA/ONS Private Rental Market Statistics, growth of LA median monthly rent of lettings in the 12 months to September, 2015-2023, weighted by number of lettings, |growth| < 40%. PIPR segment indices are model-based and almost perfectly correlated with the all-property index within LAs (r = 0.99), so they cannot discriminate between segments; they are reported to show this. New social/affordable rent completions are 67% one- and two-bedroom homes (25% for private completions) and 4% four-plus-bedroom homes (37% private).


![Figure 6. Competition test: rent effects by bedroom count using direct PRMS medians and model-based PIPR indices.](../output/figures/fig6_segments.png){width=100%}


![Figure 7. Share of new general-needs social lettings to households previously renting privately (CORE), by tenure and landlord type.](../output/figures/fig7_core_prs.png){width=100%}


# 6. Robustness and Extensions

Table 6 and Figure 8 show that the new-build estimate is stable across specifications:

- excluding London: −0.054, p = 0.06;
- excluding the pandemic years 2020-2021: −0.077, p = 0.02;
- weighting by population: −0.105, p < 0.01;
- adding LA-specific linear trends: −0.063, p = 0.08;
- two-way clustering by LA and region-year: SE 0.033;
- controlling for neighbouring LAs' flows: −0.072, p = 0.02.

The spatial model shows no rent spillover from neighbours' new build (−0.02, SE 0.05), suggesting the effects are local to LA housing markets. With year rather than region-by-year fixed effects, the new-build coefficient falls to −0.04 and the RTB coefficient rises to 0.43 (p < 0.01). Measuring rents with PIPR rent levels instead of the index gives identical estimates. With the noisier PRMS all-property medians the new-build estimate is negative but imprecise (−0.04, SE 0.07). The stock-share coefficient is sensitive to specification: −0.44 with year effects, −0.15 with region-by-year effects, −0.08 with a two-year lag and −0.25 excluding London. This reinforces our conclusion that the stock share cannot be cleanly separated from regional and place-specific trends.

**Table 6. Robustness of the flow and stock-share specifications**

| Specification | New build | Acquisitions | RTB sales | N |
|---|---|---|---|---|
| Baseline | -0.071** (0.029) | -0.130 (0.093) | 0.203 (0.128) | 2940 |
| Year FE only | -0.041 (0.032) | -0.061 (0.111) | 0.427*** (0.119) | 2940 |
| Excl. London | -0.054* (0.029) | -0.142 (0.112) | 0.192 (0.124) | 2620 |
| Excl. 2020-21 | -0.077** (0.034) | -0.168 (0.120) | 0.099 (0.146) | 2352 |
| Pop.-weighted (2015) | -0.105*** (0.036) | -0.060 (0.109) | 0.265* (0.155) | 2940 |
| LA linear trends | -0.063* (0.035) | -0.112 (0.118) | 0.402* (0.215) | 2940 |
| Two-way cluster | -0.071** (0.033) | -0.130 (0.087) | 0.203 (0.142) | 2940 |
| Spatial lags | -0.072** (0.030) | -0.123 (0.092) | 0.145 (0.129) | 2940 |
| Outcome: PIPR rent level | -0.071** (0.029) | -0.131 (0.093) | 0.202 (0.128) | 2940 |
| Outcome: PRMS median | -0.038 (0.071) | -0.058 (0.188) | 0.102 (0.258) | 2352 |
| Share t-1 (baseline) | SH share: -0.153 (0.103) | | | 2940 |
| Share t-2 | SH share: -0.075 (0.102) | | | 2940 |
| Share t-1, excl. London | SH share: -0.252** (0.109) | | | 2620 |
| Share t-1, year FE | SH share: -0.436*** (0.105) | | | 2940 |

Notes: Dependent variable is annual private rent growth (100 x change in log PIPR index) unless stated. Flows are per 1,000 dwellings (lagged stock). All panel models control for lagged population growth, earnings growth, unemployment and net additions per 1,000 dwellings. Standard errors clustered by local authority in parentheses (heteroskedasticity-robust in cross-sections). *** p<0.01, ** p<0.05, * p<0.10.


![Figure 8. Robustness of the flow coefficients across specifications (95% CIs).](../output/figures/fig8_robustness.png){width=100%}


**Price stabilisation.** The original motivation of the threshold debate includes the claim that a large non-market sector stabilises housing markets. Table 6b relates the volatility of monthly year-on-year growth rates over 2016-2025 to the 2014 share in the LA cross-section. Higher social shares are associated with slightly *higher* private rent volatility (0.020 SD points per point of share, p = 0.05) and *lower* house-price volatility (−0.029, p < 0.01). Quadratic terms are insignificant in both cases. The house-price result is consistent with a smaller owner-occupied segment exposed to credit-driven swings, but with region fixed effects alone these cross-sectional associations are descriptive.

**Table 6b. Extension: social housing share and market volatility (cross-section)**

| | (1) Rent volatility | (2) Rent volatility | (3) Price volatility | (4) Price volatility |
|---|---|---|---|---|
| SH share 2014 (pp) | 0.020**<br>(0.010) | 0.050<br>(0.036) | -0.029***<br>(0.010) | 0.003<br>(0.030) |
| SH share 2014 squared |  | -0.001<br>(0.001) |  | -0.001<br>(0.001) |
| Observations | 294 | 294 | 294 | 294 |

Notes: Dependent variable is the standard deviation of monthly year-on-year growth rates, 2016-2025 (PIPR rents; UK HPI prices). Cross-section of 294 LAs with region fixed effects and controls for period-mean population growth, earnings growth, unemployment, net additions and log 2015 rent; robust SEs. *** p<0.01, ** p<0.05, * p<0.10.


# 7. Discussion and Conclusion

Is there a social housing threshold? In England, over a range of shares from 5 to 43 percent, the answer is no — at least not one that can be detected statistically. Neither the level of the share nor the rent effect of changes in social supply shows a critical mass. Where nonlinearity appears, it runs against the critical-mass story: marginal social units matter at least as much where the sector is small. The policy implication is encouraging for incremental programmes. Each additional social or affordable rental home in an LA where social housing is scarce delivers a rent dividend to private tenants that is at least as large as in an LA where social housing is already plentiful. Conversely, losses of social stock through RTB raise private rents most where the sector is thinnest. The recent tightening of RTB discounts and the restoration of councils' ability to retain receipts are thus supported by our estimates.

The magnitudes also caution against overselling. At realistic delivery rates of 1 to 3 completions per 1,000 dwellings per year, social supply slows private rent growth by roughly 0.1 to 0.4 percentage points per year. Social housing's case rests mainly on what it does for the households it houses. The market-wide dividend is real but secondary, and it scales with volume. For US jurisdictions considering Vienna-style programmes, the English evidence suggests that the competitive benefits of social housing need not wait for decades of accumulation to a critical share. They also cannot be expected to be large unless delivery is large.

Our findings do not contradict the Austrian evidence (Klien et al., 2023; Banabak, 2023). Austria's limited-profit sector is a cost-rent, broadly accessible, "unitary" system. England's is a needs-based, residualised, "dual" one, and our estimates refer to England's range of institutions. Kemeny's (1995) competition mechanism may require institutional features — broad eligibility, cost rents below market, a mature sector — that are not present in England at any share. Our finding that Affordable Rent, the closest English analogue to a near-market non-profit product, does not have systematically larger effects suggests that price proximity alone is not sufficient. A cross-national design that holds the outcome measure constant would be needed to test whether thresholds appear in unitary systems.

Several limitations should be noted. First, the identifying variation in flows is not experimental. The event study reveals that large completion programmes are located in LAs with pre-existing slower rent trends. Our preferred estimates control for LA fixed effects, regional cycles and lagged demand, and survive a placebo lead and LA-specific trends, but residual selection cannot be ruled out. The shift-share instrument was too weak to help. Second, PIPR, though the best available local rent measure, is a modelled index whose segment breakdowns are not informative. The PRMS alternative is noisy. Third, the decade we study is short relative to the slow evolution of social housing stocks, and the 2016-2025 period combines a pandemic with an exceptional rent surge. Fourth, displacement could only be studied with national CORE shares and waiting lists. LA-level CORE microdata would allow a direct test. Fifth, the administrative stock share includes some low-cost home-ownership units owned by housing associations and departs from the Census measure in a few LAs (e.g., Westminster and Medway), although the two correlate at 0.99 and threshold conclusions are unchanged with the Census measure.

Future work could exploit the expiry of social-rent restrictions, the post-2024 restoration of RTB receipts, and the forthcoming expansion of social rent delivery in England as sharper sources of variation. It could also apply the same unified framework to countries with unitary rental systems. The question of whether social housing tames private rents is not whether a threshold has been crossed, but how much is built.

# References

Asquith, B. J., Mast, E., & Reed, D. (2023). Local effects of large new apartment buildings in low-income areas. *Review of Economics and Statistics, 105*(2), 359-375.

Banabak, S. (2023). Neighbourhood rental market integration and private rent trajectories – evidence from the city of Vienna. *International Journal of Urban Sciences, 27*(2), 239-259.

Baum-Snow, N., & Marion, J. (2009). The effects of low income housing tax credit developments on neighborhoods. *Journal of Public Economics, 93*(5-6), 654-666.

Chapelle, G., Gobillon, L., & Vignolles, B. (2022). *Building without income mixing: Public housing quotas in France* (CEPR Discussion Paper No. 17535). Centre for Economic Policy Research.

Diamond, R., & McQuade, T. (2019). Who wants affordable housing in their backyard? An equilibrium analysis of low-income property development. *Journal of Political Economy, 127*(3), 1063-1117.

Eriksen, M. D., & Rosenthal, S. S. (2010). Crowd out effects of place-based subsidized rental housing: New evidence from the LIHTC program. *Journal of Public Economics, 94*(11-12), 953-966.

Gobillon, L., & Vignolles, B. (2016). Évaluation de l'effet d'une politique spatialisée d'accès au logement : la loi SRU. *Revue économique, 67*(3), 615-637.

Goldsmith-Pinkham, P., Sorkin, I., & Swift, H. (2020). Bartik instruments: What, when, why, and how. *American Economic Review, 110*(8), 2586-2624.

Goodman-Bacon, A. (2021). Difference-in-differences with variation in treatment timing. *Journal of Econometrics, 225*(2), 254-277.

Günnewig-Mönert, M. (2025). *Social housing and the dynamics of gentrification* [Working paper]. University of Cologne.

Hansen, B. E. (1996). Inference when a nuisance parameter is not identified under the null hypothesis. *Econometrica, 64*(2), 413-430.

Hansen, B. E. (1999). Threshold effects in non-dynamic panels: Estimation, testing, and inference. *Journal of Econometrics, 93*(2), 345-368.

Hansen, B. E. (2000). Sample splitting and threshold estimation. *Econometrica, 68*(3), 575-603.

Hilber, C. A. L., & Vermeulen, W. (2016). The impact of supply constraints on house prices in England. *Economic Journal, 126*(591), 358-405.

Jones, C., & Murie, A. (2006). *The Right to Buy: Analysis and evaluation of a housing policy*. Blackwell.

Kemeny, J. (1995). *From public housing to the social market: Rental policy strategies in comparative perspective*. Routledge.

Kemeny, J., Kersloot, J., & Thalmann, P. (2005). Non-profit housing influencing, leading and dominating the unitary rental market: Three case studies. *Housing Studies, 20*(6), 855-872.

Klien, M., Huber, P., Reschenhofer, P., Gutheil-Knopp-Kirchwald, G., & Kössl, G. (2023). *The price dampening effect of non-profit housing*. Austrian Institute of Economic Research (WIFO).

Li, X. (2022). Do new housing units in your backyard raise your rents? *Journal of Economic Geography, 22*(6), 1309-1352.

Malpezzi, S., & Vandell, K. (2002). Does the low-income housing tax credit increase the supply of housing? *Journal of Housing Economics, 11*(4), 360-380.

Mundlak, Y. (1978). On the pooling of time series and cross section data. *Econometrica, 46*(1), 69-85.

Murray, M. P. (1999). Subsidized and unsubsidized housing stocks 1935 to 1987: Crowding out and cointegration. *Journal of Real Estate Finance and Economics, 18*(1), 107-124.

Rambachan, A., & Roth, J. (2023). A more credible approach to parallel trends. *Review of Economic Studies, 90*(5), 2555-2591.

Roth, J. (2022). Pretest with caution: Event-study estimates after testing for parallel trends. *American Economic Review: Insights, 4*(3), 305-322.

Seo, M. H., & Linton, O. (2007). A smoothed least squares estimator for threshold regression models. *Journal of Econometrics, 141*(2), 704-735.

Sinai, T., & Waldfogel, J. (2005). Do low-income housing subsidies increase the occupied housing stock? *Journal of Public Economics, 89*(11-12), 2137-2164.

Sprigings, N., & Smith, D. H. (2012). Unintended consequences: Local housing allowance meets the right to buy. *People, Place and Policy Online, 6*(2), 58-75.

Stephens, M. (2020). How housing systems are changing and why: A critique of Kemeny's theory of housing regimes. *Housing, Theory and Society, 37*(5), 521-547.

Sun, L., & Abraham, S. (2021). Estimating dynamic treatment effects in event studies with heterogeneous treatment effects. *Journal of Econometrics, 225*(2), 175-199.

Wood, S. N. (2017). *Generalized additive models: An introduction with R* (2nd ed.). CRC Press.

# Appendix A. Data Sources and Cleaning

This appendix documents how each variable was constructed and why. Every step is implemented in `code/02_clean.py` and `code/02b_spatial_and_descriptives.py`. The automatically generated log is reproduced in A.3.

## A.1 Sources

**Table A1. Data sources**

| Variable | Source | Geography / period | Access |
|---|---|---|---|
| Private rent index and levels (all, by bedrooms, by property type) | ONS, Price Index of Private Rents (PIPR), 16 Sept 2026 release | 294 English LADs (2023), monthly Jan 2015-Aug 2026 | ons.gov.uk, open |
| Segment median rents of new lettings | VOA / ONS, Private Rental Market Statistics, 10 annual releases | LADs, 12 months to Sept 2014-2023 | gov.uk / ons.gov.uk, open |
| Dwelling stock by tenure (LA, PRP, other public, private) | MHCLG Live Table 100 | LADs, 31 March 2010-2025 | gov.uk, open |
| Affordable housing completions by tenure, new build/acquisition | MHCLG Affordable Housing Supply open data | LADs, FY1991/92-2024/25 | gov.uk, open |
| Right to Buy sales | MHCLG Right to Buy sales open data | LADs, FY2006/07-2025/26 | gov.uk, open |
| Net additional dwellings | MHCLG Live Table 122 | LADs, FY2001/02-2024/25 | gov.uk, open |
| Private-enterprise completions | MHCLG Live Table 253 | LADs, FY1980/81-2025/26 | gov.uk, open |
| Completions by bedrooms and tenure | MHCLG Live Table 254 | England | gov.uk, open |
| Vacant dwellings | MHCLG Live Table 615 | LADs, Oct 2004-2025 | gov.uk, open |
| Households on housing registers | MHCLG Live Table 600 | LADs, 1987-2025 | gov.uk, open |
| Planning decisions (major dwellings granted/refused) | MHCLG PS2 open data | Planning authorities, 1979Q2-2026Q2 | gov.uk, open |
| Previous housing situation of new social tenants | MHCLG CORE summary tables 2024/25 (Table 3gi) | England, FY2004/05-2024/25 | gov.uk, open |
| Population | ONS mid-year estimates via Nomis (NM_2002_1) | LADs, 2010-2024 | nomisweb.co.uk, open |
| Earnings | ONS ASHE resident analysis via Nomis (NM_30_1) | LADs, 2010-2025 | nomisweb.co.uk, open |
| Unemployment rate | ONS APS model-based via Nomis (NM_127_1) | LADs, 2010-2025 | nomisweb.co.uk, open |
| Tenure of households | Census 2011 KS402EW; Census 2021 TS054 (LAD and LSOA) via Nomis | LADs, LSOAs | nomisweb.co.uk, open |
| House prices | HM Land Registry UK HPI | LADs, monthly | landregistry.gov.uk, open |
| Boundaries | ONS Open Geography, LAD Dec 2023 BUC | LADs | geoportal.statistics.gov.uk, open |


## A.2 Cleaning decisions and rationale

1. **Geography.** All series are harmonised to April-2023 LAD boundaries, the PIPR geography. Because every 2010-2023 reorganisation merged whole districts, counts (stock, completions, sales, population, vacancies, planning decisions) are summed exactly across predecessors. Two re-codings without boundary change (2013; Barnsley and Sheffield 2023) are relabelled. City of London and the Isles of Scilly are dropped because PIPR does not cover them and their housing markets are atypical.
2. **Rent outcome.** Monthly PIPR indices are averaged within calendar years before taking log differences. This avoids treating month-specific noise as annual change and aligns rents with annual stock and flow data. 2026 is dropped as a partial year. PIPR segment indices are retained only to demonstrate their lack of independent within-LA variation.
3. **Stock share.** The share uses combined LA and housing-association stock, so that stock transfers do not generate spurious changes. Two transient spikes in combined stock were repaired by the mean of adjacent years (South Lakeland 2012; East Dorset 2011). The rule replaces a value deviating more than 15 percent and more than 500 units from the mean of adjacent years that reverses the following year, applied iteratively to the largest deviation first. Isolated reporting errors would otherwise create large one-year changes in a variable whose genuine within-LA variation is small.
4. **Timing.** The share is lagged to 31 March of *t*−1. Flows are assigned to the financial year ending in March of *t*, and controls are lagged one year. This ordering makes stock and controls predetermined relative to calendar-year rents and avoids the mechanical loss of 2025 caused by unpublished 2025 population and earnings estimates.
5. **Flows.** Only completions are used (not starts). Ownership products are excluded from social rental supply because they do not compete with private renting. Records without a current LA code (0.15 percent of unit records) are dropped. Flows are normalised by lagged total stock.
6. **Missing controls.** Nomis does not publish some years for new unitary authorities on the 2023 geography. These are back-filled from predecessors: population summed exactly, and earnings medians and unemployment rates as population-weighted means of predecessors (an approximation). 78 LA-years of earnings and 110 of unemployment were filled this way. Residual suppressed ASHE values are linearly interpolated within LA and flagged.
7. **PRMS segment rents.** Suppressed medians (cells with few lettings) are treated as missing. Merged LAs use lettings-weighted means of predecessor medians. Log changes larger than 40 percent in absolute value, arising from very small cells, are excluded, and regressions are weighted by the number of lettings.
8. **Moderators.** All moderators are measured before or independently of the outcome window, so they cannot be mediators of the 2016-2025 rent effects: Census 2011 tenure, 1979-2013 planning decisions, the 2014 vacancy rate, the 2021 LSOA dissimilarity index, and the Affordable Rent share of new lets. The planning refusal rate uses ONS-coded planning authorities only and excludes national park authorities and development corporations.
9. **Event definition.** A "large completion pulse" is the first financial year with at least 3 social/affordable rental completions per 1,000 dwellings (top 6 percent of LA-years). LAs first treated in 2012-2016 have no clean pre-period in the rent data and are excluded from the event study.

## A.3 Automatically generated cleaning log


#### 1. Private rents: ONS Price Index of Private Rents (PIPR)
- PIPR monthly LA series: 294 English LADs, 2015-01 to 2026-08.
- Dropped 2026 (partial year, Jan-Aug only). Annual values are the mean of 12 monthly index values.
- Outcome dlnrent = 100 x [ln(mean index_t) - ln(mean index_{t-1})], i.e. annual private rent growth in percent; also computed separately for 1/2/3/4+ bedroom and detached/semi/terraced/flat segments.
- Share of LA-years with missing segment index: {'idx_all': 0.0, 'idx_b1': 0.0, 'idx_b2': 0.0, 'idx_b3': 0.0, 'idx_b4': 0.0, 'idx_det': 0.0, 'idx_semi': 0.0, 'idx_terr': 0.0, 'idx_flat': 0.0}

#### 2. Social housing stock share: MHCLG Live Table 100
- 2009 sheet uses pre-2009 district codes and is not used; sample of stock years is 31 March 2010-2025.
- Missing component values (set to 0 only where Table 100 reports [x] for LA stock in stock-transfer authorities): 0 cells.
- Transient spikes in combined social stock repaired (deviation >15% and >500 units from the mean of the adjacent years, reversing the following year; replaced by that mean): 2
    - E07000031 2012: LA 0 + PRP 1234 = 1234 -> 4419
    - E07000049 2011: LA 0 + PRP 3807 = 3807 -> 3262
- Large-scale voluntary transfers of council stock to housing associations move units from the LA to the PRP column; because the share is computed on combined social stock these transfers do not create artificial changes in SH share.
- Codes harmonised to April-2023 LADs by summing predecessor districts (all 2010-2023 reorganisations were whole-district mergers; 2013 and 2023 re-codings with no boundary change were relabelled).
- SH share = (local authority + private registered provider stock) / total dwelling stock x 100. 'Other public sector' stock (mainly MoD) is excluded from the numerator. PRP stock includes general-needs, supported and low-cost home-ownership units owned by registered providers; see Appendix for this caveat.

#### 3. Flows: affordable housing completions and Right to Buy sales
- AHS open data, completions only. Share of unit records without a current LA code (dropped): 0.0015.
- Rental affordable completions split into: social rent & London Affordable Rent new build (sr_nb); Affordable Rent (<=80% market) new build (ar_nb); intermediate rent new build (ir_nb); all rental acquisitions (rent_aq: purchases of existing dwellings). Ownership products (shared ownership, First Homes, etc.) are kept separately (own) and are not counted as social rental supply.
- Right to Buy: council (LA-landlord) RTB sales from the RTB open data (2006-07 onward; 'Unknown' sale type before 2012-13 is RTB by construction). LAs without retained council stock have no RTB sales (set to 0). Preserved RTB / Right to Acquire sales by housing associations are not in this file.

#### 4. Controls
- Population: ONS mid-year estimates (Nomis NM_2002_1, re-based by Nomis to 2023 LADs). Earnings: ASHE resident-based median gross annual pay of full-time workers (NM_30_1). Unemployment: APS model-based unemployment rate, Jan-Dec (NM_127_1).
- Nomis does not publish some years on the 2023 geography for the 2019-23 unitaries and for re-coded Barnsley/Sheffield. These were back-filled from 2019-geography predecessors: population summed exactly (30 LA-years); median pay (78) and unemployment rates (110) as population-weighted means of predecessor values (an approximation, since medians and model-based rates do not aggregate exactly).
- ASHE pay suppressed/missing LA-years 2014-2025: 137; filled by linear interpolation within LA (and carried at the ends) so that sample composition is stable; an indicator flags imputed values.
- Net additional dwellings (Live Table 122), financial year ending March t assigned to year t.
- Vacant dwellings (Live Table 615, council-tax base, October snapshot).
- Private-enterprise housing completions (Live Table 253), financial year ending March t -> year t.
- House prices: HM Land Registry UK HPI average price, annual mean (alternative outcome).

#### 5. Baseline moderators
- Private-rented share of households, Census 2011 (KS402EW), aggregated to 2023 LADs.
- Social-rented share of households, Census 2021 (TS054): used to validate the Table 100 stock share and as an alternative (time-invariant) regime variable in the threshold models.
- Supply restrictiveness: share of major residential (10+ dwellings) planning applications refused, all quarters 1979Q2-2013Q4 (pre-sample, following Hilber & Vermeulen 2016). Only ONS-coded (E-) planning authorities are used; national park authorities and development corporations are excluded. For 2009 unitary authorities the window therefore starts in 2009.
- LSOAs not matched to a district by name: 0 of 33755.
- Concentration: Duncan dissimilarity index (0-100) between social-renting and other households across 2021 LSOAs within each LAD (Census 2021 TS054). Higher = social housing more spatially concentrated.
- Price proximity: Affordable Rent (set at up to 80% of local market rent, introduced 2011) as % of new-build social/affordable rent completions 2012/13-2024/25. A higher share means new sub-market rentals are closer substitutes for private lettings.
- Housing waiting lists (Live Table 600), households on LA registers at 1 April (mechanism outcome).

#### 6. Panel assembly
- Shift-share instrument: pre-period (FY2010/11-2013/14) LA share of national social/affordable-rent new build x leave-one-out national completions in t, per 1,000 lagged dwellings.
- Event: first FY with >=3 social/affordable-rent new-build completions per 1,000 dwellings, 2012-2025. LAs ever treated: 146; first-treated before 2017 (no clean pre-period in the rent data, excluded from the event study): 75; treated 2017-2025: 71; never treated: 148.
- Validation (2021): correlation of Table 100 SH share with Census 2021 social-rented household share = 0.989; mean difference -0.31 pp (dwellings vs households and differences in how housing-association stock is attributed to LAs). Largest negative gaps: Westminster, Medway, Kensington and Chelsea, Newham (-7.3, -6.5, -5.3, -4.2 pp). Threshold models are re-estimated with the Census measure as regime variable (Appendix Table C1).
- Full panel: 294 LADs x 16 years (2010-2025) = 4704 rows.
- Estimation window 2016-2025: 2940 LA-years. Missing in key variables: {'dlnrent_all': 0, 'sh_share_l1': 0, 'dlnpop_l1': 0, 'dlnpay_l1': 0, 'unemp_l1': 0, 'netadd_pk_l1': 0}
- Analysis sample after dropping missing key variables: 2940 LA-years, 294 LADs.

#### 8. Private Rental Market Statistics (VOA/ONS), competition test
- 10 annual releases (12 months to September 2014 ... 2023), LA x bedroom medians and counts; 296 LADs. Cells with suppressed medians ('..', fewer than ~10 lettings) are missing. Merged LADs use count-weighted means of predecessor medians. Growth = 100 x diff ln(median). These are direct (unmodelled) estimates of new lettings, noisier than PIPR but segment-specific.

#### 7. CORE lettings (national)
- Previous housing situation of lead tenants of new social lettings, % of lettings, by letting type, 2004/05-2024/25 (Table 3gi). LA-level CORE microdata are not openly published (UK Data Service), so the displacement channel is examined with national shares plus LA-level waiting-list responses.
- Bedroom/property-type mix of completions by tenure, England, mean of FY2015/16-2024/25 (Live Table 254b).


# Appendix B. Threshold Estimation Algorithm

For each candidate threshold τ on a grid of quantiles of the lagged share (10th to 90th percentile in steps of 1.25 percentiles), the regime-specific regressors $x_{it}\mathbb{1}(q_{it}\le\tau)$ and $x_{it}\mathbb{1}(q_{it}>\tau)$ are constructed. These and all controls are demeaned with respect to LA and region-by-year fixed effects (alternating projections, `fixest::demean`), and the sum of squared residuals $S_1(\tau)$ is computed. The estimate $\hat\tau$ minimises $S_1(\tau)$. The test statistic is $F_1 = (S_0 - S_1(\hat\tau))/\hat\sigma^2$, where $S_0$ is the linear model's SSR. Its null distribution is obtained by a wild cluster bootstrap. Null-model residuals are multiplied by LA-level Rademacher weights, the bootstrap outcome is re-demeaned, and both models are re-estimated over the full grid (499 replications). The 95 percent confidence set is $\{\tau: LR(\tau) \le 7.35\}$ with $LR(\tau) = (S_1(\tau)-S_1(\hat\tau))/\hat\sigma^2$. The second threshold is searched conditional on $\hat\tau_1$ with 10 percent minimum regime size, and tested against the single-threshold model by the analogous bootstrap. The index-threshold model replaces $q_{it}$ by $q_{it} + \theta Z_i$ and searches jointly over θ ∈ [−6, 6] and τ, with an LA-cluster pairs bootstrap for inference. Code: `code/threshold_functions.R` and `code/05_rq34_heterogeneity.R`.
