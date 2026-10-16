"""
02_clean.py
Build the LA-by-year analysis panel (2023 LAD geography, England) from data/raw/.
Every cleaning decision is logged to docs/cleaning_log.md (auto-generated) and is
explained in the paper's Data Appendix.

Unit:   local authority district (LAD, April-2023 boundaries), 294 LADs
        (City of London and Isles of Scilly dropped: not covered by PIPR).
Time:   calendar year t = 2015..2025 for rents (growth defined 2016..2025).
Timing convention
  * Social-housing stock share SH_{i,t-1}: Table 100 stock at 31 March of year t-1
    (i.e. measured 9-21 months before the rent observations of calendar year t).
  * Flows (affordable completions, Right-to-Buy sales): financial year ending
    31 March t is assigned to year t ("fy_end").
  * Rent growth: change in the log of the calendar-year mean of the monthly PIPR index.
"""
import os
import numpy as np
import pandas as pd
from geo import to2023, is_english_lad, DROP

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW = os.path.join(ROOT, "data", "raw")
INT = os.path.join(ROOT, "data", "interim")
CLEAN = os.path.join(ROOT, "data", "clean")
DOCS = os.path.join(ROOT, "docs")
for d in (INT, CLEAN, DOCS):
    os.makedirs(d, exist_ok=True)

LOG = []


def log(msg):
    print(msg)
    LOG.append(msg)


def num(s):
    return pd.to_numeric(s.replace({"[x]": np.nan, "[z]": np.nan, "..": np.nan, "[c]": np.nan}),
                         errors="coerce")


# =============================================================================
# 1. PIPR private rents (outcome)
# =============================================================================
log("## 1. Private rents: ONS Price Index of Private Rents (PIPR)")
h = pd.read_excel(os.path.join(RAW, "PIPR_202609.xlsx"), sheet_name="Table 1", header=2)
h.columns = [c.strip() for c in h.columns]
h = h.rename(columns={"Time period": "date", "Area code": "code", "Area name": "name",
                      "Region or country name": "region"})
h = h[h["code"].apply(is_english_lad)].copy()
h["date"] = pd.to_datetime(h["date"])
h["year"] = h["date"].dt.year
seg = {"": "all", " one bed": "b1", " two bed": "b2", " three bed": "b3", " four or more bed": "b4",
       " detached": "det", " semidetached": "semi", " terraced": "terr", " flat maisonette": "flat"}
for suf, tag in seg.items():
    h[f"idx_{tag}"] = num(h[f"Index{suf}"])
    h[f"rentlvl_{tag}"] = num(h[f"Rental price{suf}"])
log(f"- PIPR monthly LA series: {h.code.nunique()} English LADs, {h.date.min():%Y-%m} to {h.date.max():%Y-%m}.")
n_months = h.groupby(["code", "year"]).date.count()
h = h[h.year <= 2025]  # 2026 is a partial year -> dropped
log("- Dropped 2026 (partial year, Jan-Aug only). Annual values are the mean of 12 monthly index values.")
rent = h.groupby(["code", "year"]).agg(
    name=("name", "first"), region=("region", "first"),
    **{f"idx_{t}": (f"idx_{t}", "mean") for t in seg.values()},
    **{f"rentlvl_{t}": (f"rentlvl_{t}", "mean") for t in seg.values()},
    nmonths=("date", "count")).reset_index()
assert (rent.nmonths == 12).all()
rent = rent.sort_values(["code", "year"])
for t in seg.values():
    rent[f"dlnrent_{t}"] = rent.groupby("code")[f"idx_{t}"].transform(lambda s: np.log(s).diff() * 100)
log("- Outcome dlnrent = 100 x [ln(mean index_t) - ln(mean index_{t-1})], i.e. annual private rent growth in percent;"
    " also computed separately for 1/2/3/4+ bedroom and detached/semi/terraced/flat segments.")
miss_seg = rent[[f"idx_{t}" for t in seg.values()]].isna().mean().round(3).to_dict()
log(f"- Share of LA-years with missing segment index: {miss_seg}")

# =============================================================================
# 2. Dwelling stock by tenure (Live Table 100) -> social housing share
# =============================================================================
log("\n## 2. Social housing stock share: MHCLG Live Table 100")
x = pd.ExcelFile(os.path.join(RAW, "LiveTable100.ods"), engine="odf")
parts = []
for yr in range(2010, 2026):
    d = pd.read_excel(x, sheet_name=str(yr), header=None)
    hdr = d.index[d.apply(lambda r: r.astype(str).str.contains("Private sector").any(), axis=1)][0]
    d = d.iloc[hdr + 1:]
    codecol = max(range(3), key=lambda j: d.iloc[:, j].apply(is_english_lad).sum())
    v = d.iloc[:, -5:].copy()
    v.columns = ["la_stock", "prp_stock", "oth_pub", "priv_stock", "tot_stock"]
    v["code_orig"] = d.iloc[:, codecol].astype(str).str.strip()
    v = v[v.code_orig.apply(is_english_lad)]
    v["year"] = yr
    parts.append(v)
