---
title: "Is There a Social Housing Threshold? Social Housing Market Share and Private Rents across English Local Authorities"
author: "Hsuan Lo"
date: "Draft v3, October 2026. Not for circulation."
---

# Abstract

A long-standing argument in comparative housing research holds that social housing restrains private rents only after it reaches a critical share of the housing stock. This paper tests whether such a threshold exists, using a panel of all 294 English local authorities (LAs) in which social housing shares range from 5 to 43 percent. Rent levels are observed from 2015 to 2025 and rent growth from 2016 to 2025. We combine interval models, spline derivatives, and threshold and kink regressions with wild cluster bootstrap inference.

We find no share beyond which private rents begin to fall. Across LAs, a higher social housing share is associated with higher private rent levels, and the relationship is close to linear, at about 1.1 percent per percentage point of share. Rents in LAs where social housing exceeds 20 percent of the stock are 10 to 22 percent above those in LAs at 10 to 15 percent. Rent growth rises slightly with the share up to about 15 percent and is unrelated to it thereafter, although this flattening is significant only in some specifications. Within LAs, increases in social housing coincide with lower rents, and additions to the social rental stock are associated with slower rent growth at every level of the share.

Three features of the data account for the absence of a dampening threshold in the cross-section. Social housing is concentrated in dense, high-demand and supply-constrained cities, and the positive association is strongest in London and in tight, high-earning and planning-restrictive markets. The share also changes very little within LAs over time, and few LAs have very high shares. In England's rationed rental system, the rent dividend of social housing appears to be incremental rather than contingent on reaching a critical market share.

**Keywords:** social housing; private rents; threshold regression; rental market; England

# 1. Introduction

Social housing has returned to the policy agenda in many high-cost housing markets, and with it a recurring claim that a large non-market rental sector restrains private rents throughout the market rather than only for its own tenants. In its stronger form, the claim holds that this restraint appears only once the sector reaches a critical size. Below that size social housing functions as a residual safety net that private landlords can safely ignore, whereas above it social landlords effectively set the terms on which private landlords compete (Kemeny, 1995; Kemeny et al., 2005). Vienna, where municipal and limited-profit housing together account for more than 40 percent of dwellings, is usually cited as the paradigmatic case. Austrian evidence that limited-profit housing dampens private rents, and that the rent gap between the two sectors narrows nonlinearly as the limited-profit share rises (Banabak, 2023; Klien et al., 2023), is often read as support for this view.

Whether such a threshold exists has direct implications for policy design. If social housing restrains private rents only above a certain share, scarce subsidy would be best concentrated in places close to that share, and incremental programmes elsewhere would have little effect on market rents. If there is no threshold, the market-wide consequences of social housing should scale with the amount provided, wherever it is built. Despite its prominence in policy debate, the threshold claim has rarely been tested directly. Existing studies examine single cities or single countries within one institutional regime, and they do not ask where, or whether, the relationship between social housing and private rents changes slope.

This paper addresses three related questions. The first concerns how the social housing share is associated with private rent levels and private rent growth. The second asks whether there is a threshold, or an interval of the share, beyond which this association changes, in which interval the association is strongest, and whether it reverses at high shares. The third asks why a threshold is or is not found, and which variables shape the relationship between the social housing share and private rents.

England offers a useful setting for these questions. Social housing shares across its 294 LAs range from about 5 percent in Castle Point to almost 40 percent in Islington, Southwark and Hackney, and reached 43 percent earlier in the decade. This covers nearly the entire range over which thresholds have been conjectured. All LAs also operate within a single national framework. Private rents are unregulated, and allocation rules, the welfare system and the funding regime for social housing are common across the country, so the institutional differences that complicate cross-national comparisons are held constant. In addition, the Office for National Statistics (ONS) has published since 2024 a consistent administrative index of private rents for every LA from 2015 onward.

We do not attempt to identify causal effects. Social housing in England was built over more than a century in response to local housing conditions, the share barely changes within LAs over the period we observe, and LAs with large recent completion programmes were already on different rent trajectories before those programmes began. As Section 4 and Appendix D show, the parallel-trends assumption required by an event-study design does not hold, and an instrument for new social supply is too weak to be informative. Instead, we characterise the relationship between the social housing share and private rents as carefully as the data allow, examining its shape, whether and where it bends, and which observable variables account for it. Terms such as association and effect should therefore be read as conditional associations throughout.

Four main findings emerge. First, there is no share beyond which private rents fall. Interval models, spline derivatives, threshold and kink regressions with bootstrap inference, and formal linearity tests all fail to identify a share at which the relationship with rent levels changes. For rent growth, the most consistent pattern is a flattening at around 15 percent, below which growth rises slightly with the share and above which it is unrelated to it, but this pattern is statistically fragile. Second, the cross-sectional relationship runs in the opposite direction to the dampening hypothesis. Places with more social housing have higher private rents, roughly in proportion to the share, and the difference from the modal interval of 10 to 15 percent becomes statistically clear from about 20 percent upward. Third, this pattern does not imply that social housing raises rents. Within LAs, increases in the share coincide with lower rents, and new social supply is associated with slower rent growth in every interval of the share. The cross-sectional association instead reflects where social housing is located, and it is strongest in dense, high-demand and supply-constrained markets. Fourth, statistical power is limited at very high shares, where only 13 LAs, most of them in inner London, are observed. A threshold above 30 percent cannot be ruled out, but none is visible in the range where most LAs, and most policy decisions, are located.

The paper makes three contributions. It provides a direct test of the social housing threshold hypothesis across a wide range of shares within a single institutional regime. It distinguishes the cross-sectional relationship, which reflects where social housing is located, from the within-place relationship, which reflects what happens when social housing changes, and shows that the two point in opposite directions. It also identifies the variables that drive the cross-sectional pattern, namely density, local demand, deprivation and supply constraints, which helps explain why cross-city comparisons of social housing shares and rents can be misleading.

# 2. Literature Review

Research relevant to the threshold question is spread across several literatures that rarely speak to one another. Comparative housing studies have theorised how the structure of rental markets shapes rents. Urban and public economics have estimated how subsidised housing affects total housing supply and nearby property values. A smaller body of work has examined the relationship between the market share of non-profit housing and private rents directly, mostly in Austria. This section reviews these literatures in turn and draws out the competing predictions that guide the empirical analysis.

