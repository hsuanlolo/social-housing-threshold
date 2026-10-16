# Is There a Social Housing Threshold? Social Housing Market Share and Private Rents across English Local Authorities

Replication package and working draft (not for circulation). The paper asks whether there is a share of social
housing beyond which private rents change, using a panel of all 294 English local authorities (rent levels
2015-2025, rent growth 2016-2025).

## Structure
| Path | Content |
|---|---|
| `paper/manuscript.md` | Manuscript source (tables and figures inserted by `code/09_build_paper.py`) |
| `paper/manuscript.docx`, `paper/manuscript_full.md` | Built manuscript |
| `code/01_download.py` | Downloads all raw inputs (public data, pinned URLs) into `data/raw/` |
| `code/geo.py` | Crosswalk of 2010-2023 English LA codes to April-2023 LADs |
| `code/02_clean.py` | Builds the LA x year panel and writes `docs/cleaning_log.md` |
| `code/02b_map.py` | Figure 1 |
| `code/10_rq1_relationship.R` | RQ1: share-rent relationship (Table 2, Figure 2) |
| `code/11_rq2_thresholds.R` | RQ2: intervals, splines, threshold/kink tests, flows by interval (Tables 3-5, Figures 3-5) |
| `code/12_rq3_why.R`, `code/15_rq3_figures.R` | RQ3: decomposition, moderators, power (Tables 6-7, Figures 6-7) |
| `code/14_robustness.R` | Appendix Table C1 |
| `code/16_appendixD_identification.R` | Appendix D: diagnostics for causal designs |
| `code/threshold_functions.R` | Hansen threshold and kink estimation with wild cluster bootstrap |
| `code/13_tables.py`, `code/09_build_paper.py` | Markdown tables and manuscript assembly |
| `data/clean/` | Analysis panels and auxiliary files |
| `output/tables`, `output/figures` | Model output |
| `docs/` | Cleaning log and data source list |
| `code/archive_v1`, `output/archive_v1`, `paper/archive_v1` | Earlier version (causal designs, mechanisms), not used in the current draft |

`data/raw/` is not tracked; run `python3 code/01_download.py` to recreate it.

## Reproduce
```
./run_all.sh
```
Requires Python 3.8+ (pandas, geopandas, odfpy, matplotlib, requests) and R 4.0+ (data.table, fixest, mgcv, lme4,
ggplot2, MASS), plus pandoc for the docx build.