st = pd.concat(parts)
for c in ["la_stock", "prp_stock", "oth_pub", "priv_stock", "tot_stock"]:
    st[c] = num(st[c].astype(object))
log("- 2009 sheet uses pre-2009 district codes and is not used; sample of stock years is 31 March 2010-2025.")
log(f"- Missing component values (set to 0 only where Table 100 reports [x] for LA stock in stock-transfer"
    f" authorities): {int(st[['la_stock','prp_stock']].isna().sum().sum())} cells.")
st[["la_stock", "prp_stock", "oth_pub"]] = st[["la_stock", "prp_stock", "oth_pub"]].fillna(0)

# Repair transient one-year spikes (reporting errors). Done on COMBINED social stock (LA + PRP) so that
# genuine large-scale voluntary stock transfers (LA stock -> PRP stock, combined total unchanged) are not
# mistaken for errors.
st = st.sort_values(["code_orig", "year"]).reset_index(drop=True)
st["soc_stock"] = st.la_stock + st.prp_stock
repaired = []
while True:  # iterative: repair the single largest spike, then re-evaluate neighbours
    g = st.groupby("code_orig")["soc_stock"]
    prev, nxt = g.shift(1), g.shift(-1)
    nb = (prev + nxt) / 2
    dev = (st.soc_stock - nb).abs()
    spike = (prev.notna() & nxt.notna() & (dev > 0.15 * nb) & (dev > 500)
             & (np.sign(st.soc_stock - prev) != np.sign(nxt - st.soc_stock)))
    if not spike.any():
        break
    i = (dev / nb).where(spike).idxmax()
    r = st.loc[i]
    repaired.append(f"{r.code_orig} {r.year}: LA {r.la_stock:.0f} + PRP {r.prp_stock:.0f} = {r.soc_stock:.0f} -> {nb[i]:.0f}")
    st.loc[i, "soc_stock"] = nb[i]
log(f"- Transient spikes in combined social stock repaired (deviation >15% and >500 units from the mean of the"
    f" adjacent years, reversing the following year; replaced by that mean): {len(repaired)}")
for r in repaired:
    log(f"    - {r}")
log("- Large-scale voluntary transfers of council stock to housing associations move units from the LA to the PRP"
    " column; because the share is computed on combined social stock these transfers do not create artificial"
    " changes in SH share.")

st["code"] = st.code_orig.map(to2023)
log("- Codes harmonised to April-2023 LADs by summing predecessor districts (all 2010-2023 reorganisations were"
    " whole-district mergers; 2013 and 2023 re-codings with no boundary change were relabelled).")
st = st.groupby(["code", "year"])[["la_stock", "prp_stock", "soc_stock", "oth_pub", "priv_stock", "tot_stock"]].sum().reset_index()
st["sh_share"] = st.soc_stock / st.tot_stock * 100
st["la_share"] = st.la_stock / st.tot_stock * 100
st["prp_share"] = st.prp_stock / st.tot_stock * 100
log("- SH share = (local authority + private registered provider stock) / total dwelling stock x 100."
    " 'Other public sector' stock (mainly MoD) is excluded from the numerator. PRP stock includes general-needs,"
    " supported and low-cost home-ownership units owned by registered providers; see Appendix for this caveat.")

# =============================================================================
# 3. Flows: affordable housing supply (new build vs acquisition), Right to Buy
# =============================================================================
log("\n## 3. Flows: affordable housing completions and Right to Buy sales")
a = pd.read_csv(os.path.join(RAW, "AHS_open_data.csv"), low_memory=False)
a = a[(a.Completions == "Completion")]
a["code"] = a["LA code 202425"].map(lambda c: to2023(c) if isinstance(c, str) else c)
a["fy_end"] = a.Year.str[:4].astype(int) + 1
rental = ["Social Rent", "Affordable Rent", "London Affordable Rent", "Intermediate Rent"]
a["grp"] = np.select(
    [a.Tenure.isin(["Social Rent", "London Affordable Rent"]) & (a.Type == "NB"),
     a.Tenure.isin(["Affordable Rent"]) & (a.Type == "NB"),
     a.Tenure.isin(rental) & (a.Type == "AQ"),
     a.Tenure.isin(["Intermediate Rent"]) & (a.Type == "NB"),
     ~a.Tenure.isin(rental)],
    ["sr_nb", "ar_nb", "rent_aq", "ir_nb", "own"], default="other")
unalloc = a.code.isna().mean()
log(f"- AHS open data, completions only. Share of unit records without a current LA code (dropped): {unalloc:.4f}.")
log("- Rental affordable completions split into: social rent & London Affordable Rent new build (sr_nb);"
    " Affordable Rent (<=80% market) new build (ar_nb); intermediate rent new build (ir_nb); all rental"
    " acquisitions (rent_aq: purchases of existing dwellings). Ownership products (shared ownership, First"
    " Homes, etc.) are kept separately (own) and are not counted as social rental supply.")
