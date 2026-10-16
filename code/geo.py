"""Harmonise English local-authority codes to April-2023 LAD boundaries (the PIPR geography).
All English reorganisations 2009-2023 were mergers of whole districts, so old units
aggregate exactly into 2023 units (no areal interpolation needed)."""
OLD2NEW = {
    # 2013 re-codings (no boundary change)
    "E06000048": "E06000057", "E07000100": "E07000240", "E07000104": "E07000241",
    "E07000097": "E07000242", "E07000101": "E07000243", "E08000020": "E08000037",
    # 2019: Bournemouth, Christchurch & Poole; Dorset; East/West Suffolk; Somerset West & Taunton
    "E06000028": "E06000058", "E06000029": "E06000058", "E07000048": "E06000058",
    **{c: "E06000059" for c in ["E07000049", "E07000050", "E07000051", "E07000052", "E07000053"]},
    "E07000201": "E07000245", "E07000204": "E07000245",
    "E07000205": "E07000244", "E07000206": "E07000244",
    # 2020: Buckinghamshire
    **{c: "E06000060" for c in ["E07000004", "E07000005", "E07000006", "E07000007"]},
    # 2021: North / West Northamptonshire
    **{c: "E06000061" for c in ["E07000150", "E07000152", "E07000153", "E07000156"]},
    **{c: "E06000062" for c in ["E07000151", "E07000154", "E07000155"]},
    # 2023: Cumberland; Westmorland & Furness; North Yorkshire; Somerset
    **{c: "E06000063" for c in ["E07000026", "E07000028", "E07000029"]},
    **{c: "E06000064" for c in ["E07000027", "E07000030", "E07000031"]},
    **{c: "E06000065" for c in ["E07000163", "E07000164", "E07000165", "E07000166",
                                  "E07000167", "E07000168", "E07000169"]},
    # 2022/23 re-coding of Barnsley and Sheffield (minor boundary change)
    "E08000016": "E08000038", "E08000019": "E08000039",
    **{c: "E06000066" for c in ["E07000187", "E07000188", "E07000189", "E07000190",
                                  "E07000191", "E07000246"]},
}
# Not covered by PIPR (too few private lettings): dropped from the analysis sample
DROP = {"E09000001", "E06000053"}  # City of London, Isles of Scilly


def to2023(code):
    code = str(code).strip()
    return OLD2NEW.get(code, code)


def is_english_lad(code):
    return isinstance(code, str) and code[:3] in ("E06", "E07", "E08", "E09")
