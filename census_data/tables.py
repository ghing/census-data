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
from census_data_downloader.tables.classofworker import ClassOfWorkerDownloader
from census_data_downloader.tables.employmentstatus import EmploymentStatusDownloader
from census_data_downloader.tables.language import LanguageShortFormDownloader
import numpy as np

from census_data.core.tables import NonACSBaseTableConfig

# ACS Tables overridden from census-data-downloader
#
# In most cases, these classes need overridden because the list of available
# years is out of date.


@register
class EmploymentStatus(EmploymentStatusDownloader):
    """ "Table B23025: Employment Status"""

    # HACK: Manually update the year list because the base package is out-of-date
    YEAR_LIST = (2019, 2018, 2017, 2016, 2015, 2014, 2013, 2012, 2011)


@register
class LanguageShortForm(LanguageShortFormDownloader):
    """Table C16001: Language Spoken at Home"""

    # HACK: Manually update the year list because the base package is out-of-date
    YEAR_LIST = (
        2019,
        2018,
        2017,
        2016,
    )


@register
class ClassOfWorker(ClassOfWorkerDownloader):
    """Table C24080: Sex by Class of Worker for the Civilian Population"""

    def process(self, df):  # pylint: disable=no-self-use
        """Calculates totals for both genders together"""
        groups = [
            "private_for_profit_wage_and_salary",
            "employee_of_private_company",
            "selfemployed_in_own_incorporated_business",
            "private_not_for_profit_wage_and_salary",
            "local_government",
            "state_government",
            "federal_government",
            "selfemployed_in_own_not_incorporated_business",
            "unpaid_family_workers",
        ]
        for grp in groups:
            df[f"total_{grp}"] = df[f"male_{grp}"] + df[f"female_{grp}"]

        return df


# ACS tables not supported by census-data-downloader


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
class SchoolEnrollmentDetailedLevel(BaseTableConfig):
    """Table B14007: School Enrollment by Detailed Level of School"""

    PROCESSED_TABLE_NAME = "school_enrollment_detailed"
    UNIVERSE = "population 3 years and over"
    RAW_TABLE_NAME = "B14007"
    # See https://api.census.gov/data/2019/acs/acs5/groups/B14007.html
    RAW_FIELD_CROSSWALK = collections.OrderedDict(
        {
            "001": "universe",
            "002": "enrolled",
            "003": "preschool",
            "004": "kindergarten",
            "005": "grade_1",
            "006": "grade_2",
            "007": "grade_3",
            "008": "grade_4",
            "009": "grade_5",
            "010": "grade_6",
            "011": "grade_7",
            "012": "grade_8",
            "013": "grade_9",
            "014": "grade_10",
            "015": "grade_11",
            "016": "grade_12",
            "017": "college_undergrad",
            "018": "college_grad",
            "019": "not_enrolled",
        }
    )


@register
class SchoolEnrollmentDetailedLevelWhite(SchoolEnrollmentDetailedLevel):
    """Table B14007A: School Enrollment by Detailed Level of School (White alone)"""

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_white"
    RAW_TABLE_NAME = "B14007A"


@register
class SchoolEnrollmentDetailedLevelBlack(SchoolEnrollmentDetailedLevel):
    """
    Table B14007B:
    School Enrollment by Detailed Level of School (Black or African American Alone)

    """

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_black"
    RAW_TABLE_NAME = "B14007B"


@register
class SchoolEnrollmentDetailedLevelAmericanIndianAlaskaNative(
    SchoolEnrollmentDetailedLevel
):
    """
    Table B14007C:
    School Enrollment by Detailed Level of School (American Indian and Alaska Native Alone)

    """

    PROCESSED_TABLE_NAME = (
        "school_enrollment_detailed_american_indian_and_alaska_native"
    )
    RAW_TABLE_NAME = "B14007C"


@register
class SchoolEnrollmentDetailedLevelAsian(SchoolEnrollmentDetailedLevel):
    """Table B14007D: School Enrollment by Detailed Level of School (Asian Alone)"""

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_asian"
    RAW_TABLE_NAME = "B14007D"


@register
class SchoolEnrollmentDetailedLevelNativeHawaiianPacificIslander(
    SchoolEnrollmentDetailedLevel
):
    """
    Table B14007E:
    School Enrollment by Detailed Level of School (Native Hawaiian and Other Pacific Islander Alone)

    """

    PROCESSED_TABLE_NAME = (
        "school_enrollment_detailed_native_hawaiian_and_pacific_islander"
    )
    RAW_TABLE_NAME = "B14007E"


@register
class SchoolEnrollmentDetailedLevelOther(SchoolEnrollmentDetailedLevel):
    """
    Table B14007F:
    School Enrollment by Detailed Level of School (Some Other Race Alone)

    """

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_other"
    RAW_TABLE_NAME = "B14007F"


@register
class SchoolEnrollmentDetailedLevelTwoOrMore(SchoolEnrollmentDetailedLevel):
    """Table B14007G: School Enrollment by Detailed Level of School (Two or More Races)"""

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_two_or_more_races"
    RAW_TABLE_NAME = "B14007G"