fl = a.dropna(subset=["code"]).pivot_table(index=["code", "fy_end"], columns="grp", values="Units",
                                             aggfunc="sum", fill_value=0).reset_index()
fl = fl.rename(columns={"fy_end": "year"})
for c in ["sr_nb", "ar_nb", "rent_aq", "ir_nb", "own", "other"]:
    if c not in fl:
        fl[c] = 0

r = pd.read_csv(os.path.join(RAW, "RTB_sales_open_data.csv"))
r = r[r.Eligible_Sale_Type_2.isin(["Right to Buy", "Unknown"])]
r["code"] = r.LAD25CD.map(to2023)
r["year"] = r.Year.str[:4].astype(int) + 1
rtb = r.groupby(["code", "year"]).Units.sum().rename("rtb_sales").reset_index()
log("- Right to Buy: council (LA-landlord) RTB sales from the RTB open data (2006-07 onward; 'Unknown' sale type"
    " before 2012-13 is RTB by construction). LAs without retained council stock have no RTB sales (set to 0)."
    " Preserved RTB / Right to Acquire sales by housing associations are not in this file.")

# =============================================================================
# 4. Controls
# =============================================================================
log("\n## 4. Controls")
pop = pd.read_csv(os.path.join(RAW, "nomis_population.csv"))
pop = pop.rename(columns={"DATE_NAME": "year", "GEOGRAPHY_CODE": "code", "OBS_VALUE": "pop"})[["code", "year", "pop"]]
pay = pd.read_csv(os.path.join(RAW, "nomis_ashe_median_ft_pay.csv"))
pay = pay.rename(columns={"DATE_NAME": "year", "GEOGRAPHY_CODE": "code", "OBS_VALUE": "pay"})[["code", "year", "pay"]]
pay["pay"] = pd.to_numeric(pay["pay"], errors="coerce")
un = pd.read_csv(os.path.join(RAW, "nomis_unemployment.csv"))
un["year"] = un.DATE_NAME.str[-4:].astype(int)
un = un.rename(columns={"GEOGRAPHY_CODE": "code", "OBS_VALUE": "unemp"})[["code", "year", "unemp"]]
un["unemp"] = pd.to_numeric(un["unemp"], errors="coerce")
log("- Population: ONS mid-year estimates (Nomis NM_2002_1, re-based by Nomis to 2023 LADs)."
    " Earnings: ASHE resident-based median gross annual pay of full-time workers (NM_30_1)."
    " Unemployment: APS model-based unemployment rate, Jan-Dec (NM_127_1).")


def backfill(main, fname, var, how):
    """Fill LA-years missing on the 2023 geography from 2019-geography predecessors.
    how='sum' (population counts: exact) or 'popw' (rates/medians: population-weighted mean, approximate)."""
    old = pd.read_csv(os.path.join(RAW, fname))
    old["year"] = old.DATE_NAME.astype(str).str[-4:].astype(int)
    old = old.rename(columns={"GEOGRAPHY_CODE": "code_orig", "OBS_VALUE": var})[["code_orig", "year", var]]
    old[var] = pd.to_numeric(old[var], errors="coerce")
    old["code"] = old.code_orig.map(to2023)
    old = old[old.code != old.code_orig]  # only predecessors of merged / re-coded LADs
    if how == "sum":
        agg = old.groupby(["code", "year"])[var].sum(min_count=1)
    else:
        w = pd.read_csv(os.path.join(RAW, "nomis_population_lad19.csv"))
        w = w.rename(columns={"DATE_NAME": "year", "GEOGRAPHY_CODE": "code_orig", "OBS_VALUE": "w"})[["code_orig", "year", "w"]]
        old = old.merge(w, on=["code_orig", "year"], how="left")
        old["w"] = old.groupby("code_orig").w.transform(lambda s: s.ffill().bfill())
        old = old.dropna(subset=[var, "w"])
        agg = old.groupby(["code", "year"]).apply(lambda d: np.average(d[var], weights=d.w))
    agg = agg.rename(var + "_bf").reset_index()
    m = main.merge(agg, on=["code", "year"], how="outer")
    nfill = (m[var].isna() & m[var + "_bf"].notna()).sum()
    m[var] = m[var].fillna(m[var + "_bf"])
    return m.drop(columns=var + "_bf"), nfill


pop, n1 = backfill(pop, "nomis_population_lad19.csv", "pop", "sum")
pay, n2 = backfill(pay, "nomis_ashe_median_ft_pay_lad19.csv", "pay", "popw")
un, n3 = backfill(un, "nomis_unemployment_lad19.csv", "unemp", "popw")
log(f"- Nomis does not publish some years on the 2023 geography for the 2019-23 unitaries and for re-coded"
    f" Barnsley/Sheffield. These were back-filled from 2019-geography predecessors: population summed exactly"
    f" ({n1} LA-years); median pay ({n2}) and unemployment rates ({n3}) as population-weighted means of predecessor"
    f" values (an approximation, since medians and model-based rates do not aggregate exactly).")
