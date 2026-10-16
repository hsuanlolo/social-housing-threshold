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

{{TABLE:table1}}

{{FIG:fig1_maps.png|Figure 1. Social housing shares (2025) and average annual private rent growth (2015-2025), English local authorities.}}

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

{{TABLE:table2}}

The event study offers a cautionary note (Figure 2; Table 2b). Private rents in LAs that experience a large completion pulse decline relative to never-treated LAs after the pulse, and the average post-treatment effect is −1.2 log points (p = 0.01) with region-by-year effects. However, the decline began well before the pulse. Pre-period coefficients fall steadily from positive values, and joint tests reject zero pre-trends (F = 4.0, p < 0.001). A test for a change in slope at the event finds none (change in slope −0.03, SE 0.06). Allowing LA-specific linear trends shrinks the effect to −0.37 (p = 0.14). We read this as evidence that large social completion programmes are located where rents were already growing relatively slowly — areas with cheaper land, where s106 and grant-funded schemes are more viable. It is not evidence of a discrete break. The event study therefore does not provide stronger causal evidence than the panel, and the flow estimates should be interpreted as conditional associations robust to LA fixed effects, regional cycles and a placebo lead (Roth, 2022; Rambachan & Roth, 2023).

{{TABLE:table2b_event}}

{{FIG:fig2_event_study.png|Figure 2. Event study: private rents around the first large social/affordable rental completion pulse (Sun-Abraham estimator, 95% CIs).}}

## 5.2 RQ2: nonlinearity and thresholds

Figure 3 shows the curves. The pooled GAM (panel a) uses a smooth with about two effective degrees of freedom that is not significantly different from a constant (p = 0.12). The within-LA spline terms are jointly insignificant (p = 0.52). The long-difference GAM (panel b) collapses to a straight line (1.04 effective degrees of freedom) with a weakly positive slope. Neither specification hints at a kink. The varying-coefficient GAM (panels c and d) shows that the marginal effect of new build is negative across the whole support, drifting from about −0.06 at a 7 percent share to −0.10 at 35 percent, with overlapping confidence bands. The marginal effect of RTB losses declines from about 0.15 at low shares to 0.06 at high shares.

{{FIG:fig3_nonlinear_curves.png|Figure 3. Nonlinear relationships: (a) pooled GAM smooth of rent growth on the lagged social share; (b) long-difference GAM; (c)-(d) marginal effects of two-year new build and RTB sales as smooth functions of the share. Dashed lines mark the (statistically insignificant) Hansen threshold estimates.}}

The formal threshold tests in Table 3 confirm the visual impression. For no model can we reject the null of no threshold. Bootstrap p-values are 0.47 for the level model, 0.39 for the joint flow model, 0.17 for new build alone, 0.29 for RTB alone and 0.45 for the cross-sectional long-difference model. Likelihood-ratio confidence sets for the threshold location span most of the support (e.g., 9.6 to 24.3 percent for the level model; Figure 4). Under the sequential procedure, the data select a linear model. Re-estimating the flow-threshold models with the Census 2021 social-rented share of households as the regime variable — which guards against measurement error in the administrative stock share, the two measures correlating at 0.99 — gives the same conclusion (bootstrap p = 0.61 for new build and 0.25 for RTB; Table 3).

{{TABLE:table3}}

Conditional on a first split at 14.2 percent, a second threshold for new build at 22.1 percent is significant (p = 0.03). The regime coefficients in Table 3b are instructive. New build is associated with slower rent growth below 14.2 percent (−0.12, p < 0.01) and above 22.1 percent (−0.14, p < 0.10), but not between. RTB losses raise rent growth strongly below 16.1 percent (0.73, p < 0.01) and only weakly above. This pattern is the opposite of a critical-mass threshold, under which effects should be absent at low shares and emerge at high shares. The most robust feature is that marginal changes in social supply matter at least as much where social housing is scarce as where it is plentiful. That is what a supply-and-substitution account predicts when the marginal social unit is most valuable to the rental market where few close substitutes exist. Because the single-threshold test is not rejected, we treat the regime estimates as descriptive.

{{TABLE:table3b}}

{{FIG:fig4_lr_profiles.png|Figure 4. Likelihood-ratio profiles for the threshold location. Values below the dashed line (7.35) form the 95% confidence set.}}

