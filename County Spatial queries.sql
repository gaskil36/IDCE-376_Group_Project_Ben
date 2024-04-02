-- Developed land by county spatial queries
-- Calculate total developed area for each time point vector image

-- Create developed area by county for each time point vector image

-- Historical:
CREATE TABLE developedHistorical AS
SELECT
    c.name AS county_name,
    SUM(CASE WHEN h.landcover LIKE 'Developed%' THEN h.area_sq_m ELSE 0 END) AS developed_area_historical
FROM
    counties c
LEFT JOIN
    historical h ON ST_Intersects(c.geom, h.geom)
GROUP BY
    c.name;

-- Modern01: 
CREATE TABLE developedModern01 AS
SELECT
    c.name AS county_name,
    SUM(CASE WHEN m.landcover LIKE 'Developed%' THEN m.area_sq_m ELSE 0 END) AS developed_area_modern01
FROM
    counties c
LEFT JOIN
    modern01 m ON ST_Intersects(c.geom, m.geom)
GROUP BY
    c.name;

-- Modern11: 
CREATE TABLE developedModern11 AS
SELECT
    c.name AS county_name,
    SUM(CASE WHEN m.landcover LIKE 'Developed%' THEN m.area_sq_m ELSE 0 END) AS developed_area_modern11
FROM
    counties c
LEFT JOIN
    modern11 m ON ST_Intersects(c.geom, m.geom)
GROUP BY
    c.name;

-- Modern21: 
CREATE TABLE developedModern21 AS
SELECT
    c.name AS county_name,
    SUM(CASE WHEN m.landcover LIKE 'Developed%' THEN m.area_sq_m ELSE 0 END) AS developed_area_modern21
FROM
    counties c
LEFT JOIN
    modern21 m ON ST_Intersects(c.geom, m.geom)
GROUP BY
    c.name;


-- Join the developed summary tables into developed_summary_combined

CREATE TABLE developed_by_county AS
SELECT
    h1.county_name AS county_name,
    h1.developed_area_historical,
    h2.developed_area_modern01,
    h3.developed_area_modern11,
    h4.developed_area_modern21
FROM
    developedHistorical h1
JOIN
    developedModern01 h2 ON h1.county_name = h2.county_name
JOIN
    developedModern11 h3 ON h1.county_name = h3.county_name
JOIN
    developedModern21 h4 ON h1.county_name = h4.county_name
ORDER BY
    h1.county_name;

-- Add area totals

INSERT INTO developed_by_county (county_name, developed_area_historical, developed_area_modern01, developed_area_modern11, developed_area_modern21)
SELECT
    'Total' AS county_name,
    SUM(developed_area_historical) AS developed_area_historical,
    SUM(developed_area_modern01) AS developed_area_modern01,
    SUM(developed_area_modern11) AS developed_area_modern11,
    SUM(developed_area_modern21) AS developed_area_modern21
FROM
    developed_by_county;


-- Add county_area column to ‘developed_by_counties’, from table countiesArea

ALTER TABLE developed_by_counties
ADD COLUMN county_area numeric;

UPDATE developed_by_county dsc
SET county_area= ca.area_sq_m
FROM countiesArea ca
WHERE dsc.county_name = ca.name;


-- Calculate the total row for each count column

INSERT INTO developed_by_county (developed_area_historical, developed_area_modern01, developed_area_modern11, developed_area_modern21, county_area)
SELECT ‘Total Area’,
       SUM(developed_area_historical), 
       SUM(developed_area_modern01), 
       SUM(developed_area_modern11), 
       SUM(developed_area_modern21),
       SUM(county_area)
FROM developed_by_county;

-- Lets rename the columns to be shorter

ALTER TABLE developed_by_county
RENAME COLUMN developed_area_historical TO area_hist
RENAME COLUMN developed_area_modern01 TO area_01
RENAME COLUMN developed_area_modern11 TO area_11
RENAME COLUMN developed_area_modern21 TO area_21;
ALTER TABLE


-- Calculate percentage developed as a new table

-- Create table developed_percent
CREATE TABLE developed_percent (
    county_name VARCHAR,
    percent_hist numeric,
    percent_01 numeric,
    percent_11 numeric,
    percent_21 numeric
);

-- Populate the new table with percentage values
INSERT INTO developed_percent (county_name, percent_hist, percent_01, percent_11, percent_21)
SELECT county_name,
       (area_hist / county_area) * 100 AS percent_hist,
       (area_01 / county_area) * 100 AS percent_01,
       (area_11 / county_area) * 100 AS percent_11,
       (area_21 / county_area) * 100 AS percent_21
FROM developed_by_county;

-- Add column showing average sq meters developed each year in each county

ALTER TABLE developed_by_county
ADD COLUMN avg_sqm_year numeric;

UPDATE developed_by_county
SET avg_sqm_year = (area_21 - area_hist) / 36;

-- And calculate this as a percentage of total county area

ALTER TABLE developed_by_county
ADD COLUMN county_percent_year numeric;

UPDATE developed_by_county
SET county_percent_year = (avg_sqm_year / county_area) * 100;


-- Go back to table developed_percent, and calculate percent change in developed land

ALTER TABLE developed_percent
ADD COLUMN percent_change numeric;

UPDATE developed_percent
SET percent_change = (percent_21/percent_hist)*100;

-- and get average percent change per year in developed land/county

ALTER TABLE developed_percent
ADD COLUMN percent_year numeric;

UPDATE developed_percent
SET percent_year = percent_change/36;


-- Add geom column to developed_by_county so that it can be mapped

ALTER TABLE developed_by_county
ADD COLUMN geom geometry;

UPDATE developed_by_county dbc
SET geom = ca.geom
FROM countiesarea ca
WHERE dbc.county_name = ca.name;