## 2.1 Rental market regimes and the idea of a threshold

The idea that social housing affects private rents only beyond a certain share originates in Kemeny's (1995) distinction between unitary and dual rental markets. In a unitary market, a non-profit sector that charges cost rents and is open to a broad population competes directly with for-profit landlords. Because cost rents fall below market rents as the non-profit stock ages and its debt is repaid, a mature non-profit sector can undercut private landlords and compel them to moderate their rents. Kemeny et al. (2005) elaborate this argument by distinguishing three stages through which the non-profit sector first influences, then leads and finally dominates rent-setting in the market as a whole, and they illustrate the stages with case studies of Switzerland, where non-profit renting weakly influences the market, Sweden, where it leads, and the Netherlands, where it dominates. The theory implies that the relationship between the social housing share and private rents is flat while the non-profit sector is small and turns negative once it reaches a critical mass. In a dual market, by contrast, governments confine social housing to households in need and keep it separate from the profit-oriented market, so that it does not compete with private renting for most tenants. Kemeny regarded the English-speaking countries, including the United Kingdom, as the archetypal dual systems.

Later work has qualified this typology without abandoning it. Haffner et al. (2009) compare social and market rented housing in six European countries and argue that the boundary between the two sectors has become blurred, so that the distinction between unitary and dual markets is better understood as a continuum than as a dichotomy. Stephens (2020) argues that the theory underplays the role of welfare states, housing finance and the residualisation of social housing, and that changes in these institutions have moved several formerly unitary systems towards dual characteristics. Comparative descriptions show that social housing shares vary widely across advanced economies, from more than 20 percent of the stock in Austria, Denmark and the Netherlands to around 7 percent on average across OECD countries and much less in many others (OECD, 2020). Definitions of social and affordable housing also differ considerably between countries (Czischke & van Bortel, 2023), which complicates cross-national comparisons of shares and rents and is one reason why a within-country design is attractive.

## 2.2 Social housing as additional supply

A second literature treats social housing as an addition to the housing stock and asks whether it raises total supply or merely displaces private construction. If social housing adds to total supply, standard models predict that it lowers market rents in proportion to the number of units added, with no threshold. The evidence on crowd-out comes mostly from the United States and is mixed. Murray (1999) finds that conventional public housing added steadily to the total housing stock after 1935, whereas subsidised programmes for moderate-income households added little or nothing to it. Malpezzi and Vandell (2002) find little evidence that units financed through the Low-Income Housing Tax Credit (LIHTC) increased the total housing stock across states. Sinai and Waldfogel (2005) estimate at the level of places that roughly one additional unit is added to the occupied stock for every three units of government-subsidised housing, implying substantial but incomplete crowd-out. Eriksen and Rosenthal (2010) find that crowd-out of private rental construction by LIHTC developments is close to complete in many markets.

Whether additional supply lowers rents locally has been examined mostly for market-rate housing. Asquith et al. (2023) show that large new apartment buildings in low-income neighbourhoods of US cities reduce nearby rents by 5 to 7 percent, and Li (2022) finds that new high-rise buildings in New York City lower nearby rents and sales prices. These studies suggest that new supply can moderate rents in its immediate surroundings, but they do not address whether the tenure of new supply matters or whether effects depend on the existing share of non-market housing. They also imply diminishing returns as a possibility. Additional sub-market units may matter most where non-market alternatives are scarce, in which case the association between the share and private rents would be strongest at low shares and weaken as the share rises.

## 2.3 Location, neighbourhood spillovers and property values

A third literature examines how subsidised housing affects the value of nearby property. This work is relevant to the threshold question because it shows that the location of subsidised housing is closely related to neighbourhood conditions, and that its effects on prices can be positive as well as negative. Nguyen (2005) reviews early studies and concludes that affordable housing has, at most, small negative effects on nearby property values, with the sign and size depending on design, concentration and neighbourhood context. Schwartz et al. (2006) find that subsidised housing built under New York City's ten-year housing plan raised the value of surrounding properties, with larger effects for larger developments. Baum-Snow and Marion (2009) show that the neighbourhood effects of LIHTC developments differ between declining and gentrifying areas, and Diamond and McQuade (2019) find that LIHTC developments raise nearby house prices by about 6.5 percent in low-income neighbourhoods but lower them by about 2.5 percent in higher-income, low-minority areas. In the Netherlands, Koster and van Ommeren (2019) show that a place-based policy that invested heavily in the social housing stock of deprived neighbourhoods raised local house prices.

Two lessons follow for the present study. Social housing is not located at random, and its presence is correlated with neighbourhood characteristics that themselves affect rents, so that comparisons of rents across places with different social housing shares mix the influence of social housing with that of location. Moreover, the price effects documented in this literature operate through neighbourhood quality and amenities as well as through supply, which means that a higher social housing share need not be associated with lower prices even where social housing has beneficial local effects.

## 2.4 Market-share effects in integrated rental systems

Direct evidence on the relationship between the market share of non-profit housing and private rents comes mainly from Austria, which is usually regarded as the closest contemporary approximation to a unitary rental market. Klien et al. (2023) pool five decades of Austrian microcensus data and estimate that a 10 percent higher limited-profit share lowers unregulated private rents by about €0.30 to €0.40 per square metre, or roughly 5 percent, with the rent gap between the two sectors narrowing as the limited-profit share rises. Banabak (2023) finds that Viennese subdistricts with more limited-profit housing are more likely to follow lower private rent trajectories, particularly in peripheral locations with less demand pressure, and that municipal housing shows a weaker association, which he attributes to stronger barriers to entry. Qualitative and institutional studies of Vienna caution, however, that access to the city's non-profit sector is increasingly shaped by residency requirements and the down payments charged by limited-profit associations (Friesenecker & Kazepov, 2021), and that the halt to new municipal construction in the 2000s, together with rising rents in parts of the regulated stock, points to a gradual recommodification of the Viennese system (Kadi, 2015). The conditions under which competition operates in the paradigmatic unitary case are therefore themselves changing.