miss_pay = pay[pay.code.isin(rent.code.unique()) & pay.year.between(2014, 2025)].pay.isna().sum()
log(f"- ASHE pay suppressed/missing LA-years 2014-2025: {miss_pay}; filled by linear interpolation within LA"
    f" (and carried at the ends) so that sample composition is stable; an indicator flags imputed values.")

# Net additional dwellings (Live Table 122)
x122 = pd.read_excel(os.path.join(RAW, "Live_Table_122.ods"), engine="odf", sheet_name="LT_122", header=4)
x122 = x122[x122["Current ONS code"].apply(is_english_lad)]
yrcols = [c for c in x122.columns if isinstance(c, str) and c[:4].isdigit() and "-" in c[:7]]
na = x122.melt(id_vars=["Current ONS code"], value_vars=yrcols, var_name="fy", value_name="netadd")
na["year"] = na.fy.str[:4].astype(int) + 1
na["netadd"] = num(na["netadd"].astype(object))
na["code"] = na["Current ONS code"].map(to2023)
na = na.groupby(["code", "year"]).netadd.sum(min_count=1).reset_index()
log("- Net additional dwellings (Live Table 122), financial year ending March t assigned to year t.")

# Vacant dwellings (Live Table 615), October count
x615 = pd.read_excel(os.path.join(RAW, "Live_Table_615.ods"), engine="odf", sheet_name="All_vacants", header=2)
x615 = x615[x615["ONS code"].apply(is_english_lad)]
vc = x615.melt(id_vars=["ONS code"], var_name="d", value_name="vacant")
vc["year"] = pd.to_datetime(vc.d.astype(str).str[:10], dayfirst=True, errors="coerce").dt.year
vc = vc.dropna(subset=["year"])
vc["year"] = vc.year.astype(int)
vc["vacant"] = num(vc.vacant.astype(object))
vc["code"] = vc["ONS code"].map(to2023)
vc = vc.groupby(["code", "year"]).vacant.sum(min_count=1).reset_index()
log("- Vacant dwellings (Live Table 615, council-tax base, October snapshot).")

# Private enterprise completions (Live Table 253): crowd-out test
x253 = pd.ExcelFile(os.path.join(RAW, "LiveTable253.ods"), engine="odf")
pe = []
for sh in [n for n in x253.sheet_names if n.startswith("FY_")]:
    fy_end = int(sh[3:7]) + 1
    if fy_end < 2010:
        continue
    d = pd.read_excel(x253, sheet_name=sh, header=3)
    d = d[d["Current ONS code"].apply(is_english_lad)]
    pcol = [c for c in d.columns if str(c).startswith("Private Enterprise Comp")][0]
    pe.append(pd.DataFrame({"code": d["Current ONS code"].map(to2023), "year": fy_end,
                            "priv_compl": num(d[pcol].astype(object))}))
pe = pd.concat(pe).groupby(["code", "year"]).priv_compl.sum(min_count=1).reset_index()
log("- Private-enterprise housing completions (Live Table 253), financial year ending March t -> year t.")

# House prices (UK HPI), annual mean of monthly average price
hp = pd.read_csv(os.path.join(RAW, "UKHPI_average_prices_2026-07.csv"))
hp = hp[hp.Area_Code.apply(is_english_lad)].copy()
hp["year"] = pd.to_datetime(hp.Date).dt.year
hp = hp[hp.year.between(2010, 2025)].groupby(["Area_Code", "year"]).Average_Price.mean().reset_index()
hp["code"] = hp.Area_Code.map(to2023)
hp = hp.groupby(["code", "year"]).Average_Price.mean().rename("hpi_price").reset_index()
log("- House prices: HM Land Registry UK HPI average price, annual mean (alternative outcome).")

# =============================================================================
# 5. Time-invariant moderators (RQ3-4)
# =============================================================================
log("\n## 5. Baseline moderators")
c11 = pd.read_csv(os.path.join(RAW, "nomis_census2011_tenure_lad.csv"))
c11["code"] = c11.GEOGRAPHY_CODE.map(to2023)
c11 = c11.pivot_table(index="code", columns="CELL_NAME", values="OBS_VALUE", aggfunc="sum")
mod = pd.DataFrame({"prs_share11": c11["Private rented"] / c11["All households"] * 100,
                    "soc_hh_share11": c11["Social rented"] / c11["All households"] * 100})
