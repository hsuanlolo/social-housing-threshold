"""
01_download.py
Download every raw input used in the paper into data/raw/.
All sources are public (Open Government Licence). URLs are pinned to the
releases used for the paper (accessed October 2026) so results are reproducible.
Re-running overwrites files in data/raw/.
"""
import os
import time
import requests

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RAW = os.path.join(ROOT, "data", "raw")
os.makedirs(RAW, exist_ok=True)
UA = {"User-Agent": "Mozilla/5.0 (academic research)"}

GOVUK = "https://assets.publishing.service.gov.uk/media/"
FILES = {
    # --- Dwelling stock by tenure (MHCLG live tables) -------------------------
    "LiveTable100.ods": GOVUK + "6a0dcbb05c3c79da61662e38/LiveTable100.ods",          # stock by tenure x LA, 2009-2025
    "LiveTable125.ods": GOVUK + "6a0dcbf65c3c79da61662e39/LiveTable125.ods",          # total stock x LA
    "Live_Table_115.ods": GOVUK + "6913374dd7081798fa18ad7c/Live_Table_115.ods",      # PRP stock x LA
    "Live_Table_116.ods": GOVUK + "6a2bf3b215f2a70fac7e5e9f/Live_Table_116.ods",      # LA stock x LA since 1979
    "Live_Table_615.ods": GOVUK + "6a2bf816e50716856ed4afdd/Live_Table_615.ods",      # vacant dwellings x LA
    "Live_Table_122.ods": GOVUK + "691f39aa9c8e8f345bf985d4/Live_Table_122.ods",      # net additional dwellings x LA
    "LiveTable254.ods": GOVUK + "6ab3e2a1fceb6fb3a65010cd/LiveTable254.ods",          # completions by bedrooms x tenure
    "LiveTable253.ods": GOVUK + "6ab3e288734e2435f202ef4e/LiveTable253.ods",          # starts/completions by tenure x LA
    "Live_Table_600.ods": GOVUK + "6a2be263e50716856ed4afc4/Live_Table_600.ods",      # housing waiting lists x LA
    "Live_Table_702.xlsx": GOVUK + "682c2f5c02662c6f8ec24475/Live_Table_702.xlsx",    # LA social rents x LA
    "Live_Table_704.xlsx": GOVUK + "682c2f658999f671f3c24443/Live_Table_704.xlsx",    # PRP social rents x LA
    # --- Flows: affordable supply, Right to Buy, sales ------------------------
    "AHS_open_data.csv": GOVUK + "6a392a2325c5199bda117906/AHS_199192_to_202425_open_data.csv",
    "AHS_data_dictionary.docx": GOVUK + "6911e008bda892e068aa6414/Data_dictionary_for_AHS_open_data_202425.docx",
    "RTB_sales_open_data.csv": GOVUK + "6a703ce18319ab05f7caa304/Right_to_Buy_sales_open_data.csv",
    "SHSD_open_data.csv": GOVUK + "6a2c1dcb1f6fa5c3377e5eac/SHSD_Open_Data_1980_2025.csv",
    # --- Planning (supply-restrictiveness moderator) ---------------------------
    "PS2_open_data.csv": GOVUK + "6ab2813aa9c3d267bcccecfc/PS2_data_-_open_data_table__202606_.csv",
    # --- CORE lettings (national summary tables; LA microdata not public) -----
    "CORE_tenants_summary_2024-25.ods": GOVUK + "69148e7beba5bda2026fc845/Social_Housing_Lettings_in_England__Tenants_Summary_Tables__2024-25.ods",
    "CORE_tenancies_summary_2024-25.ods": GOVUK + "69147610eba5bda2026fc827/Social_Housing_Lettings_in_England__Tenancies_Summary_Tables__2024-25.ods",
    # --- Rents and prices -------------------------------------------------------
    "PIPR_202609.xlsx": "https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/"
                        "priceindexofprivaterentsukmonthlypricestatistics/16september2026/"
                        "priceindexofprivaterentsukmonthlypricestatistics.xlsx",
    "ONS_subnational_dwellings_by_tenure_2024.xlsx": "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/"
                        "housing/datasets/subnationaldwellingstockbytenureestimates/current/subnationaldwellingsbytenure2024.xlsx",
    # English Indices of Deprivation 2019, LSOA scores with population denominators
    "IoD2019_File7_all_scores_lsoa.csv": GOVUK + "5dc407b440f0b6379a7acc8d/"
                        "File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators_3.csv",
    # LAD Dec-2023 boundaries (ultra-generalised, British National Grid) for maps and contiguity weights
    "lad23_buc.geojson": "https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/"
                        "Local_Authority_Districts_December_2023_Boundaries_UK_BUC/FeatureServer/0/query?"
                        "where=1%3D1&outFields=LAD23CD,LAD23NM&outSR=27700&f=geojson",
    "UKHPI_average_prices_2026-07.csv": "https://publicdata.landregistry.gov.uk/market-trend-data/"
                        "house-price-index-data/Average-prices-2026-07.csv",
}