Outside Austria, the closest analogue to a threshold is the French SRU law, which requires municipalities above a certain size to reach a social housing share of 20 and later 25 percent. Gobillon and Vignolles (2016) find that the law increased social housing construction in municipalities below the quota but had no detectable effect on resale prices. Chapelle et al. (2025) show that the additional public housing did little to change the income mix of affected municipalities, because most new units were allocated to households that were not poor. A policy threshold, in other words, does not by itself imply a market threshold.

## 2.5 Residualisation and the English context

England provides a sharp contrast to the Austrian case. Its social housing sector, owned by local authorities and housing associations, accounts for about 16 percent of dwellings, but it has become increasingly residualised. Allocation is based on need, and successive reforms have moved the sector towards what Fitzpatrick and Pawson (2014) describe as an "ambulance service" for households in acute housing need, including the introduction of fixed-term tenancies. The sector has also been shaped by large-scale losses through the Right to Buy, which since 1980 has transferred close to two million council dwellings to sitting tenants at substantial discounts. Disney and Luo (2017) show that the policy generated substantial gains for the tenants who bought their homes, at the cost of a smaller social stock for later generations of tenants, and many former council dwellings have since been relet in the private rented sector. These features suggest that English social housing is unlikely to discipline private rents through competition in the manner envisaged by Kemeny, and they also raise the possibility that a large but rationed social sector leaves a thinner private rental market for households who do not qualify.

## 2.6 Competing predictions

The literatures reviewed above generate three competing predictions about the shape of the relationship between the social housing share and private rents. The competition perspective predicts a threshold, with little association at low shares and a negative association once the non-profit sector reaches a critical mass, although this prediction is weaker in dual systems such as England's. The supply perspective predicts a roughly proportional negative association without a threshold, possibly with diminishing returns that make the association strongest at low shares. A third perspective, which combines the scarcity of private renting with the location of social housing in high-demand places, predicts that a higher social housing share may be associated with higher rather than lower private rents, potentially more so at high shares. Very high shares may also coincide with concentrated deprivation and weaker neighbourhood demand, which would lower rents for reasons unrelated to competition between landlords. None of the studies reviewed here tests for a threshold across a wide range of shares within one institutional setting, and none distinguishes the cross-sectional relationship between the share and rents from the relationship that holds when social housing changes within places. The empirical analysis that follows is designed to adjudicate between these predictions.

# 3. Data

## 3.1 Sample

The unit of analysis is the English LA district on April 2023 boundaries. Because all reorganisations between 2010 and 2023 merged whole districts, predecessor units aggregate exactly into current LAs. City of London and the Isles of Scilly are excluded because private rents are not published for them. The resulting sample is a balanced panel of 294 LAs, with rent levels observed from 2015 to 2025 (N = 3,234) and rent growth from 2016 to 2025 (N = 2,940). Appendix A documents each cleaning step and its rationale and reproduces the log generated by the replication code.

## 3.2 Private rents

Rents are taken from the ONS Price Index of Private Rents (PIPR), which is constructed from administrative data on new and existing tenancies, adjusted for property mix, and published monthly for every LA from January 2015. We use two outcomes. The rent level is the logarithm of the calendar-year mean of PIPR's average monthly rent, multiplied by 100 so that coefficients can be read approximately as percentage differences. Rent growth is 100 times the annual change in the logarithm of the calendar-year mean index. Observations for 2026 are dropped because only eight months are available. Average private rents were about £930 per month over the period, and rent growth averaged 3.8 percent per year, ranging from 1.7 percent in 2018 to 2020 to 7.6 percent in 2024. Annual rent expressed as a percentage of local median full-time earnings is used as an additional measure of affordability.

## 3.3 Social housing share

The social housing (SH) share is defined as the dwelling stock owned by local authorities and private registered providers (housing associations), divided by the total dwelling stock. It is taken from MHCLG Live Table 100 and measured at 31 March of the previous year, so that it predates the rent observations it is related to. Combining council and housing association stock ensures that transfers between the two sectors do not generate artificial changes in the share. Two transient reporting errors were corrected, as described in Appendix A. The administrative share correlates at 0.99 with the Census 2021 share of households renting from a social landlord, which we use as an alternative measure.

Two features of the share shape the analysis. The share varies almost entirely between LAs rather than over time, with a between-LA standard deviation of 6.0 percentage points against a within-LA standard deviation of only 0.4 over the decade. High shares are also rare. Forty-one LAs are observed with shares of 20 to 25 percent, 26 with shares of 25 to 30 percent, and only 13, most of them in inner London, with shares above 30 percent.

## 3.4 Changes in social housing

To examine how rents respond when social housing changes within an LA, we use the two main sources of change in the social stock. Additions are measured by completions of social and affordable rental homes (Social Rent, London Affordable Rent and Affordable Rent new build) from the MHCLG Affordable Housing Supply open data. Losses are measured by council Right to Buy (RTB) sales from the corresponding open data. Both are expressed per 1,000 dwellings and summed over the current and previous financial years, since the response of rents to completions builds up over roughly two years.

## 3.5 Explanatory variables

Control variables are grouped according to the mechanism they represent. Local demand is captured by median full-time earnings from the Annual Survey of Hours and Earnings, the unemployment rate from the Annual Population Survey, and population growth from the mid-year estimates. Urban structure and supply are captured by population density and net additional dwellings per 1,000 dwellings, and deprivation by the average score on the Index of Multiple Deprivation (IMD) 2019. Time-varying controls enter with a one-year lag. For the third research question we also use characteristics measured before the outcome period, namely the private-rented share of households in the 2011 Census, the 2014 vacancy rate, the refusal rate of major residential planning applications between 1979 and 2013, following Hilber and Vermeulen (2016), and the share of the social stock owned by the council. Table 1 summarises all variables, and Figure 1 maps the social housing share and rent growth.

{{TABLE:table1}}

{{FIG:fig1_maps.png|Figure 1. Social housing share (2025) and average annual private rent growth (2015-2025), English local authorities.}}

# 4. Methods

All models are estimated on a single LA-by-year panel using the specification

$$Y_{it} = f(SH_{i,t-1}) + \gamma' X_{i,t-1} + \lambda_{r(i)t} + \varepsilon_{it}$$