log("- Private-rented share of households, Census 2011 (KS402EW), aggregated to 2023 LADs.")
c21 = pd.read_csv(os.path.join(RAW, "nomis_census2021_tenure_lad.csv"))
c21 = c21.pivot_table(index="GEOGRAPHY_CODE", columns="C2021_TENURE_9_NAME", values="OBS_VALUE")
c21.index = c21.index.map(to2023)
c21 = c21.groupby(level=0).sum()
mod = mod.join((c21["Social rented"] / c21["Total: All households"] * 100).rename("soc_hh_share21"), how="left")
log("- Social-rented share of households, Census 2021 (TS054): used to validate the Table 100 stock share and as an"
    " alternative (time-invariant) regime variable in the threshold models.")

# Planning restrictiveness: refusal rate of major residential applications, pre-sample
ps = pd.read_csv(os.path.join(RAW, "PS2_open_data.csv"), header=2, low_memory=False, encoding="latin1")
dcol = [c for c in ps.columns if c.startswith("Total decisions; major dwellings")][0]
rcol = [c for c in ps.columns if c.startswith("Total refused; major dwellings")][0]
ps["qyear"] = ps.Quarter.astype(str).str[:4].astype(int)
ps = ps[ps.LPACD.astype(str).apply(is_english_lad) & (ps.qyear <= 2013)
        & ~ps.LPANM.astype(str).str.contains("National Park|Development Corporation", case=False)]
ps["code"] = ps.LPACD.map(to2023)
ps[dcol] = pd.to_numeric(ps[dcol], errors="coerce")
ps[rcol] = pd.to_numeric(ps[rcol], errors="coerce")
pr = ps.groupby("code")[[dcol, rcol]].sum()
mod["refusal_major"] = pr[rcol] / pr[dcol] * 100
mod["n_major_dec"] = pr[dcol]
log("- Supply restrictiveness: share of major residential (10+ dwellings) planning applications refused,"
    " all quarters 1979Q2-2013Q4 (pre-sample, following Hilber & Vermeulen 2016). Only ONS-coded (E-) planning"
    " authorities are used; national park authorities and development corporations are excluded. For 2009"
    " unitary authorities the window therefore starts in 2009.")

# Within-LA concentration of social housing: dissimilarity index across 2021 LSOAs
ls = pd.read_csv(os.path.join(RAW, "nomis_census2021_tenure_lsoa.csv"))
ls = ls[ls.GEOGRAPHY_CODE.str.startswith("E01")]
ls = ls.pivot_table(index=["GEOGRAPHY_CODE", "GEOGRAPHY_NAME"], columns="C2021_TENURE_9", values="OBS_VALUE").reset_index()
ls.columns = ["lsoa", "lsoa_name", "hh", "soc"]
ls["lad22_name"] = ls.lsoa_name.str.rsplit(" ", n=1).str[0]
l22 = pd.read_csv(os.path.join(RAW, "nomis_census2021_lad22_names.csv"))
l22 = l22[l22.GEOGRAPHY_CODE.str.startswith("E")]
name2code = dict(zip(l22.GEOGRAPHY_NAME, l22.GEOGRAPHY_CODE))
# LSOA names use the short form of three district names
name2code.update({"Bristol": name2code["Bristol, City of"], "Herefordshire": name2code["Herefordshire, County of"],
                  "Kingston upon Hull": name2code["Kingston upon Hull, City of"]})
ls["code"] = ls.lad22_name.map(name2code).map(lambda c: to2023(c) if isinstance(c, str) else c)
log(f"- LSOAs not matched to a district by name: {ls.code.isna().sum()} of {len(ls)}.")
ls = ls.dropna(subset=["code"])
ls["non"] = ls.hh - ls.soc
tot = ls.groupby("code")[["soc", "non"]].transform("sum")
ls["dpart"] = (ls.soc / tot.soc - ls.non / tot.non).abs()
mod["dissim21"] = ls.groupby("code").dpart.sum() / 2 * 100
log("- Concentration: Duncan dissimilarity index (0-100) between social-renting and other households across"
    " 2021 LSOAs within each LAD (Census 2021 TS054). Higher = social housing more spatially concentrated.")

# Price proximity / openness: Affordable Rent share of new social rental completions, 2012-13 to 2024-25
f2 = fl[fl.year >= 2013].groupby("code")[["sr_nb", "ar_nb", "rent_aq", "ir_nb"]].sum()
mod["ar_share_new"] = f2.ar_nb / (f2.sr_nb + f2.ar_nb).replace(0, np.nan) * 100
log("- Price proximity: Affordable Rent (set at up to 80% of local market rent, introduced 2011) as % of new-build"
    " social/affordable rent completions 2012/13-2024/25. A higher share means new sub-market rentals are"
    " closer substitutes for private lettings.")

# Deprivation: IMD 2019 average score, population-weighted over LSOAs (pre-period confounder / moderator)
imd = pd.read_csv(os.path.join(RAW, "IoD2019_File7_all_scores_lsoa.csv"))
imd = imd.rename(columns={"Local Authority District code (2019)": "lad19", "Index of Multiple Deprivation (IMD) Score": "imd",
                          "Income Score (rate)": "inc_dep", "Total population: mid 2015 (excluding prisoners)": "w"})