# VOA / ONS Private Rental Market Statistics (direct LA medians by bedroom, 12 months to September)
ONSF = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/housing/datasets/privaterentalmarketsummarystatisticsinengland/"
PRMS = {
    "prms_2014_09.xls": GOVUK + "5a7d605240f0b60aaa2940ce/141211_Publication_AllTables.xls",
    "prms_2015_09.xls": GOVUK + "5a80e60c40f0b62305b8dc57/151210_Publication_AllTables.xls",
    "prms_2016_09.xls": GOVUK + "5a81675de5274a2e87dbd717/Publication_AllTables_17112016.xls",
    "prms_2017_09.xls": GOVUK + "5a82a1a8e5274a2e8ab58889/Publication_AllTables_14122017.xls",
    "prms_2018_09.xls": GOVUK + "5c0f949040f0b60c70c4b9f4/Publication_AllTables_13122018.xls",
    "prms_2019_09.xls": ONSF + "october2018toseptember2019/privaterentalmarketstatistics13122019.xls",
    "prms_2020_09.xls": ONSF + "october2019toseptember2020/privaterentalmarketstatistics11122020.xls",
    "prms_2021_09.xls": ONSF + "october2020toseptember2021/privaterentalmarketstatistics211215.xls",
    "prms_2022_09.xlsx": ONSF + "october2021toseptember2022/privaterentalmarketstatistics221214.xlsx",
    "prms_2023_09.xls": ONSF + "october2022toseptember2023/privaterentalmarketstatistics231220.xls",
}

NOMIS = "https://www.nomisweb.co.uk/api/v01/dataset/"
NOMIS_QUERIES = {
    # Mid-year population estimates, all ages, 2023 LAD geography (Nomis re-bases history)
    "nomis_population.csv": NOMIS + "NM_2002_1.data.csv?geography=TYPE424&date=2010-2024"
        "&gender=0&c_age=200&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    # ASHE resident analysis: median gross annual pay, full-time workers
    "nomis_ashe_median_ft_pay.csv": NOMIS + "NM_30_1.data.csv?geography=TYPE424&date=2010-2025"
        "&sex=8&item=2&pay=7&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    # Model-based unemployment rate (APS), 12 months to Dec
    "nomis_unemployment.csv": NOMIS + "NM_127_1.data.csv?geography=TYPE424&date=2010-12,2011-12,2012-12,"
        "2013-12,2014-12,2015-12,2016-12,2017-12,2018-12,2019-12,2020-12,2021-12,2022-12,2023-12,2024-12,2025-12"
        "&item=2&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    # Same three series on April-2019 LAD geography: used to back-fill 2023 unitaries / re-coded districts
    # for years in which Nomis does not publish them on the 2023 geography
    "nomis_population_lad19.csv": NOMIS + "NM_2002_1.data.csv?geography=TYPE434&date=2010-2024"
        "&gender=0&c_age=200&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    "nomis_ashe_median_ft_pay_lad19.csv": NOMIS + "NM_30_1.data.csv?geography=TYPE434&date=2010-2025"
        "&sex=8&item=2&pay=7&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    "nomis_unemployment_lad19.csv": NOMIS + "NM_127_1.data.csv?geography=TYPE434&date=2010-12,2011-12,2012-12,"
        "2013-12,2014-12,2015-12,2016-12,2017-12,2018-12,2019-12,2020-12,2021-12,2022-12,2023-12,2024-12,2025-12"
        "&item=2&measures=20100&select=date_name,geography_code,geography_name,obs_value",
    # Census 2021 TS054 tenure, households, 2023 LAD
    "nomis_census2021_tenure_lad.csv": NOMIS + "NM_2072_1.data.csv?geography=TYPE424&c2021_tenure_9=0,1001,1003,4,5,1004"
        "&measures=20100&select=geography_code,geography_name,c2021_tenure_9_name,obs_value",
    # Census 2011 KS402EW tenure, households, pre-2015 LAD (re-aggregated in 02_clean)
    "nomis_census2011_tenure_lad.csv": NOMIS + "NM_619_1.data.csv?geography=TYPE464&rural_urban=0&cell=0,200,4,5,300"
        "&measures=20100&select=geography_code,geography_name,cell_name,obs_value",
    # 2022 LAD names/codes (used to attach 2021 LSOAs to districts via LSOA names)
    "nomis_census2021_lad22_names.csv": NOMIS + "NM_2072_1.data.csv?geography=TYPE154&c2021_tenure_9=0"
        "&measures=20100&select=geography_code,geography_name,obs_value",
}
# Census 2021 tenure at LSOA level (for within-LA concentration index); paged (25k cell limit)
LSOA_URL = (NOMIS + "NM_2072_1.data.csv?geography=TYPE151&c2021_tenure_9=0,1003"
            "&measures=20100&select=geography_code,geography_name,c2021_tenure_9,obs_value")


def get(url, path):
    for attempt in range(4):
        try:
            r = requests.get(url, headers=UA, timeout=180)
            r.raise_for_status()
            with open(path, "wb") as f:
                f.write(r.content)
            print(f"ok  {os.path.basename(path):55s} {len(r.content):>12,d} bytes")
            return
        except Exception as e:  # noqa: BLE001
            print(f"retry {attempt+1} {path}: {e}")
            time.sleep(5)
    raise RuntimeError(f"failed: {url}")


if __name__ == "__main__":
    for fn, url in FILES.items():
        get(url, os.path.join(RAW, fn))
    os.makedirs(os.path.join(RAW, "prms"), exist_ok=True)
    for fn, url in PRMS.items():
        get(url, os.path.join(RAW, "prms", fn))
    for fn, url in NOMIS_QUERIES.items():
        get(url, os.path.join(RAW, fn))
    # LSOA tenure, paged
    out = os.path.join(RAW, "nomis_census2021_tenure_lsoa.csv")
    with open(out, "w") as fo:
        offset, first = 0, True
        while True:
            r = requests.get(LSOA_URL + f"&recordoffset={offset}", headers=UA, timeout=180)
            r.raise_for_status()
            lines = r.text.strip().splitlines()
            body = lines if first else lines[1:]
            if (not first) and len(body) == 0:
                break
            fo.write("\n".join(body) + "\n")
            n = len(lines) - 1
            first = False
            offset += 25000
            if n < 25000:
                break
    print("ok  nomis_census2021_tenure_lsoa.csv")