where $Y_{it}$ is the log rent level or rent growth, $f(\cdot)$ describes how rents vary with the lagged share, $X$ is the vector of controls, and $\lambda_{r(i)t}$ are region-by-year fixed effects that absorb national and regional cycles, including the distinctive post-pandemic dynamics of the London market. Because the share varies mainly between LAs, $f(\cdot)$ is identified mainly from comparisons across LAs within the same region and year. Standard errors are clustered by LA in all models.

For the first research question, we estimate a linear $f(\cdot)$ and add groups of controls in sequence, beginning with local demand, then urban structure, then deprivation, in order to show how the association depends on the conditioning set. A specification with LA fixed effects reports the corresponding within-LA association.

For the second research question, we describe $f(\cdot)$ in four complementary ways. An interval model replaces the linear share with indicators for intervals of below 10, 10 to 15, 15 to 20, 20 to 25, 25 to 30 and 30 percent or more, with the modal interval of 10 to 15 percent as the reference. A natural cubic spline in the share yields a local slope, whose pointwise and simultaneous 95 percent bands we report, and a cluster-robust Wald test of deviations from linearity. A threshold model in the spirit of Hansen (2000) allows both the slope and the intercept to change at an unknown share τ, and a continuous kink model allows only the slope to change. In both cases τ is estimated by grid search between the 10th and 90th percentiles of the share. Because τ is not identified under the null hypothesis of linearity, inference relies on a wild cluster bootstrap with Rademacher weights at the LA level and 499 replications (Hansen, 1996). We distinguish a statistical threshold, defined as a share at which the slope changes significantly, from intervals in which rents differ significantly from the reference interval, since the latter can arise without any threshold when the relationship is simply linear.

The cross-sectional analysis asks where social housing is associated with higher or lower rents. A complementary question is where changes in social housing are associated with changes in rents. We therefore estimate the association between rent growth and additions to and losses of social housing separately for intervals of the share below 12, 12 to 16, 16 to 22 and 22 percent or more, with LA and region-by-year fixed effects. We test the equality of these coefficients across intervals and estimate a panel threshold model in which the flow coefficients switch at an unknown share (Hansen, 1999).

For the third research question, we use three tools. A decomposition following Gelbach (2016) attributes the change in the share coefficient between the raw and fully controlled models to each control variable, and a specification following Mundlak (1978) separates the within-LA and between-LA associations. We then re-estimate the slope and the threshold test within subgroups defined by location in London, earnings, vacancy, the size of the private rented sector, planning restrictiveness, council ownership of the social stock and deprivation. Finally, we compute the minimum differences between intervals that the data can detect with 80 percent power.

We do not interpret any of these estimates causally, and the reasons are documented in Appendix D. The first concerns the available variation. The within-LA standard deviation of the share over the decade is 0.43 percentage points, against 6.05 between LAs, so designs that rely on changes in the share over time have very little variation to work with. The second concerns the most natural design based on changes in supply. We estimated an event study around each LA's first large pulse of social and affordable rental completions, defined as at least three completions per 1,000 dwellings in a financial year, using the estimator of Sun and Abraham (2021) with never-treated LAs as controls. Rents in the 71 treated LAs were already declining relative to the 148 controls in the years before the pulse, and a joint test rejects the absence of pre-trends (F = 3.99, p < 0.001). Moreover, the event-time coefficients show no change in slope or level at the pulse itself (p = 0.64 and 0.81), so the apparent post-event decline in rents (−1.2 percent, p = 0.01) continues a pre-existing trend rather than marking a break, and it shrinks to an insignificant −0.4 percent once LA-specific trends are allowed. The third concerns instrumental variables. A shift-share predictor that combines each LA's pre-period share of national completions with national completions in later years has a weak first stage, with an F statistic of 3.4. Large social housing programmes therefore appear to be located in places whose rents were already evolving differently, which is consistent with the location-based explanation developed in Section 5.3.

# 5. Results

## 5.1 The association between the social housing share and private rents

Figure 2 presents the raw relationship, net of region-by-year effects, in twenty equal-sized bins of the share. Private rent levels are flat or rise slightly up to a share of about 15 percent and increase steadily thereafter, whereas rent growth shows no clear pattern.

{{FIG:fig2_binscatter.png|Figure 2. Social housing share and private rents, shown as binned means net of region-by-year effects (20 equal-sized bins).}}

Table 2 quantifies these patterns. With region-by-year effects alone, each percentage point of share is associated with private rents that are 0.77 percent higher (Panel A, column 1). Adding controls strengthens rather than weakens this association, which reaches 1.12 percent once demand, urban structure and deprivation are held constant (column 4). The positive association is therefore not an artefact of high-share places being wealthier or denser, because holding those characteristics constant makes it larger, for reasons examined in Section 5.3. LAs with more social housing also have higher rent-to-earnings ratios, by 0.44 percentage points of earnings per point of share. For rent growth (Panel B), the raw association is small and positive at 0.026 points per point of share, but it halves and becomes statistically insignificant once demand, density and initial rent levels are controlled for (0.011, SE 0.009). A long-difference regression of rent growth between 2015 and 2025 on the 2014 share yields a similar estimate of 0.016 (p = 0.06).

{{TABLE:table2}}

The within-LA estimates in column 5 point in the opposite direction. When an LA's share rises, its private rents tend to fall relative to other LAs in the same region and year, by 1.06 percent per percentage point (SE 0.38). Because the share changes by only about 0.4 points within the typical LA, these estimates rest on small movements and should be interpreted with caution. Their sign is nonetheless important for interpretation. The positive cross-sectional association does not indicate that adding social housing raises rents, but rather that places with a large social sector tend to be high-rent places for other reasons. Neither the cross-sectional nor the within-LA estimates should be read as causal effects, for the reasons set out in Section 4.

Taken together, these results indicate that across English LAs a higher social housing share is associated with higher private rent levels and, once local conditions are held constant, with no significant difference in rent growth. Within LAs, by contrast, increases in social housing are associated with lower rents.

## 5.2 Thresholds and intervals

Table 3 and Figure 3 compare rent levels and rent growth across intervals of the share. Relative to LAs with shares of 10 to 15 percent, and conditional on the full set of controls, rents are 4.6 percent lower in LAs below 10 percent (p = 0.02) and statistically indistinguishable in LAs at 15 to 20 percent (0.3 percent higher). They are 9.9 percent higher at 20 to 25 percent, 14.9 percent higher at 25 to 30 percent and 21.6 percent higher at 30 percent or more, with each of these differences significant at the 1 percent level. Rent growth does not differ significantly from the reference interval except in LAs below 10 percent, where it is 0.24 points lower (p = 0.05).

