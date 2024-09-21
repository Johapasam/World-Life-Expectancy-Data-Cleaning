# World Life Expectancy Project - Data Cleaning
select * from worldlifexpectancy;

# 1. Handling Duplicates
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

# Identifying duplicates based on the combination of Country and Year
SELECT *
FROM (
	SELECT Row_ID, CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifexpectancy
) AS Row_Table
WHERE Row_Num > 1;

# 2. Viewing duplicates with row numbers
SELECT *
FROM (
	SELECT Row_ID, CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM worldlifexpectancy
) AS Row_Table
WHERE Row_Num > 1;
 
 SET SQL_SAFE_UPDATES = 0;

# Deleting duplicate entries
DELETE FROM worldlifexpectancy
WHERE Row_ID IN (
	SELECT Row_ID
	FROM (
		SELECT Row_ID, CONCAT(Country, Year),
		ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
		FROM worldlifexpectancy
	) AS Row_Table
	WHERE Row_Num > 1
);

# 3. Handling Missing Values - 'Status' Column
SELECT * FROM worldlifexpectancy
WHERE Status = '';

#  Viewing distinct non-missing status values
SELECT DISTINCT(Status) FROM worldlifexpectancy
WHERE Status <> '';

# Filling missing 'Developing' statuses based on the same country's existing data
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status = 'Developing';

# Filling missing 'Developed' statuses similarly
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 USING (Country)
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status = 'Developed';

# 4. Handling Missing Values - 'Lifeexpectancy' Column
SELECT * FROM worldlifexpectancy
WHERE `Lifeexpectancy`= '';

# Checking rows where life expectancy is missing
SELECT Country, Year,`Lifeexpectancy`  FROM worldlifexpectancy
WHERE `Lifeexpectancy`= '';

# Computing the median value between life expectancies of the preceding and succeeding years
SELECT t1.Country, t1.Year, t1.`Lifeexpectancy`,
	t2.Country, t2.Year, t2.`Lifeexpectancy`,
    t3.Country, t3.Year, t3.`Lifeexpectancy`,
    ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2 ON t1.Country = t2.Country AND t1.Year = t2.Year -1
JOIN worldlifexpectancy ON t1.Country = t3.Country AND t1.Year = t3.Year +1
WHERE t1.`Lifeexpectancy`= '';

# Updating missing life expectancy values using the computed median
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 ON t1.Country = t2.Country AND t1.Year = t2.Year -1
JOIN worldlifexpectancy ON t1.Country = t3.Country AND t1.Year = t3.Year +1
SET t1.`Lifeexpectancy` = ROUND((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
WHERE t1.`Lifeexpectancy`= '';