imd["code"] = imd.lad19.map(to2023)
mod["imd19"] = imd.groupby("code").apply(lambda g: np.average(g.imd, weights=g.w))
mod["income_dep19"] = imd.groupby("code").apply(lambda g: np.average(g.inc_dep, weights=g.w)) * 100
log("- Deprivation: English Indices of Deprivation 2019, IMD score and income-deprivation rate averaged over LSOAs"
    " weighted by 2015 population, aggregated to 2023 LADs.")
# Land area (km2) from LAD 2023 boundaries (ultra-generalised; adequate for log density)
import geopandas as gpd
gg = gpd.read_file(os.path.join(RAW, "lad23_buc.geojson"))
gg["code"] = gg.LAD23CD.map(to2023)
mod["area_km2"] = gg.set_index("code").geometry.area / 1e6
log("- Land area from LAD Dec-2023 ultra-generalised boundaries (BNG), used for population density.")

# Waiting lists (mechanism context)
x600 = pd.read_excel(os.path.join(RAW, "Live_Table_600.ods"), engine="odf", sheet_name="Local_Authority_Data", header=3)
x600 = x600.rename(columns={x600.columns[0]: "code_orig"})
x600 = x600[x600.code_orig.apply(is_english_lad)]
ycols = [c for c in x600.columns if str(c).replace(".0", "").isdigit()]
wl = x600.melt(id_vars=["code_orig"], value_vars=ycols, var_name="year", value_name="waitlist")
wl["year"] = wl.year.astype(float).astype(int)
wl["waitlist"] = num(wl.waitlist.astype(object))
wl["code"] = wl.code_orig.map(to2023)
wl = wl.groupby(["code", "year"]).waitlist.sum(min_count=1).reset_index()
log("- Housing waiting lists (Live Table 600), households on LA registers at 1 April (mechanism outcome).")

# =============================================================================
# 6. Assemble panel
# =============================================================================
log("\n## 6. Panel assembly")
yrs = range(2010, 2026)
codes = sorted(set(rent.code))
P = pd.MultiIndex.from_product([codes, yrs], names=["code", "year"]).to_frame(index=False)
P = P.merge(rent, on=["code", "year"], how="left")
P = P.merge(st, on=["code", "year"], how="left")
P = P.merge(fl, on=["code", "year"], how="left")
P = P.merge(rtb, on=["code", "year"], how="left")
for df in (pop, pay, un, na, vc, hp, wl, pe):
    P = P.merge(df, on=["code", "year"], how="left")
for c in ["sr_nb", "ar_nb", "rent_aq", "ir_nb", "own", "other", "rtb_sales"]:
    P[c] = P[c].fillna(0)
P["name"] = P.groupby("code").name.transform("first")
P["region"] = P.groupby("code").region.transform("first")
P = P.sort_values(["code", "year"])
g = P.groupby("code")
P["pay_imputed"] = P.pay.isna().astype(int)
P["pay"] = g.pay.transform(lambda s: s.interpolate(limit_direction="both"))
# lagged stock (31 March t-1) and derived variables
P["sh_share_l1"] = g.sh_share.shift(1)
P["la_share_l1"] = g.la_share.shift(1)
P["prp_share_l1"] = g.prp_share.shift(1)
P["tot_stock_l1"] = g.tot_stock.shift(1)
den = P.tot_stock_l1 / 1000
P["soc_nb_pk"] = (P.sr_nb + P.ar_nb) / den          # social+affordable rent new build per 1,000 dwellings
P["sr_nb_pk"] = P.sr_nb / den
P["ar_nb_pk"] = P.ar_nb / den
P["aq_pk"] = P.rent_aq / den                         # rental acquisitions per 1,000 dwellings
P["rtb_pk"] = P.rtb_sales / den                      # Right to Buy sales per 1,000 dwellings
P["own_pk"] = P.own / den
P["netadd_pk"] = P.netadd / den
P["vac_rate"] = P.vacant / P.tot_stock * 100
P["vac_rate_l1"] = g.vac_rate.shift(1)
P["dlnpop"] = g["pop"].transform(lambda s: np.log(s).diff() * 100)
P["dlnpay"] = g["pay"].transform(lambda s: np.log(s).diff() * 100)
P["dlnhp"] = g["hpi_price"].transform(lambda s: np.log(s).diff() * 100)
P["dlnwait"] = g["waitlist"].transform(lambda s: np.log(s.where(s > 0)).diff() * 100)
P["dsh"] = g.sh_share.diff()
# Controls enter with a one-year lag: (i) predetermined w.r.t. rent shocks in t, (ii) 2025 population and
# earnings estimates are not yet published, so contemporaneous controls would drop the final year.
g = P.groupby("code")
for c in ["dlnpop", "dlnpay", "unemp", "netadd_pk", "dlnhp"]:
    P[c + "_l1"] = g[c].shift(1)
P["priv_compl_pk"] = P.priv_compl / den