{{TABLE:table3}}

{{FIG:fig3_intervals.png|Figure 3. Private rent levels and growth by social housing share interval, relative to the 10-15% interval (full controls; 95% CIs; n = LAs observed in the interval).}}

These interval differences are consistent with a smoothly rising relationship rather than a threshold. A linear slope of 1.12 percent per point predicts differences of −4.5, 5.6, 11.2, 16.8 and about 25 percent at the midpoints of the five non-reference intervals, values that lie close to the interval estimates and within all of their confidence intervals. The interval in which differences first become significant, 20 to 25 percent, is therefore the point at which the cumulative distance from the reference becomes large enough to detect, not the point at which the slope changes.

Figure 4 reports the local slope implied by the spline. For rent levels the slope is positive across almost the entire range of the share, at about 1.2 to 1.4 percent per point above 16 percent, and it is imprecisely estimated between 11 and 15 percent, where the curve flattens briefly. For rent growth the slope is small and positive below about 14 percent and close to zero above it. Neither curve turns negative at high shares, and the simultaneous confidence bands are compatible with a constant slope over the whole range. Cluster-robust Wald tests do not reject linearity for either rent levels (p = 0.51) or rent growth (p = 0.34).

{{FIG:fig4_gam_derivative.png|Figure 4. Local slope of the share-rent relationship estimated from the spline derivative, with pointwise (shaded) and simultaneous (dashed) 95% bands. The dotted line marks the estimated kink location.}}

The formal threshold tests in Table 4 confirm this picture. For rent levels, the best-fitting split lies at a share of 15.3 percent, but the slopes on either side are almost identical at 1.22 and 1.41 percent per point, and neither this threshold nor the estimated kink at 16.9 percent is statistically significant (bootstrap p = 0.38 and 0.39). For rent growth, the best split lies consistently between 15.3 and 15.7 percent. Below it, rent growth rises with the share by 0.06 points per point (p < 0.01), while above it the slope is close to zero and insignificant. This flattening is not significant in the baseline specification (p = 0.21 for the threshold and 0.18 for the kink), although it becomes significant when the Census-based share is used (p = 0.03) and marginally significant when the pandemic years are excluded (p = 0.06), as reported in Appendix Table C1. We therefore regard it as suggestive evidence that, beyond a share of about 15 percent, further increases in social housing are not associated with any additional difference in rent growth across LAs. In no specification does the growth relationship become negative.

{{TABLE:table4}}

Table 5 and Figure 5 address the within-LA question of where additions to and losses of social housing are most strongly associated with rents. Across all LAs, each additional social or affordable rental completion per 1,000 dwellings over two years is associated with annual rent growth that is 0.07 percentage points lower. The point estimates are largest in LAs with shares below 12 percent (−0.11, p = 0.02) and at 22 percent or more (−0.14, p = 0.07), smaller between 12 and 16 percent (−0.05), and close to zero between 16 and 22 percent. RTB sales are associated with faster rent growth, most strongly between 12 and 16 percent (0.76, p < 0.01). Equality across intervals cannot be rejected for either additions (p = 0.24) or losses (p = 0.11), and a panel threshold test on the flow coefficients finds no significant threshold (p = 0.17 for additions and 0.29 for losses). Changes in social housing are therefore associated with private rent growth in the expected direction at every level of the share, with no interval in which they begin or cease to matter and no indication that additions become counterproductive at high shares.

{{TABLE:table5}}

{{FIG:fig5_flows_by_interval.png|Figure 5. Rent growth effects of adding (new build) and losing (Right to Buy) social housing, by social housing share interval (LA and region-by-year FE; 95% CIs).}}

In sum, the evidence does not support a threshold beyond which private rents fall. In the cross-section, private rent levels rise steadily with the share and are significantly higher than in the modal interval from about 20 percent upward, with the largest differences, of around 22 percent, above 30 percent. This pattern is the opposite of a dampening threshold, but it is not a reversal of an earlier negative relationship either, since the association is positive throughout. Rent growth rises slightly with the share up to about 15 percent and is flat thereafter, a pattern that is suggestive but not robust. Within LAs, additions to social housing are associated with slower rent growth at every level of the share, with no significant differences between intervals.

## 5.3 Explaining the absence of a threshold

### Variables shaping the relationship

Table 6 decomposes the difference between the raw and fully controlled share coefficients. For rent levels, the raw coefficient of 0.77 understates the controlled coefficient of 1.12, and this gap is the net outcome of offsetting influences. Density raises the raw association, because high-share LAs tend to be dense urban areas and density is strongly associated with higher rents, and it accounts for 0.76 points of the raw coefficient. Deprivation and low earnings work in the opposite direction. High-share LAs are more deprived and have lower earnings, both of which are associated with lower rents, so these variables mask part of the positive association, contributing −0.78 and −0.34 points respectively. For rent growth, density again accounts for most of the small raw association (0.021 of 0.026), while initial rent levels contribute a small negative amount that reflects faster growth in initially cheaper places. Demand growth, unemployment and housing supply contribute little in either case.

{{TABLE:table6}}

{{FIG:fig6_gelbach.png|Figure 6. Contributions of control variables to the raw share-rent association (Gelbach decomposition; 95% bootstrap CIs).}}

The Mundlak decomposition reported at the bottom of Table 6 makes the central point more formally. For rent levels, the between-LA association is 1.03 (SE 0.15), whereas the within-LA association is −1.06 (SE 0.38). For rent growth, the between-LA association is zero and the within-LA association is negative but imprecise (−0.16, SE 0.10). Any threshold test conducted across LAs necessarily relies on the between-LA variation, and that variation is dominated by where social housing was historically built, which is predominantly in dense urban cores that remain the highest-rent parts of their regions. Whatever dampening effect social housing exerts appears within places, but the within-LA variation in the share is too small to trace out how this effect varies with the share.

### The role of market context

