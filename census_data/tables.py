"""
Table configurations for census-data-downloader

See
https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/core/tables.py
and modules in
https://github.com/datadesk/census-data-downloader/tree/master/census_data_downloader/tables

"""

import collections

from census_data_downloader.core.tables import BaseTableConfig
from census_data_downloader.core.decorators import register
import numpy as np

from census_data.core.tables import NonACSBaseTableConfig


@register
class HouseholdsGrandparentsLivingWithGrandchildren(BaseTableConfig):
    """ACS Table B10063"""

    PROCESSED_TABLE_NAME = (
        "grandparentslivingwithgrandchildren"  # Your humanized table name
    )
    UNIVERSE = "households"  # The universe value for this table
    RAW_TABLE_NAME = "B10063"  # The id of the source table
    RAW_FIELD_CROSSWALK = collections.OrderedDict(
        {
            # A crosswalk between the raw field name and our humanized field name.
            "001": "universe",
            "002": "grandparent_living_w_grandchildren",
            "003": "grandparent_responsible_for_own_grandchildren",
            "004": "no_parent_of_grandchildren_present",
            "005": "other_grandparents",
            "006": "grandparent_not_responsible_for_own_grandchildren",
            "007": "without_grandparents_living_with_grandchildren",
        }
    )


@register
class ResponseRate(NonACSBaseTableConfig):
    """
    Decennial Census Self-Response Rates


    See https://www.census.gov/data/developers/data-sets/decennial-response-rates.2020.html
    and https://www.census.gov/data/developers/data-sets/decennial-response-rates.2010.html

    """

    YEAR_LIST = [
        2010,
        2020,
    ]
    PROCESSED_TABLE_NAME = "responserate"
    UNIVERSE = "households"  # This might actually be addresses
    RAW_TABLE_NAME = "responserate"
    RAW_FIELD_CROSSWALK_2020 = collections.OrderedDict(
        {
            "CAVG": "avg_cumulative",
            "CINTAVG": "avg_cumulative_internet",
            "CINTMAX": "max_cumulative_internet",
            "CINTMED": "med_cumulative_internet",
            "CINTMIN": "min_cumulative_internet",
            "CMAX": "max_cumulative",
            "CMED": "med_cumulative",
            "CMIN": "min_cumulative",
            "CRRALL": "cumulative",
            "CRRINT": "internet",
            "DAVG": "avg_daily",
            "DINTAVG": "avg_daily_internet",
            "DINTMAX": "max_daily_internet",
            "DINTMED": "med_daily_internet",
            "DINTMIN": "min_daily_internet",
            "DMAX": "max_daily",
            "DMED": "med_daily",
            "DMIN": "min_daily",
            "DRRALL": "daily",
            "DRRINT": "daily_internet",
            "RESP_DATE": "resp_date",
        }
    )
    FIELD_TYPES_2020 = {
        "CAVG": np.float64,
        "CINTAVG": np.float64,
        "CINTMAX": np.float64,
        "CINTMED": np.float64,
        "CINTMIN": np.float64,
        "CMAX": np.float64,
        "CMED": np.float64,
        "CMIN": np.float64,
        "CRRALL": np.float64,
        "CRRINT": np.float64,
        "DAVG": np.float64,
        "DINTAVG": np.float64,
        "DINTMAX": np.float64,
        "DINTMED": np.float64,
        "DINTMIN": np.float64,
        "DMAX": np.float64,
        "DMED": np.float64,
        "DMIN": np.float64,
        "DRRALL": np.float64,
        "DRRINT": np.float64,
    }

    RAW_FIELD_CROSSWALK_2010 = collections.OrderedDict(
        {
            "FSRR2010": "cumulative",
        }
    )
    FIELD_TYPES_2010 = {
        "FSRR2010": np.float64,
    }

    def __init__(  # pylint:disable=too-many-arguments
        self,
        api_key=None,
        source="responserate",
        years=None,
        data_dir=None,
        force=False,
    ):
        super().__init__(api_key, source, years, data_dir, force)

    def get_raw_field_crosswalk(self, year=None):
        if year == 2010:
            return self.RAW_FIELD_CROSSWALK_2010

        return self.RAW_FIELD_CROSSWALK_2020

    def get_field_types(self, year=None):
        if year == 2010:
            return self.FIELD_TYPES_2010

        return self.FIELD_TYPES_2020