# Shift-share ("Bartik") predictor of social rental new-build completions:
# LA share of national social+affordable rent new build in FY2010/11-2013/14 (pre-sample) x leave-one-out
# national completions in year t, scaled by the LA's lagged dwelling stock.
pre = P[P.year.between(2011, 2014)].groupby("code")[["sr_nb", "ar_nb"]].sum().sum(axis=1)
s_i = pre / pre.sum()
nat = (P.sr_nb + P.ar_nb).groupby(P.year).sum()
P["ss_share_pre"] = P.code.map(s_i)
P["nat_loo"] = P.year.map(nat) - (P.sr_nb + P.ar_nb)
P["bartik_pk"] = P.ss_share_pre * P.nat_loo / den
log("- Shift-share instrument: pre-period (FY2010/11-2013/14) LA share of national social/affordable-rent new"
    " build x leave-one-out national completions in t, per 1,000 lagged dwellings.")

# Event definition: first 'large completion pulse' (>= 3 social/affordable rent new-build completions per 1,000
# dwellings in a financial year, ~ top 6% of LA-years) between 2012 and 2025.
pulse = P[(P.year.between(2012, 2025)) & (P.soc_nb_pk >= 3)].groupby("code").year.min()
P["event_year"] = P.code.map(pulse)
log(f"- Event: first FY with >=3 social/affordable-rent new-build completions per 1,000 dwellings, 2012-2025."
    f" LAs ever treated: {pulse.notna().sum()}; first-treated before 2017 (no clean pre-period in the rent data,"
    f" excluded from the event study): {(pulse < 2017).sum()}; treated 2017-2025: {(pulse >= 2017).sum()};"
    f" never treated: {P.code.nunique() - pulse.notna().sum()}.")

P = P.merge(mod, left_on="code", right_index=True, how="left")
# baseline (2014) values for heterogeneity
base = P[P.year == 2014].set_index("code")
P["sh_share_2014"] = P.code.map(base.sh_share)
P["vac_rate_2014"] = P.code.map(base.vac_rate)
P["ln_rentlvl_2015"] = P.code.map(P[P.year == 2015].set_index("code").rentlvl_all.pipe(np.log))
P["london"] = (P.region == "London").astype(int)
P["ln_density"] = np.log(P["pop"] / P.area_km2)
P["ln_density"] = P.groupby("code").ln_density.transform(lambda s: s.ffill())   # 2025 pop not yet published
P["ln_pay"] = np.log(P.pay)
P["council_share_soc"] = P.la_stock / P.soc_stock * 100   # council-owned % of social stock
P["ln_rentlvl"] = np.log(P.rentlvl_all)
P["ln_rentlvl_b2"] = np.log(P.rentlvl_b2)
P["rent_to_pay"] = P.rentlvl_all * 12 / P.pay * 100      # annual average rent as % of median FT earnings
for c in ["ln_density", "ln_pay", "council_share_soc", "ln_rentlvl"]:
    P[c + "_l1"] = P.groupby("code")[c].shift(1)

v = P[P.year == 2021][["code", "sh_share", "soc_hh_share21"]].dropna()
dv = (v.sh_share - v.soc_hh_share21)
log(f"- Validation (2021): correlation of Table 100 SH share with Census 2021 social-rented household share ="
    f" {np.corrcoef(v.sh_share, v.soc_hh_share21)[0, 1]:.3f}; mean difference {dv.mean():.2f} pp (dwellings vs households and"
    f" differences in how housing-association stock is attributed to LAs). Largest negative gaps:"
    f" {', '.join(P[P.year == 2021].set_index('code').loc[dv.sort_values().index[:4].map(lambda i: v.loc[i, 'code']), 'name'])}"
    f" ({', '.join(f'{x:.1f}' for x in dv.sort_values().values[:4])} pp). Threshold models are re-estimated with the Census"
    f" measure as regime variable (Appendix Table C1).")
P.to_csv(os.path.join(CLEAN, "panel_la_year_2010_2025.csv"), index=False)
A = P[P.year.between(2016, 2025)].copy()
need = ["dlnrent_all", "sh_share_l1", "dlnpop_l1", "dlnpay_l1", "unemp_l1", "netadd_pk_l1"]
nmiss = A[need].isna().sum()
log(f"- Full panel: {P.code.nunique()} LADs x {P.year.nunique()} years (2010-2025) = {len(P)} rows.")
log(f"- Estimation window 2016-2025: {len(A)} LA-years. Missing in key variables: {nmiss.to_dict()}")
A = A.dropna(subset=need)
A.to_csv(os.path.join(CLEAN, "analysis_2016_2025.csv"), index=False)
log(f"- Analysis sample after dropping missing key variables: {len(A)} LA-years, {A.code.nunique()} LADs.")