Table 7 and Figure 7 report the slope of the share-rent relationship within subgroups of LAs. For rent levels, the positive association is significantly stronger in London than elsewhere (1.45 against 0.89, p = 0.03 for equality), in high-earning than in low-earning LAs (1.28 against 0.75, p = 0.05), in tight markets with low vacancy than in slack markets (1.17 against 0.45, p < 0.01), and in planning-restrictive than in permissive LAs (1.48 against 0.79, p = 0.01). It does not differ significantly with the size of the private rented sector or with council rather than housing association ownership, and the difference by deprivation is only marginal (p = 0.08). For rent growth, none of these characteristics significantly alters the slope.

{{TABLE:table7}}

{{FIG:fig7_moderators.png|Figure 7. Slope of the share-rent relationship within subgroups (95% CIs).}}

Threshold tests within subgroups lead to similar conclusions. For rent levels, none of the fourteen subgroup tests is significant, with bootstrap p-values between 0.12 and 0.72. For rent growth, three of the fourteen tests are significant at the 5 percent level, which exceeds the 0.7 rejections expected by chance, although none survives a Bonferroni correction for the 28 tests conducted. In LAs with a small private rented sector, the estimated break lies at 16.4 percent (p = 0.04), with rent growth rising with the share below it by 0.05 points per point and remaining flat above it. In planning-restrictive LAs, the break lies at 14.5 percent (p = 0.01) and the pattern is similar, with a slope of 0.09 below and 0.01 above. In less deprived LAs, the break lies at 12.8 percent (p = 0.01), and rent growth jumps at the break and then declines with the share at a rate of 0.05 points per point (p = 0.02). This is the only case in the analysis in which a higher share is associated with slower rent growth beyond a threshold. Two of the three subgroup breaks therefore replicate the flattening at around 15 percent found in the full sample, and growth thresholds, where they appear at all, are concentrated in markets where social housing is relatively scarce, supply is constrained or deprivation is low.

The moderation results are informative about mechanisms. If high shares disciplined private rents through competition, the association should be most negative where social housing is most attractive relative to private renting, which is in expensive and tight markets. The association is instead most positive in exactly those markets. Two explanations are consistent with this pattern. The first is unobserved demand, since dense and high-demand cities historically built more council housing and remain high-rent places for reasons that the controls capture only partially. The second is scarcity, since in supply-constrained markets a large and rationed social sector leaves a thinner private rental market for households who do not qualify for social housing, which keeps private rents high. The data cannot distinguish between these explanations, but both imply that in a dual rental market such as England's a high social housing share does not act as a mechanism that pulls private rents down across the market.

### Statistical power

The absence of a threshold at very high shares may partly reflect limited statistical power. With 80 percent power, the minimum detectable difference in rent levels is about 5 percent for the 15 to 20 percent interval, rising to 8 percent for 20 to 25 percent, 8.5 percent for 25 to 30 percent and 12 percent above 30 percent, where only 13 LAs are observed. The corresponding figures for rent growth are 0.27, 0.41, 0.56 and 0.58 percentage points. A threshold above 30 percent that produced a difference in rent levels of less than about 12 percent would therefore not be detectable in the English data. Power is adequate, however, in the range from 10 to 25 percent, where about 85 percent of LAs are located and where the threshold has usually been placed in policy debate.

Overall, the absence of a dampening threshold can be traced to three features of the data. The cross-sectional relationship is shaped by where social housing is located, with density accounting for much of the positive raw association and deprivation and low earnings masking part of it, and the association is strongest in London and in high-earning, tight and planning-restrictive markets, a pattern more consistent with omitted urban demand or private rental scarcity than with competition. The share also changes very little within LAs, so the dampening observed within places cannot be traced across levels of the share. Finally, few LAs have very high shares, which limits power above 25 to 30 percent. Where subgroup thresholds in rent growth do appear, at around 13 to 16 percent, they mark a flattening of the relationship rather than the onset of dampening, and they do not survive correction for multiple testing.

# 6. Robustness

Appendix Table C1 re-estimates the linear slope and the threshold test under alternative measures and samples. The relationship with rent levels remains positive, approximately linear and without a significant threshold when the Census 2021 social-rented share of households replaces the administrative share (a slope of 1.31 per point and a threshold p-value of 0.23), when London is excluded (0.93 and 0.21), and when two-bedroom rents replace all-property rents in order to remove differences in dwelling composition (1.06 and 0.42). Affordability, measured as annual rent relative to local median earnings, also deteriorates linearly with the share (0.44 points per point, with a threshold p-value of 0.61). For rent growth, all specifications place the break between 15.3 and 15.7 percent, with a positive slope below it and a slope close to zero above it, but its statistical significance ranges from p = 0.03 with the Census-based share to p = 0.23 when London is excluded.

# 7. Discussion and Conclusion

This paper has asked whether there is a social housing share beyond which private rents are affected. Across 294 English local authorities with shares ranging from 5 to more than 40 percent, we find no share at which private rents begin to fall. The cross-sectional relationship between the share and rent levels is positive and close to linear, so that places with more social housing have higher private rents, significantly so above about 20 percent. For rent growth, the only consistent nonlinearity is a flattening at around 15 percent, beyond which the share is unrelated to growth. Within places, more social housing is associated with lower rents, and each addition to the social stock is associated with slower private rent growth regardless of the existing share. There is no level of the share at which additions become counterproductive.

These findings carry three implications. First, cross-city comparisons of social housing shares and private rents, which are often invoked in support of the threshold view, provide a poor guide to the consequences of social housing for private rents. In England such a comparison would suggest that social housing raises rents, whereas the pattern in fact reflects the concentration of social housing in dense, high-demand cities. Second, the associations we can detect are incremental. They scale with the number of homes added or lost rather than with the share of the stock that has been reached, which implies that a programme need not cross a critical mass before private renters benefit, and that losses through Right to Buy are associated with faster private rent growth even where the social sector is small. Third, England's dual rental market may lack the institutional features on which Kemeny's competition mechanism depends, including broad eligibility, cost rents well below market rents and a mature non-profit sector open to middle-income households. The positive association is strongest precisely in the tight and expensive markets where a competition mechanism should have the greatest force, which suggests that in a rationed system a large social sector coexists with, and may reinforce, scarcity in private renting. Whether thresholds emerge in unitary systems such as Austria's remains an open question for comparative research using consistent outcome measures.

