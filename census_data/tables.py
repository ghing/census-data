import collections
from census_data_downloader.core.tables import BaseTableConfig
from census_data_downloader.core.decorators import register


@register
class HouseholdsGrandparentsLivingWithGrandchildren(BaseTableConfig):
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