# VOA/ONS Private Rental Market Statistics: direct LA median monthly rents by bedroom, 12 months to Sept
log("\n## 8. Private Rental Market Statistics (VOA/ONS), competition test")
import glob
TABMAP = {"2.2": "studio", "2.3": "b1", "2.4": "b2", "2.5": "b3", "2.6": "b4", "2.7": "all"}
rows = []
for fpath in sorted(glob.glob(os.path.join(RAW, "prms", "prms_*"))):
    yr = int(os.path.basename(fpath)[5:9])
    xx = pd.ExcelFile(fpath)
    for sh in xx.sheet_names:
        key = sh.replace(" ", "").replace("Table", "")
        if key not in TABMAP:
            continue
        d = pd.read_excel(xx, sheet_name=sh, header=None)
        hr = d.index[d.apply(lambda r: r.astype(str).str.strip().eq("Median").any(), axis=1)][0]
        hdr = d.iloc[hr].astype(str).str.strip()
        ccode = max(range(d.shape[1]), key=lambda j: d.iloc[hr + 1:, j].apply(is_english_lad).sum())
        cmed = hdr[hdr == "Median"].index[0]
        ccnt = hdr[hdr.str.contains("Count", case=False)].index[0]
        dd = d.iloc[hr + 1:]
        dd = dd[dd.iloc[:, ccode].apply(is_english_lad)]
        rows.append(pd.DataFrame({"code_orig": dd.iloc[:, ccode].astype(str).str.strip(), "year": yr,
                                  "seg": TABMAP[key], "median": num(dd.iloc[:, cmed].astype(object)),
                                  "count": num(dd.iloc[:, ccnt].astype(object))}))
pr = pd.concat(rows)
pr["code"] = pr.code_orig.map(to2023)
pr = pr.dropna(subset=["median", "count"])
# merged LAs: count-weighted mean of predecessor medians (approximation)
pr = pr.groupby(["code", "year", "seg"]).apply(
    lambda g: pd.Series({"median": np.average(g["median"], weights=g["count"]), "count": g["count"].sum()})).reset_index()
pw = pr.pivot_table(index=["code", "year"], columns="seg", values=["median", "count"])
pw.columns = [f"prms_{a}_{b}" for a, b in pw.columns]
pw = pw.reset_index().sort_values(["code", "year"])
for sg in TABMAP.values():
    pw[f"dlnprms_{sg}"] = pw.groupby("code")[f"prms_median_{sg}"].transform(lambda v: np.log(v).diff() * 100)
    pw.loc[pw.groupby("code").year.diff() != 1, f"dlnprms_{sg}"] = np.nan
pw.to_csv(os.path.join(CLEAN, "prms_la_bedroom_2014_2023.csv"), index=False)
log(f"- 10 annual releases (12 months to September 2014 ... 2023), LA x bedroom medians and counts;"
    f" {pw.code.nunique()} LADs. Cells with suppressed medians ('..', fewer than ~10 lettings) are missing."
    f" Merged LADs use count-weighted means of predecessor medians. Growth = 100 x diff ln(median)."
    f" These are direct (unmodelled) estimates of new lettings, noisier than PIPR but segment-specific.")

# CORE: previous housing situation of new social tenants (national, by letting type), mechanism context
core = pd.read_excel(os.path.join(RAW, "CORE_tenants_summary_2024-25.ods"), engine="odf", sheet_name="Table_3gi", header=4)
core = core.rename(columns={core.columns[0]: "fy", core.columns[1]: "prev"})
core = core[core.fy.astype(str).str.match(r"^\d{4}/\d{2}$")]
core.columns = [str(c).split(" [")[0] for c in core.columns]
core.to_csv(os.path.join(CLEAN, "core_previous_tenure_national.csv"), index=False)
log("\n## 7. CORE lettings (national)")
log("- Previous housing situation of lead tenants of new social lettings, % of lettings, by letting type,"
    " 2004/05-2024/25 (Table 3gi). LA-level CORE microdata are not openly published (UK Data Service), so the"
    " displacement channel is examined with national shares plus LA-level waiting-list responses.")

# Composition of new dwellings by bedrooms and tenure, England (Live Table 254b): motivates segment tests
b = pd.read_excel(os.path.join(RAW, "LiveTable254.ods"), engine="odf", sheet_name="LT_254b", header=3)
b = b[b["ONS code"] == "E92000001"]
fys = [c for c in b.columns if isinstance(c, str) and c[:4].isdigit() and 2016 <= int(c[:4]) + 1 <= 2025]
b["mean_2016_2025"] = b[fys].apply(pd.to_numeric, errors="coerce").mean(axis=1)
b[["Tenure", "Property type", "Bedrooms", "mean_2016_2025"]].to_csv(os.path.join(CLEAN, "completions_bedroom_mix_england.csv"), index=False)
log("- Bedroom/property-type mix of completions by tenure, England, mean of FY2015/16-2024/25 (Live Table 254b).")

with open(os.path.join(DOCS, "cleaning_log.md"), "w") as f:
    f.write("# Data cleaning log (auto-generated by code/02_clean.py)\n\n" + "\n".join(LOG) + "\n")