The study has several limitations. The relationships we document are associations, because social housing was not located at random and, as Appendix D shows, neither an event-study design nor an instrumental-variables approach yields credible causal estimates in these data. The share changes little within LAs, which constrains the analysis of within-place variation. Few LAs exceed a share of 30 percent, so thresholds at very high shares cannot be excluded. PIPR is a modelled index, and the decade under study includes both a pandemic and an exceptional surge in rents. Within these limits the evidence is consistent, and it suggests that for England the relevant policy question is not whether social housing has reached a threshold but how many homes are added and how many are lost.

# References

Asquith, B. J., Mast, E., & Reed, D. (2023). Local effects of large new apartment buildings in low-income areas. *The Review of Economics and Statistics, 105*(2), 359-375. https://doi.org/10.1162/rest_a_01055

Banabak, S. (2023). Neighbourhood rental market integration and private rent trajectories – evidence from the city of Vienna. *International Journal of Urban Sciences, 27*(2), 239-259. https://doi.org/10.1080/12265934.2022.2110144

Baum-Snow, N., & Marion, J. (2009). The effects of low income housing tax credit developments on neighborhoods. *Journal of Public Economics, 93*(5-6), 654-666. https://doi.org/10.1016/j.jpubeco.2009.01.001

Chapelle, G., Gobillon, L., & Vignolles, B. (2025). *Building without income mixing: Public housing quotas in France* [Working paper]. SSRN. https://doi.org/10.2139/ssrn.5227060

Czischke, D., & van Bortel, G. (2023). An exploration of concepts and polices on 'affordable housing' in England, Italy, Poland and The Netherlands. *Journal of Housing and the Built Environment, 38*(1), 283-303. https://doi.org/10.1007/s10901-018-9598-1

Diamond, R., & McQuade, T. (2019). Who wants affordable housing in their backyard? An equilibrium analysis of low-income property development. *Journal of Political Economy, 127*(3), 1063-1117. https://doi.org/10.1086/701354

Disney, R., & Luo, G. (2017). The Right to Buy public housing in Britain: A welfare analysis. *Journal of Housing Economics, 35*, 51-68. https://doi.org/10.1016/j.jhe.2017.01.005

Eriksen, M. D., & Rosenthal, S. S. (2010). Crowd out effects of place-based subsidized rental housing: New evidence from the LIHTC program. *Journal of Public Economics, 94*(11-12), 953-966. https://doi.org/10.1016/j.jpubeco.2010.07.002

Fitzpatrick, S., & Pawson, H. (2014). Ending security of tenure for social renters: Transitioning to 'ambulance service' social housing? *Housing Studies, 29*(5), 597-615. https://doi.org/10.1080/02673037.2013.803043

Friesenecker, M., & Kazepov, Y. (2021). Housing Vienna: The socio-spatial effects of inclusionary and exclusionary mechanisms of housing provision. *Social Inclusion, 9*(2), 77-90. https://doi.org/10.17645/si.v9i2.3837

Gelbach, J. B. (2016). When do covariates matter? And which ones, and how much? *Journal of Labor Economics, 34*(2), 509-543. https://doi.org/10.1086/683668

Gobillon, L., & Vignolles, B. (2016). Évaluation de l'effet d'une politique spatialisée d'accès au logement : la loi SRU. *Revue économique, 67*(3), 615-637. https://doi.org/10.3917/reco.673.0615

Haffner, M., Hoekstra, J., Oxley, M., & van der Heijden, H. (2009). *Bridging the gap between social and market rented housing in six European countries?* IOS Press. https://doi.org/10.3233/978-1-60750-035-3-i

Hansen, B. E. (1996). Inference when a nuisance parameter is not identified under the null hypothesis. *Econometrica, 64*(2), 413-430. https://doi.org/10.2307/2171789

Hansen, B. E. (2000). Sample splitting and threshold estimation. *Econometrica, 68*(3), 575-603. https://doi.org/10.1111/1468-0262.00124

Hansen, B. E. (1999). Threshold effects in non-dynamic panels: Estimation, testing, and inference. *Journal of Econometrics, 93*(2), 345-368. https://doi.org/10.1016/S0304-4076(99)00025-1

Hilber, C. A. L., & Vermeulen, W. (2016). The impact of supply constraints on house prices in England. *The Economic Journal, 126*(591), 358-405. https://doi.org/10.1111/ecoj.12213

Kadi, J. (2015). Recommodifying housing in formerly "Red" Vienna? *Housing, Theory and Society, 32*(3), 247-265. https://doi.org/10.1080/14036096.2015.1024885

Kemeny, J. (1995). *From public housing to the social market: Rental policy strategies in comparative perspective*. Routledge. https://doi.org/10.4324/9780203308554

Kemeny, J., Kersloot, J., & Thalmann, P. (2005). Non-profit housing influencing, leading and dominating the unitary rental market: Three case studies. *Housing Studies, 20*(6), 855-872. https://doi.org/10.1080/02673030500290985

Klien, M., Huber, P., Reschenhofer, P., Gutheil-Knopp-Kirchwald, G., & Kössl, G. (2023). *Die preisdämpfende Wirkung des gemeinnützigen Wohnbaus* [The price-dampening effect of non-profit housing] (WIFO Studies). Austrian Institute of Economic Research (WIFO). https://www.wifo.ac.at/wwa/pubid/69779

Koster, H. R. A., & van Ommeren, J. (2019). Place-based policies and the housing market. *The Review of Economics and Statistics, 101*(3), 400-414. https://doi.org/10.1162/rest_a_00779

Li, X. (2022). Do new housing units in your backyard raise your rents? *Journal of Economic Geography, 22*(6), 1309-1352. https://doi.org/10.1093/jeg/lbab034

Malpezzi, S., & Vandell, K. (2002). Does the low-income housing tax credit increase the supply of housing? *Journal of Housing Economics, 11*(4), 360-380. https://doi.org/10.1016/S1051-1377(02)00123-7

Mundlak, Y. (1978). On the pooling of time series and cross section data. *Econometrica, 46*(1), 69-85. https://doi.org/10.2307/1913646

Murray, M. P. (1999). Subsidized and unsubsidized housing stocks 1935 to 1987: Crowding out and cointegration. *The Journal of Real Estate Finance and Economics, 18*(1), 107-124. https://doi.org/10.1023/A:1007741630145

