#!/usr/bin/env bash
# Reproduce every number, table and figure in the paper (v2). Run from the project root.
set -euo pipefail
python3 code/01_download.py                 # raw public data -> data/raw
python3 code/02_clean.py                    # LA-year panel + docs/cleaning_log.md
python3 code/02b_map.py                     # Figure 1
Rscript code/10_rq1_relationship.R          # RQ1: share-rent relationship (Table 2, Figure 2)
Rscript code/11_rq2_thresholds.R            # RQ2: intervals, splines, thresholds, flows by interval (Tables 3-5, Figures 3-5)
NBOOT=299 Rscript code/12_rq3_why.R         # RQ3: decomposition, moderators, power (Tables 6-7) ~25 min
Rscript code/15_rq3_figures.R               # Figures 6-7
NBOOT=299 Rscript code/14_robustness.R      # Appendix Table C1
Rscript code/16_appendixD_identification.R # Appendix D: why no causal design (event study, instrument)
python3 code/13_tables.py                   # Markdown tables
python3 code/09_build_paper.py              # paper/manuscript.docx
# Earlier (v1) analyses with causal designs and mechanism extensions are kept in code/archive_v1 (not used).
