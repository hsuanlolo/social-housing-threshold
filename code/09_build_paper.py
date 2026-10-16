"""09_build_paper.py -- assemble paper/manuscript.md + generated tables/figures into paper/manuscript_full.md
and paper/manuscript.docx (pandoc)."""
import os, re, subprocess
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MD = os.path.join(ROOT, "output", "tables", "md")
CAP = {
    "table1": "Table 1. Descriptive statistics",
    "table2": "Table 2. Social housing share and private rents (coefficient on the lagged SH share)",
    "table3": "Table 3. Private rents by social housing share interval",
    "table4": "Table 4. Threshold, kink and linearity tests",
    "table5": "Table 5. Rent growth and changes in social housing, by share interval",
    "table6": "Table 6. Decomposition of the share-rent association",
    "table7": "Table 7. The share-rent relationship by market context",
    "tableC1": "Table C1. Robustness to alternative measures and samples",
    "tableD1": "Table D1. Diagnostics for causal designs",
}
src = open(os.path.join(ROOT, "paper", "manuscript.md")).read()

def table(m):
    name = m.group(1)
    p = os.path.join(MD, name + ".md")
    if not os.path.exists(p):
        return f"*[{name} not yet generated]*"
    body = open(p).read().strip()
    return f"**{CAP.get(name, name)}**\n\n{body}\n"

def fig(m):
    f, cap = m.group(1).split("|", 1)
    return f"![{cap}](../output/figures/{f}){{width=100%}}\n"

def textblock(m):
    p = os.path.join(ROOT, "paper", m.group(1).lower() + ".md")
    return open(p).read().strip() if os.path.exists(p) else f"*[{m.group(1)} pending]*"

out = re.sub(r"\{\{TABLE:([A-Za-z0-9_]+)\}\}", table, src)
out = re.sub(r"\{\{FIG:([^}]+)\}\}", fig, out)
out = re.sub(r"\{\{(RQ3_TEXT|RQ4_TEXT)\}\}", textblock, out)
out = re.sub(r"\{\{TABLE:([A-Za-z0-9_]+)\}\}", table, out)  # tables referenced inside text blocks
out = out.replace("{{TABLE_SOURCES}}", "**Table A1. Data sources**\n\n" + open(os.path.join(ROOT, "docs", "data_sources.md")).read())
log = open(os.path.join(ROOT, "docs", "cleaning_log.md")).read().split("\n", 1)[1]
log = re.sub(r"^## ", "#### ", log, flags=re.M)
out = out.replace("{{CLEANING_LOG}}", log)
full = os.path.join(ROOT, "paper", "manuscript_full.md")
open(full, "w").write(out)
docx_src = out.replace("<br>", " ")
tmp = os.path.join(ROOT, "paper", "_docx_src.md")
open(tmp, "w").write(docx_src)
subprocess.run(["pandoc", tmp, "-o", os.path.join(ROOT, "paper", "manuscript.docx"), "--resource-path",
                os.path.join(ROOT, "paper"), "--mathml"], check=True, cwd=os.path.join(ROOT, "paper"))
os.remove(tmp)
words = len(re.sub(r"\|.*\|", "", open(os.path.join(ROOT, "paper", "manuscript.md")).read().split("# References")[0]).split())
print("built paper/manuscript_full.md and paper/manuscript.docx; main-text words ~", words)
