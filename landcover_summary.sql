-- Create a table named landcoverSummary
CREATE TABLE landcoverSummary AS 
-- Select time_point, landcover, total_area, and proportion
SELECT 
    time_point, 
    landcover, 
    SUM(area_sq_m) AS total_area
FROM (
    -- Subquery to combine data from all time points and calculate the sum of areas for each landcover type
    SELECT 
        'historical' AS time_point, 
        landcover, 
        SUM(area_sq_m) AS area_sq_m 
    FROM historical 
    GROUP BY landcover 
    UNION ALL 
    SELECT 
        'modern01' AS time_point, 
        landcover, 
        SUM(area_sq_m) AS area_sq_m 
    FROM modern01 
    GROUP BY landcover 
    UNION ALL 
    SELECT 
        'modern11' AS time_point, 
        landcover, 
        SUM(area_sq_m) AS area_sq_m 
    FROM modern11 
    GROUP BY landcover 
    UNION ALL 
    SELECT 
        'modern21' AS time_point, 
        landcover, 
        SUM(area_sq_m) AS area_sq_m 
    FROM modern21 
    GROUP BY landcover
) AS all_landcover_areas 
-- Group the results by time_point and landcover
GROUP BY time_point, landcover;
