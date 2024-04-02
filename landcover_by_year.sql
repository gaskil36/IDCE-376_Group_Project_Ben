CREATE TABLE landcover_by_year AS 
SELECT 
    time_point, 
    landcover, 
	
	CASE time_point
		WHEN 'historical' THEN  
			(SUM(area_sq_m) / (
				SELECT SUM(area_sq_m) 
				FROM (
					SELECT area_sq_m FROM historical 
				) AS all_landcover_areas
			) * 100) 
		END AS percent_cover_historical,
					
	CASE time_point	
		WHEN 'modern01' THEN  
			(SUM(area_sq_m) / (
				SELECT SUM(area_sq_m) 
				FROM (
					SELECT area_sq_m FROM modern01 
				) AS all_landcover_areas
			) * 100)
		END AS percent_cover_2001,
					
	CASE time_point			
		WHEN 'modern11' THEN  
			(SUM(area_sq_m) / (
				SELECT SUM(area_sq_m) 
				FROM (
					SELECT area_sq_m FROM modern11 
				) AS all_landcover_areas
			) * 100) 
		END AS percent_cover_2011,
					
	CASE time_point			
		WHEN 'modern21' THEN  
			(SUM(area_sq_m) / (
				SELECT SUM(area_sq_m) 
				FROM (
					SELECT area_sq_m FROM modern21 
				) AS all_landcover_areas
			) * 100) 
		END	AS percent_cover_2021	
FROM (
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
GROUP BY time_point, landcover;
