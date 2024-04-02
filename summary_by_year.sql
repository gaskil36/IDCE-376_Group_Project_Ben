-- Historical Total Area and Percent Area
CREATE TABLE landcoversummary_historical AS  
SELECT *
FROM landcoversummary
WHERE time_point = 'historical';

-- Total area column creation
ALTER TABLE landcoversummary_historical
ADD total_area_sum FLOAT;

UPDATE landcoversummary_historical
SET total_area_sum = (SELECT SUM(total_area) FROM landcoversummary_historical);

-- Percent area column creation
ALTER TABLE landcoversummary_historical
ADD percent_cover FLOAT;

UPDATE landcoversummary_historical
SET percent_cover = ((total_area / total_area_sum) * 100);

-- Historical Total Area and Percent Area
CREATE TABLE landcoversummary_modern01 AS  
SELECT *
FROM landcoversummary
WHERE time_point = 'modern01';

-- Total area column creation
ALTER TABLE landcoversummary_modern01
ADD total_area_sum FLOAT;

UPDATE landcoversummary_modern01
SET total_area_sum = (SELECT SUM(total_area) FROM landcoversummary_modern01);

-- Percent area column creation
ALTER TABLE landcoversummary_modern01
ADD percent_cover FLOAT;

UPDATE landcoversummary_modern01
SET percent_cover = ((total_area / total_area_sum) * 100);

-- Historical Total Area and Percent Area
CREATE TABLE landcoversummary_modern11 AS  
SELECT *
FROM landcoversummary
WHERE time_point = 'modern11';

-- Total area column creation
ALTER TABLE landcoversummary_modern11
ADD total_area_sum FLOAT;

UPDATE landcoversummary_modern11
SET total_area_sum = (SELECT SUM(total_area) FROM landcoversummary_modern11);

-- Percent area column creation
ALTER TABLE landcoversummary_modern11
ADD percent_cover FLOAT;

UPDATE landcoversummary_modern11
SET percent_cover = ((total_area / total_area_sum) * 100);


-- Historical Total Area and Percent Area
CREATE TABLE landcoversummary_modern21 AS  
SELECT *
FROM landcoversummary
WHERE time_point = 'modern21';

-- Total area column creation
ALTER TABLE landcoversummary_modern21
ADD total_area_sum FLOAT;

UPDATE landcoversummary_modern21
SET total_area_sum = (SELECT SUM(total_area) FROM landcoversummary_modern21);

-- Percent area column creation
ALTER TABLE landcoversummary_modern21
ADD percent_cover FLOAT;

UPDATE landcoversummary_modern21
SET percent_cover = ((total_area / total_area_sum) * 100);

-- Create final Overall Change (2021 - 2001) Table
CREATE TABLE overall_change (
	ID SERIAL PRIMARY KEY,
	landcover_name VARCHAR(255),
	percent_change FLOAT
);

-- Insert the name of landcover types 
INSERT INTO overall_change (landcover_name)
	SELECT landcover
	FROM landcoversummary_modern21;

INSERT INTO overall_change (percent_change)
	SELECT (landcoversummary_modern21.percent_cover - landcoversummary_modern01.percent_cover)
	FROM landcoversummary_modern01
	JOIN landcoversummary_modern21 ON landcoversummary_modern01.landcover = landcoversummary_modern21.landcover;
		
-- Fix the null values by adding a new percent_change column and dropping previous records
ALTER TABLE overall_change
ADD percent_change_2 FLOAT;

-- Fixed null values using an offset
UPDATE overall_change AS oc1
SET percent_change_2 = (
    SELECT oc2.percent_change
    FROM overall_change AS oc2
    WHERE oc2.id = oc1.id + 15
)
WHERE oc1.id <= 15;

ALTER TABLE overall_change DROP COLUMN percent_change;

DELETE FROM overall_change
WHERE id > 15;

ALTER TABLE overall_change RENAME COLUMN percent_change_2 to percent_change;