@register
class SchoolEnrollmentDetailedLevelWhiteNonHispanic(SchoolEnrollmentDetailedLevel):
    """
    Table B14007H:
    School Enrollment by Detailed Level of School (White Alone, Not Hispanic or Latino)

    """

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_white_nh"
    RAW_TABLE_NAME = "B14007H"


@register
class SchoolEnrollmentDetailedLevelLatino(SchoolEnrollmentDetailedLevel):
    """Table B14007I: School Enrollment by Detailed Level of School (Hispanic or Latino)"""

    PROCESSED_TABLE_NAME = "school_enrollment_detailed_latino"
    RAW_TABLE_NAME = "B14007I"


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


# Non-ACS tables


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
class EEOALL1W(NonACSBaseTableConfig):
    """
    Equal Employment Opportunity Tabulation Table ALL01W

    See https://www.census.gov/topics/employment/equal-employment-opportunity-tabulation.html

    """

    YEAR_LIST = [
        2018,
    ]
    PROCESSED_TABLE_NAME = "occupation_by_sex_race_for_worksite_geo"
    UNIVERSE = "civilians employed at work 16 years and over"
    RAW_TABLE_NAME = "ALL1W"
    RAW_FIELD_CROSSWALK = collections.OrderedDict(
        {
            "EEO": "occupation",
            # Racial category processed names follow the same conventions as those for table
            # B03002 in census-data-downloader.
            # See
            # https://github.com/datadesk/census-data-downloader/blob/master/census_data_downloader/tables/race.py
            "C01_001": "universe",
            "C01_002": "universe_pct",
            "C01_003": "male",
            "C01_004": "male_pct",
            "C01_005": "female",
            "C01_006": "female_pct",
            "C02_001": "latino_alone",
            "C02_002": "latino_alone_pct",
            "C02_003": "latino_alone_male",
            "C02_004": "latino_alone_male_pct",
            "C02_005": "latino_alone_female",
            "C02_006": "latino_alone_female_pct",
            "C03_001": "white_alone",
            "C03_002": "white_alone_pct",
            "C03_003": "white_alone_male",
            "C03_004": "white_alone_male_pct",
            "C03_005": "white_alone_female",
            "C03_006": "white_alone_female_pct",
            "C04_001": "black_alone",
            "C04_002": "black_alone_pct",
            "C04_003": "black_alone_male",
            "C04_004": "black_alone_male_pct",
            "C04_005": "black_alone_female",
            "C04_006": "black_alone_female_pct",
            "C05_001": "american_indian_and_alaska_native",
            "C05_002": "american_indian_and_alaska_native_pct",
            "C05_003": "american_indian_and_alaska_native_male",
            "C05_004": "american_indian_and_alaska_native_male_pct",
            "C05_005": "american_indian_and_alaska_native_female",
            "C05_006": "american_indian_and_alaska_native_female_pct",
            "C06_001": "asian_alone",
            "C06_002": "asian_alone_pct",
            "C06_003": "asian_alone_male",
            "C06_004": "asian_alone_male_pct",
            "C06_005": "asian_alone_female",
            "C06_006": "asian_alone_female_pct",
            "C07_001": "native_hawaiian_and_pacific_islander",
            "C07_002": "native_hawaiian_and_pacific_islander_pct",
            "C07_003": "native_hawaiian_and_pacific_islander_male",
            "C07_004": "native_hawaiian_and_pacific_islander_male_pct",
            "C07_005": "native_hawaiian_and_pacific_islander_female",
            "C07_006": "native_hawaiian_and_pacific_islander_female_pct",
            # In the data, this category is labeled as
            # "Balance of not Hispanic or Latino"
            "C08_001": "other_or_two_or_more",
            "C08_002": "other_or_two_or_more_pct",
            "C08_003": "other_or_two_or_more_male",
            "C08_004": "other_or_two_or_more_male_pct",
            "C08_005": "other_or_two_or_more_female",
            "C08_006": "other_or_two_or_more_female_pct",
        }
    )

    def __init__(  # pylint:disable=too-many-arguments
        self,
        api_key=None,
        source="eeo",
        years=None,
        data_dir=None,
        force=False,
    ):
        super().__init__(api_key, source, years, data_dir, force)

    def get_raw_field_crosswalk(self, year=None):
        field_map = collections.OrderedDict({"NAME": "name"})
        field_suffix_map = {
            "E": "",
            "EA": "_annotation",
            "M": "_moe",
            "MA": "_moe_annotation",
        }
        for field_id, field_name in self.RAW_FIELD_CROSSWALK.items():
            if field_id == "EEO":
                field_map[field_id] = field_name
                continue

            for field_suffix, name_suffix in field_suffix_map.items():
                full_raw_id = f"EEO{self.RAW_TABLE_NAME}_{field_id}{field_suffix}"
                processed_name = f"{field_name}{name_suffix}".strip()
                field_map[full_raw_id] = processed_name

        return field_map

    def get_field_types(self, year=None):  # pylint:disable=unused-argument
        """Returns the field types"""
        field_types = {}

        # Use the default behavior for ACS tables since the variables conform
        # to this convention.
        for field in self.RAW_FIELD_CROSSWALK.items():
            if "_" in field and (field.endswith("E") or field.endswith("M")):
                field_types[field] = np.float64

        return field_types