Separating statistical from policy thresholds sharpens the point. Even without a statistical threshold, one can ask what share of new supply is needed for a policy-relevant effect — say, one percentage point lower annual rent growth. With a two-year coefficient of −0.071, that requires sustained completions of about 7 per 1,000 dwellings per year. This is above the 99th percentile of observed LA-years and more than six times the median. The binding constraint on the rent dividend of social housing in England is the volume of new supply, not the stock share that must be reached before effects appear.

## 5.3 RQ3: are there place-specific thresholds?

{{RQ3_TEXT}}

{{TABLE:table4a}}

{{TABLE:table4b}}

## 5.4 RQ4: which institutions explain heterogeneity?

{{RQ4_TEXT}}

{{TABLE:table4c}}

{{FIG:fig5_heterogeneity.png|Figure 5. Linear rent effects of new build and RTB sales in subsamples split at the median of each moderator.}}

## 5.5 RQ5: mechanisms

**Additional supply versus tenure conversion.** If social housing worked only by adding units, acquisitions — which add no dwellings — should have no effect, and new build should matter. In Table 5a, column 1, the point estimate for acquisitions (−0.13, SE 0.09) is at least as large as for new build (−0.07, SE 0.03). The difference is not significant (0.06, SE 0.10, p = 0.56). RTB sales, which move dwellings out of social tenure without changing the total stock, are associated with faster rent growth (0.20, SE 0.13; larger and significant in the contemporaneous specification of Table 2). We cannot reject that a lost social unit raises rents by as much as a new one lowers them (sum 0.13, SE 0.12). Tenure conversion therefore appears to matter in its own right. A dwelling let at a sub-market rent to a household who would otherwise rent privately affects private rents even when total supply is unchanged. This pattern is consistent with competition and displacement channels operating alongside, not instead of, net supply. Acquisitions are rare (median 0.02 per 1,000 dwellings) and imprecisely estimated, so this conclusion is tentative.

**Crowd-out.** Social/affordable new build does not crowd out private construction. Each social completion per 1,000 dwellings coincides with 1.13 additional net dwellings (column 5) and 0.45 additional private-enterprise completions (column 4). A large share of affordable housing in England is delivered through Section 106 agreements on mixed-tenure private schemes, so social and private completions are partly co-produced rather than substitutes; the positive association should not be read as causal crowd-in. Net-supply additionality is therefore close to one-for-one, in contrast to the high crowd-out found for some US programmes (Murray, 1999; Eriksen & Rosenthal, 2010).

**Competition.** New social and affordable rental homes are concentrated in small dwellings: 67 percent are one- or two-bedroom homes, against 25 percent of private completions, and only 4 percent have four or more bedrooms (against 37 percent). If competition drives the rent effect, it should concentrate in the one- and two-bedroom segments. Table 5b and Figure 6 show exactly this gradient in the direct PRMS rents. A two-year completion per 1,000 dwellings is associated with 0.15 points slower growth of median one-bedroom rents (p = 0.04) and two-bedroom rents (p = 0.01), 0.07 points for three bedrooms (p = 0.30) and essentially zero for four or more bedrooms (−0.02, SE 0.14). The difference between small and large segments is imprecise (p = 0.34) because four-bedroom medians are noisy, but the monotone pattern matches the bedroom composition of new supply. The PIPR segment indices show no gradient at all (all coefficients −0.07), which is the expected signature of model-based indices that share LA-level dynamics. The Social Rent versus Affordable Rent comparison is inconclusive. Affordable Rent, priced closer to the market, has a precisely estimated effect (−0.064, p < 0.05). Social Rent has a similar but noisier point estimate (−0.091, SE 0.057), and the two do not differ significantly.

**Displacement.** New completions reduce housing waiting lists: one completion per 1,000 dwellings lowers the number of households on the register by about 1.1 percent in the same year (column 3). This is consistent with new lettings drawing households out of the queue, many of whom are housed in the private rented sector or in temporary accommodation while waiting. National CORE data show that 14-20 percent of new general-needs social lettings go to households previously renting privately, and up to 28 percent for some Affordable Rent lettings (Figure 7). Applied to the volume of new lettings, this proportion implies a non-trivial reduction in private rental demand. LA-level CORE microdata, which would allow a direct test, are not openly published.

