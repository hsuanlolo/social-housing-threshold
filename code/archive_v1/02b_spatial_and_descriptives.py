"""
02b_spatial_and_descriptives.py
(1) Contiguity weights between 2023 LADs (polygons buffered by 250 m so that generalised boundaries and
    estuary crossings still register as neighbours), row-standardised; spatial lags of flows.
(2) Figure 1 (maps) and Table 1 (descriptive statistics).
(3) LA-level volatility of private rent and house price growth (for the 'stabilisation' outcome).
"""
import os
import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW, CLEAN = os.path.join(ROOT, "data", "raw"), os.path.join(ROOT, "data", "clean")
FIG, TAB = os.path.join(ROOT, "output", "figures"), os.path.join(ROOT, "output", "tables")

P = pd.read_csv(os.path.join(CLEAN, "panel_la_year_2010_2025.csv"))
A = pd.read_csv(os.path.join(CLEAN, "analysis_with_flows.csv"))
g = gpd.read_file(os.path.join(RAW, "lad23_buc.geojson"))
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo import to2023
g["LAD23CD"] = g.LAD23CD.map(to2023)  # Dec-2023 file still carries the old Barnsley/Sheffield codes
g = g[g.LAD23CD.isin(P.code.unique())].reset_index(drop=True)
print("LADs with geometry:", len(g), "of", P.code.nunique())

# --- (1) contiguity ---------------------------------------------------------------
gb = g.copy(); gb["geometry"] = gb.buffer(250)
pairs = gpd.sjoin(gb[["LAD23CD", "geometry"]], gb[["LAD23CD", "geometry"]], predicate="intersects")
pairs = pairs[pairs.LAD23CD_left != pairs.LAD23CD_right][["LAD23CD_left", "LAD23CD_right"]]
pairs.columns = ["code", "nb"]
pairs.to_csv(os.path.join(CLEAN, "lad23_contiguity_pairs.csv"), index=False)
nn = pairs.groupby("code").size()
print("neighbours per LAD: min", nn.min(), "median", nn.median(), "max", nn.max(),
      "| isolates (Isle of Wight; no spatial lag):", sorted(set(g.LAD23CD) - set(nn.index)))
lag = pairs.merge(A[["code", "year", "soc2", "aq2", "rtb2", "sh_share_l1"]].rename(columns={"code": "nb"}), on="nb")
lag = lag.groupby(["code", "year"])[["soc2", "aq2", "rtb2", "sh_share_l1"]].mean().add_prefix("W_").reset_index()
lag.to_csv(os.path.join(CLEAN, "spatial_lags.csv"), index=False)

# --- (2) Figure 1 maps -------------------------------------------------------------
m = g.merge(P[P.year == 2025][["code", "sh_share"]], left_on="LAD23CD", right_on="code")
ld = pd.read_csv(os.path.join(CLEAN, "long_difference_2015_2025.csv"))
m = m.merge(ld[["code", "cumg"]], on="code")
fig, ax = plt.subplots(1, 2, figsize=(10, 6.2))
for a, col, cmap, ttl in [(ax[0], "sh_share", "Blues", "SH share 2025 (%)"), (ax[1], "cumg", "Oranges", "Rent growth 2015-25 (%/yr)")]:
    q, bins = pd.qcut(m[col], 5, retbins=True)  # quintile classes (no mapclassify dependency)
    labs = [f"{bins[i]:.1f} - {bins[i+1]:.1f}" for i in range(5)]
    m["_cls"] = pd.qcut(m[col], 5, labels=labs)
    m.plot(column="_cls", cmap=cmap, categorical=True, legend=True, ax=a, edgecolor="white", linewidth=0.15,
           legend_kwds={"title": ttl, "fontsize": 7, "title_fontsize": 8, "loc": "upper left"})
for a, t in zip(ax, ["(a) Social housing share of dwelling stock, 2025", "(b) Average annual private rent growth, 2015-2025"]):
    a.set_axis_off(); a.set_title(t, fontsize=9)