Nguyen, M. T. (2005). Does affordable housing detrimentally affect property values? A review of the literature. *Journal of Planning Literature, 20*(1), 15-26. https://doi.org/10.1177/0885412205277069

OECD. (2020). *Social housing: A key part of past and future housing policy* (Employment, Labour and Social Affairs Policy Briefs). OECD Publishing. https://doi.org/10.1787/5b54f96b-en

Schwartz, A. E., Ellen, I. G., Voicu, I., & Schill, M. H. (2006). The external effects of place-based subsidized housing. *Regional Science and Urban Economics, 36*(6), 679-707. https://doi.org/10.1016/j.regsciurbeco.2006.04.002

Sinai, T., & Waldfogel, J. (2005). Do low-income housing subsidies increase the occupied housing stock? *Journal of Public Economics, 89*(11-12), 2137-2164. https://doi.org/10.1016/j.jpubeco.2004.06.015

Stephens, M. (2020). How housing systems are changing and why: A critique of Kemeny's theory of housing regimes. *Housing, Theory and Society, 37*(5), 521-547. https://doi.org/10.1080/14036096.2020.1814404

Sun, L., & Abraham, S. (2021). Estimating dynamic treatment effects in event studies with heterogeneous treatment effects. *Journal of Econometrics, 225*(2), 175-199. https://doi.org/10.1016/j.jeconom.2020.09.006

# Appendix A. Data Sources and Cleaning

All cleaning steps are implemented in `code/02_clean.py`, and the log generated by that script is reproduced in Section A.3.

## A.1 Sources

{{TABLE_SOURCES}}

## A.2 Cleaning decisions and rationale

All series are harmonised to April 2023 LA district boundaries, which is the geography used by PIPR, by summing predecessor districts. Because every reorganisation between 2010 and 2023 merged whole districts, counts aggregate exactly, and two re-codings without boundary changes are simply relabelled. City of London and the Isles of Scilly are dropped because PIPR does not cover them.

Monthly PIPR values are averaged within calendar years before logarithms or log differences are taken. This removes month-specific noise and aligns the rent data with the annual stock data. Observations for 2026 are dropped because the year is incomplete.

The social housing share is computed from combined council and housing association stock so that transfers between the two sectors do not create spurious changes. Two isolated reporting errors in combined stock that reverse in the following year, for South Lakeland in 2012 and East Dorset in 2011, are replaced by the mean of the adjacent years. The rule flags deviations larger than 15 percent and 500 units and is applied iteratively. Without this correction, such errors would produce large artificial changes in a variable whose genuine within-LA variation is small. The administrative share correlates at 0.99 with the Census 2021 social-rented share of households, and the largest differences, in Westminster, Medway and Kensington and Chelsea, are documented in the log. The Census measure is used as a robustness check.

The share is measured at 31 March of the previous year and time-varying controls are lagged by one year, so that all explanatory variables predate the rent observation. This timing also avoids losing 2025, for which population and earnings estimates have not yet been published.

Only completions are used to measure additions to the social stock. Ownership products such as shared ownership and First Homes are excluded because they do not add to social rental supply. Flows are normalised by the previous year's dwelling stock and summed over two financial years.

For the unitary authorities created between 2019 and 2023 and for two re-coded districts, Nomis does not publish some years on the 2023 geography. Population is obtained by summing predecessor districts exactly, while earnings medians and unemployment rates are approximated by population-weighted means of predecessor values. Remaining suppressed earnings values are interpolated within LAs and flagged.

The IMD 2019 score is averaged across neighbourhoods (LSOAs) weighted by their 2015 population and aggregated to 2023 LA districts, so it is measured before most of the outcome period. Land area is taken from ultra-generalised 2023 boundaries, which are adequate for computing log density.

All moderators are measured before or independently of the outcome period. These are Census 2011 tenure, planning decisions between 1979 and 2013, the 2014 vacancy rate, and the council share of social stock and earnings in 2015 and 2016. As a result, none of them can be a consequence of rents between 2016 and 2025.

## A.3 Automatically generated cleaning log

{{CLEANING_LOG}}

# Appendix B. Threshold and Kink Estimation

For each candidate threshold τ on a grid of quantiles of the lagged share, running from the 10th to the 90th percentile in steps of 1.25 percentiles, the regime-specific slope terms $SH \cdot \mathbb{1}(SH \le \tau)$ and $SH \cdot \mathbb{1}(SH > \tau)$, the regime intercept $\mathbb{1}(SH > \tau)$ and all controls are demeaned with respect to the fixed effects, and the sum of squared residuals $S_1(\tau)$ is computed. The estimate $\hat\tau$ minimises $S_1$. The test statistic $F = (S_0 - S_1(\hat\tau))/\hat\sigma^2$ is compared with its wild cluster bootstrap distribution under the linear null, in which residuals from the linear model are multiplied by LA-level Rademacher weights and both models are re-estimated over the full grid, with 499 replications in the main analysis and 299 in the subgroup and robustness tests. The kink model replaces the regime terms with $SH$ and $(SH-\tau)_+$. The flow threshold model reported in Table 5 follows Hansen (1999) with LA and region-by-year fixed effects. The code is available in `code/threshold_functions.R`.

# Appendix C. Robustness

{{TABLE:tableC1}}

# Appendix D. Diagnostics for Causal Designs

This appendix documents the diagnostics summarised in Section 4. Table D1 reports the within-LA and between-LA variation in the main variables, the results of an event study around the first large pulse of social and affordable rental completions, and the first stage of a shift-share instrument for completions. Figure D1 plots the event-study coefficients. Rents in treated LAs follow a steady downward trend relative to never-treated LAs that begins well before the completion pulse and continues at a similar rate afterwards. The pre-trend tests reject parallel trends both with and without LA-specific linear trends, and the event-time coefficients show no change in slope or level at the event. Taken together, these diagnostics indicate that the timing and location of large social housing programmes are correlated with pre-existing rent dynamics, which is why the analysis in the main text is framed as descriptive.

{{TABLE:tableD1}}

{{FIG:figD1_event_study.png|Figure D1. Event-study coefficients for private rents around the first large social and affordable rental completion pulse, relative to the year before the pulse (Sun and Abraham estimator, 95% CIs).}}