@register
class Occupation(BaseTableConfig):
    """Sex by Occupation for the Civilian Employed Population 16 Years and Over"""

    PROCESSED_TABLE_NAME = "occupation"
    UNIVERSE = "civilian employed population 16 years and over"
    # Using the consolidated version of the table because the ACS 5-year
    # release does not include the B24010/B24020 tables. To analyze occupation
    # data for smaller geographies, you must use the C24010/C24020 table.
    RAW_TABLE_NAME = "C24010"
    # Note that these categories are nested
    RAW_FIELD_CROSSWALK = collections.OrderedDict(
        {
            "001": "universe",
            # Male
            "002": "male_total",
            # Male: Management, business, science, and arts occupations:
            "003": "male_management_business_science_arts",
            # Male: Management, business, science, and arts occupations:
            #   Management, business, and financial occupations
            "004": "male_management_business_financial",
            "005": "male_management",
            "006": "male_business_financial_operations",
            # Male: Management, business, science, and arts occupations:
            #   Computer, engineering, and science occupations
            "007": "male_computer_engineering_science",
            "008": "male_computer_mathematical",
            "009": "male_architecture_engineering",
            "010": "male_life_physical_social_science",
            # Male: Management, business, science, and arts occupations:
            #   Education, legal, community service, arts, and media occupations
            "011": "male_education_legal_community_service_arts_media",
            "012": "male_community_social_service",
            "013": "male_legal",
            "014": "male_educational_instruction_library",
            "015": "male_arts_design_entertainment_sports_media",
            # Male: Management, business, science, and arts occupations:
            #   Healthcare practitioners and technical occupations
            "016": "male_healthcare_practitioners_technical",
            "017": "male_health_diagnosing_treating_practitioners_other_technical",
            "018": "male_health_technologists_technicians",
            # Male: Service occupations
            "019": "male_service",
            "020": "male_healthcare_support",
            # Male: Service occupations: Protective service occupations
            "021": "male_protective_service",
            "022": "male_firefighting_prevention_other_protective_service_including_supervisors",
            "023": "male_law_enforcement_including_supervisors",
            # Male: Service occupations
            "024": "male_food_preparation_and_serving",
            "025": "male_building_and_grounds_cleaning_and_maintenance",
            "026": "male_personal_care_and_service_occupations",
            # Male: Sales and office occupations
            "027": "male_sales_and_office",
            "028": "male_sales_and_related",
            "029": "male_office_administrative_support",
            # Male: Natural resources, construction, and maintenance occupations
            "030": "male_natural_resources_construction_maintenance",
            "031": "male_farming_fishing_forestry",
            "032": "male_construction_extraction",
            "033": "male_installation_maintenance_repair",
            # Male: Production, transportation, and material moving occupations
            "034": "male_production_transportation_material_moving",
            "035": "male_production",
            "036": "male_transportation",
            "037": "male_material_moving",
            # The hierarchy repeats for women
            "038": "female_total",
            "039": "female_management_business_science_arts",
            "040": "female_management_business_financial",
            "041": "female_management",
            "042": "female_business_financial_operations",
            "043": "female_computer_engineering_science",
            "044": "female_computer_mathematical",
            "045": "female_architecture_engineering",
            "046": "female_life_physical_social_science",
            "047": "female_education_legal_community_service_arts_media",
            "048": "female_community_social_service",
            "049": "female_legal",
            "050": "female_educational_instruction_library",
            "051": "female_arts_design_entertainment_sports_media",
            "052": "female_healthcare_practitioners_technical",
            "053": "female_health_diagnosing_treating_practitioners_other_technical",
            "054": "female_health_technologists_technicians",
            "055": "female_service",
            "056": "female_healthcare_support",
            "057": "female_protective_service",
            "058": "female_firefighting_prevention_other_protective_service_including_supervisors",
            "059": "female_law_enforcement_including_supervisors",
            "060": "female_food_preparation_and_serving",
            "061": "female_building_and_grounds_cleaning_and_maintenance",
            "062": "female_personal_care_and_service_occupations",
            "063": "female_sales_and_office",
            "064": "female_sales_and_related",
            "065": "female_office_administrative_support",
            "066": "female_natural_resources_construction_maintenance",
            "067": "female_farming_fishing_forestry",
            "068": "female_construction_extraction",
            "069": "female_installation_maintenance_repair",
            "070": "female_production_transportation_material_moving",
            "071": "female_production",
            "072": "female_transportation",
            "073": "female_material_moving",
        }
    )

    def process(self, df):  # pylint: disable=no-self-use
        """Calculates totals for both genders together"""
        # Calculate totals for both genders together
        groups = [
            "management_business_science_arts",
            "management_business_financial",
            "management",
            "business_financial_operations",
            "computer_engineering_science",
            "computer_mathematical",
            "architecture_engineering",
            "life_physical_social_science",
            "education_legal_community_service_arts_media",
            "community_social_service",
            "legal",
            "educational_instruction_library",
            "arts_design_entertainment_sports_media",
            "healthcare_practitioners_technical",
            "health_diagnosing_treating_practitioners_other_technical",
            "health_technologists_technicians",
            "service",
            "healthcare_support",
            "protective_service",
            "firefighting_prevention_other_protective_service_including_supervisors",
            "law_enforcement_including_supervisors",
            "food_preparation_and_serving",
            "building_and_grounds_cleaning_and_maintenance",
            "personal_care_and_service_occupations",
            "sales_and_office",
            "sales_and_related",
            "office_administrative_support",
            "natural_resources_construction_maintenance",
            "farming_fishing_forestry",
            "construction_extraction",
            "installation_maintenance_repair",
            "production_transportation_material_moving",
            "production",
            "transportation",
            "material_moving",
        ]
        for grp in groups:
            df[f"total_{grp}"] = df[f"male_{grp}"] + df[f"female_{grp}"]

        return df