fig.suptitle("Figure 1. Social housing shares and private rent growth across 294 English local authorities", fontsize=10, fontweight="bold")
plt.tight_layout()
fig.savefig(os.path.join(FIG, "fig1_maps.png"), dpi=300)

# --- Table 1 descriptives --------------------------------------------------------
desc = {
    "dlnrent_all": "Private rent growth, PIPR (% per year)",
    "sh_share_l1": "Social housing share of stock, t-1 (%)",
    "la_share_l1": "  of which council-owned (%)",
    "prp_share_l1": "  of which housing-association-owned (%)",
    "soc_nb_pk": "Social/affordable rent new build per 1,000 dwellings",
    "sr_nb_pk": "  Social Rent new build per 1,000",
    "ar_nb_pk": "  Affordable Rent new build per 1,000",
    "aq_pk": "Rental acquisitions per 1,000 dwellings",
    "rtb_pk": "Right to Buy sales per 1,000 dwellings",
    "dlnpop_l1": "Population growth, t-1 (%)",
    "dlnpay_l1": "Median FT earnings growth, t-1 (%)",
    "unemp_l1": "Unemployment rate, t-1 (%)",
    "netadd_pk_l1": "Net additional dwellings per 1,000, t-1",
    "vac_rate_l1": "Vacancy rate, t-1 (%)",
    "dlnhp": "House price growth, UK HPI (% per year)",
    "prs_share11": "Private-rented share of households, 2011 (%)",
    "refusal_major": "Major residential refusal rate, 1979-2013 (%)",
    "ar_share_new": "Affordable Rent share of new social lets (%)",
    "dissim21": "Dissimilarity index, social vs other households (0-100)",
}
t1 = A[list(desc)].describe(percentiles=[.1, .5, .9]).T[["mean", "std", "10%", "50%", "90%", "min", "max"]]
t1.insert(0, "Variable", [desc[c] for c in t1.index])
t1.round(2).to_csv(os.path.join(TAB, "table1_descriptives.csv"), index=False)
w = A.groupby("code").sh_share_l1
print("within-LA SD of SH share:", round((A.sh_share_l1 - w.transform("mean")).std(), 3),
      "between-LA SD:", round(w.mean().std(), 3))
with open(os.path.join(TAB, "table1_variance_decomp.txt"), "w") as f:
    for v in ["sh_share_l1", "soc_nb_pk", "rtb_pk", "aq_pk", "dlnrent_all"]:
        wi = (A[v] - A.groupby("code")[v].transform("mean")).std(); be = A.groupby("code")[v].mean().std()
        f.write(f"{v}: within SD {wi:.3f}, between SD {be:.3f}\n")

# --- (3) volatility -----------------------------------------------------------------
h = pd.read_csv(os.path.join(RAW, "PIPR_202609_table1.csv"), low_memory=False)
h = h[h.code.isin(P.code.unique())].copy()
h["period"] = pd.to_datetime(h.period); h["yoy"] = pd.to_numeric(h.yoy, errors="coerce")
h = h[(h.period >= "2016-01-01") & (h.period <= "2025-12-01")]
vol = h.groupby("code").yoy.agg(rent_yoy_sd="std", rent_yoy_mean="mean").reset_index()
hp = pd.read_csv(os.path.join(RAW, "UKHPI_average_prices_2026-07.csv"))
hp = hp[hp.Area_Code.isin(P.code.unique())].copy(); hp["Date"] = pd.to_datetime(hp.Date)
hp = hp[(hp.Date >= "2016-01-01") & (hp.Date <= "2025-12-01")]
hv = hp.groupby("Area_Code").Annual_Change.agg(hp_yoy_sd="std", hp_yoy_mean="mean").reset_index().rename(columns={"Area_Code": "code"})
vol = vol.merge(hv, on="code", how="left")
vol.to_csv(os.path.join(CLEAN, "volatility_2016_2025.csv"), index=False)
print("volatility rows", len(vol), vol.isna().sum().to_dict())