Taken together, the mechanism evidence fits a picture of incremental effects working through net supply, direct competition in the small-dwelling segments, and displacement of private-rental demand. It does not fit a market-share tipping point.

{{TABLE:table5a}}

{{TABLE:table5b}}

{{FIG:fig6_segments.png|Figure 6. Competition test: rent effects by bedroom count using direct PRMS medians and model-based PIPR indices.}}

{{FIG:fig7_core_prs.png|Figure 7. Share of new general-needs social lettings to households previously renting privately (CORE), by tenure and landlord type.}}

# 6. Robustness and Extensions

Table 6 and Figure 8 show that the new-build estimate is stable across specifications:

- excluding London: −0.054, p = 0.06;
- excluding the pandemic years 2020-2021: −0.077, p = 0.02;
- weighting by population: −0.105, p < 0.01;
- adding LA-specific linear trends: −0.063, p = 0.08;
- two-way clustering by LA and region-year: SE 0.033;
- controlling for neighbouring LAs' flows: −0.072, p = 0.02.

The spatial model shows no rent spillover from neighbours' new build (−0.02, SE 0.05), suggesting the effects are local to LA housing markets. With year rather than region-by-year fixed effects, the new-build coefficient falls to −0.04 and the RTB coefficient rises to 0.43 (p < 0.01). Measuring rents with PIPR rent levels instead of the index gives identical estimates. With the noisier PRMS all-property medians the new-build estimate is negative but imprecise (−0.04, SE 0.07). The stock-share coefficient is sensitive to specification: −0.44 with year effects, −0.15 with region-by-year effects, −0.08 with a two-year lag and −0.25 excluding London. This reinforces our conclusion that the stock share cannot be cleanly separated from regional and place-specific trends.

{{TABLE:table6}}

{{FIG:fig8_robustness.png|Figure 8. Robustness of the flow coefficients across specifications (95% CIs).}}

**Price stabilisation.** The original motivation of the threshold debate includes the claim that a large non-market sector stabilises housing markets. Table 6b relates the volatility of monthly year-on-year growth rates over 2016-2025 to the 2014 share in the LA cross-section. Higher social shares are associated with slightly *higher* private rent volatility (0.020 SD points per point of share, p = 0.05) and *lower* house-price volatility (−0.029, p < 0.01). Quadratic terms are insignificant in both cases. The house-price result is consistent with a smaller owner-occupied segment exposed to credit-driven swings, but with region fixed effects alone these cross-sectional associations are descriptive.

{{TABLE:table6b}}

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

{{TABLE_SOURCES}}

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

{{CLEANING_LOG}}

# Appendix B. Threshold Estimation Algorithm

For each candidate threshold τ on a grid of quantiles of the lagged share (10th to 90th percentile in steps of 1.25 percentiles), the regime-specific regressors $x_{it}\mathbb{1}(q_{it}\le\tau)$ and $x_{it}\mathbb{1}(q_{it}>\tau)$ are constructed. These and all controls are demeaned with respect to LA and region-by-year fixed effects (alternating projections, `fixest::demean`), and the sum of squared residuals $S_1(\tau)$ is computed. The estimate $\hat\tau$ minimises $S_1(\tau)$. The test statistic is $F_1 = (S_0 - S_1(\hat\tau))/\hat\sigma^2$, where $S_0$ is the linear model's SSR. Its null distribution is obtained by a wild cluster bootstrap. Null-model residuals are multiplied by LA-level Rademacher weights, the bootstrap outcome is re-demeaned, and both models are re-estimated over the full grid (499 replications). The 95 percent confidence set is $\{\tau: LR(\tau) \le 7.35\}$ with $LR(\tau) = (S_1(\tau)-S_1(\hat\tau))/\hat\sigma^2$. The second threshold is searched conditional on $\hat\tau_1$ with 10 percent minimum regime size, and tested against the single-threshold model by the analogous bootstrap. The index-threshold model replaces $q_{it}$ by $q_{it} + \theta Z_i$ and searches jointly over θ ∈ [−6, 6] and τ, with an LA-cluster pairs bootstrap for inference. Code: `code/threshold_functions.R` and `code/05_rq34_heterogeneity.R`.
