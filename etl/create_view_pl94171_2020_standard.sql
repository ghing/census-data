-- Create a view of the standard redistricting columns from the P.L. data.
-- This pulls the columns similar to the `pl_select_standard()` function
-- (https://corymccartan.github.io/PL94171/reference/pl_select_standard.html)
-- in the R package PL94171.

CREATE VIEW IF NOT EXISTS pl94171_2020_standard
AS SELECT
    GEOID,
    geo.STUSAB AS state,
    geo.COUNTY AS county,
    geo.LOGRECNO AS row_id,
    SUMLEV AS summary_level,
    P0020001 AS pop,
    P0020002 AS pop_hisp,
    P0020005 AS pop_white,
    P0020006 AS pop_black,
    P0020007 AS pop_aian,
    P0020008 AS pop_asian,
    P0020009 AS pop_nhpi,
    P0020010 AS pop_other,
    P0020011 AS pop_two,
    P0040001 AS vap,
    P0040002 AS vap_hisp,
    P0040005 AS vap_white,
    P0040006 AS vap_black,
    P0040007 AS vap_aian,
    P0040008 AS vap_asian,
    P0040009 AS vap_vap_nhpi,
    P0040010 AS vap_other,
    P0040011 AS vap_two
FROM pl94171_2020_geo geo
LEFT JOIN pl94171_2020_00001 f1
ON f1.LOGRECNO = geo.LOGRECNO
AND f1.STUSAB = geo.STUSAB
LEFT JOIN pl94171_2020_00002 f2
ON f2.LOGRECNO = geo.LOGRECNO
AND f2.STUSAB = geo.STUSAB
LIMIT 10;