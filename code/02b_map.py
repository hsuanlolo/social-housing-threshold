"""02b_map.py -- Figure 1: maps of the social housing share (2025) and average annual private rent growth (2015-2025)."""
import os, sys
import numpy as np
import pandas as pd
import geopandas as gpd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from geo import to2023

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW, CLEAN, FIG = (os.path.join(ROOT, *p) for p in [("data", "raw"), ("data", "clean"), ("output", "figures")])
os.makedirs(FIG, exist_ok=True)
P = pd.read_csv(os.path.join(CLEAN, "panel_la_year_2010_2025.csv"))
g = gpd.read_file(os.path.join(RAW, "lad23_buc.geojson"))
g["LAD23CD"] = g.LAD23CD.map(to2023)  # Dec-2023 file carries the old Barnsley/Sheffield codes
g = g[g.LAD23CD.isin(P.code.unique())]
idx = P.pivot(index="code", columns="year", values="idx_all")
gr = (100 * (np.log(idx[2025]) - np.log(idx[2015])) / 10).rename("cumg")
m = g.merge(P[P.year == 2025][["code", "sh_share"]], left_on="LAD23CD", right_on="code").merge(gr, left_on="code", right_index=True)
fig, ax = plt.subplots(1, 2, figsize=(10, 6.2))
for a, col, cmap, ttl in [(ax[0], "sh_share", "Blues", "SH share 2025 (%)"), (ax[1], "cumg", "Oranges", "Rent growth 2015-25 (%/yr)")]:
    _, bins = pd.qcut(m[col], 5, retbins=True)
    labs = [f"{bins[i]:.1f} - {bins[i+1]:.1f}" for i in range(5)]
    m["_cls"] = pd.qcut(m[col], 5, labels=labs)
    m.plot(column="_cls", cmap=cmap, categorical=True, legend=True, ax=a, edgecolor="white", linewidth=0.15,
           legend_kwds={"title": ttl, "fontsize": 7, "title_fontsize": 8, "loc": "upper left"})
for a, t in zip(ax, ["(a) Social housing share of dwelling stock, 2025", "(b) Average annual private rent growth, 2015-2025"]):
    a.set_axis_off(); a.set_title(t, fontsize=9)
plt.tight_layout(); fig.savefig(os.path.join(FIG, "fig1_maps.png"), dpi=300)
print("Figure 1 written")
