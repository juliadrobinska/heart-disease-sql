CREATE TABLE heart_data (
    age INT,
    sex INT,
    cp INT,
    trestbps INT,
    chol INT,
    fbs INT,
    restecg INT,
    thalach INT,
    exang INT,
    oldpeak NUMERIC,
    slope INT,
    ca INT,
    thal INT,
    condition INT
);

SELECT *
FROM heart_data
LIMIT 5;

SELECT COUNT(*) AS total_rows
FROM heart_data;

SELECT DISTINCT CONDITION 
FROM heart_data;

SELECT 
COUNT(*) FILTER (WHERE CONDITION IS NULL) AS condition_nulls,
COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
COUNT(*) FILTER (WHERE chol IS NULL) AS chol_nulls,
COUNT(*) FILTER (WHERE trestbps IS NULL) AS bps_nulls
FROM heart_data;

SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM heart_data;

SELECT MIN(chol) AS min_chol, MAX(chol) AS max_chol
FROM heart_data;

SELECT min(trestbps) AS min_bps, MAX(trestbps) AS max_bps
FROM heart_data;

SELECT CONDITION, COUNT(*) 
FROM heart_data
GROUP BY CONDITION 
ORDER BY CONDITION;

SELECT ROUND(cnt_sick * 100.0 / cnt_total, 2) AS disease_percentage
FROM 
(SELECT COUNT(*) AS cnt_sick FROM heart_data WHERE CONDITION = 1) sick,
(SELECT COUNT(*) AS cnt_total FROM heart_data) total;

SELECT CONDITION, ROUND(AVG(age), 2) AS avg_age
FROM heart_data
GROUP BY CONDITION; 

SELECT CONDITION, ROUND(AVG(chol), 2) AS avg_chol
FROM heart_data
GROUP BY CONDITION;

SELECT CONDITION, ROUND(AVG(trestbps), 2) AS avg_bps
FROM heart_data
GROUP BY CONDITION;

SELECT sex, CONDITION, COUNT(*)
FROM heart_data
GROUP BY sex, CONDITION;

SELECT ROUND(male_sick * 100.0 / sick_total, 2) AS male_sick_perc, ROUND(female_sick * 100.0 / sick_total, 2) AS female_sick_perc
FROM 
(SELECT COUNT(*) AS sick_total FROM heart_data WHERE CONDITION = 1) st,
(SELECT COUNT(*) AS male_sick FROM heart_data WHERE sex = 1 AND CONDITION = 1) ms,
(SELECT COUNT(*) AS female_sick FROM heart_data WHERE sex = 0 AND CONDITION = 1) FS;

SELECT ROUND(male_sick * 100.0 / male_total, 2) AS male_sick_perc
FROM
(SELECT COUNT(*) AS male_total FROM heart_data WHERE sex = 1) mt,
(SELECT COUNT(*) AS male_sick FROM heart_data WHERE sex = 1 AND CONDITION = 1) ms;

SELECT ROUND(female_sick * 100.0 / female_total, 2) AS female_sick_perc
FROM
(SELECT COUNT(*) AS female_total FROM heart_data WHERE sex = 0) ft,
(SELECT COUNT(*) AS female_sick FROM heart_data WHERE sex = 0 AND CONDITION = 1) fs;

SELECT 
	CASE 
		WHEN chol < 200 THEN 'normal_chol'
		ELSE 'high_chol'
		END AS chol_group,
	COUNT(*) AS total_people,
	SUM (CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) AS sick_count,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY chol_group
ORDER BY chol_group;

SELECT 
	CASE 
		WHEN trestbps < 140 THEN 'normal_bps'
		ELSE 'high_bps'
	END AS bps_group,
	COUNT (*) AS total_people,
	SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) AS sick_count,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY bps_group
ORDER BY bps_group;

SELECT
	CASE
		WHEN age < 50 THEN '<50'
		WHEN age BETWEEN 50 AND 60 THEN '50-60'
		ELSE '>60'
	END AS age_group,
	COUNT (*) AS total_people,
	SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) AS sick_count,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY age_group
ORDER BY MIN(age);

WITH 
age_stats AS (
	SELECT
		CASE
			WHEN age <50 THEN '<50'
			WHEN age BETWEEN 50 AND 60 THEN '50-60'
			ELSE '>60'
		END AS bucket,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY 1
),
chol_stats AS (
	SELECT 
		CASE
			WHEN chol < 200 THEN 'normal_chol'
			ELSE 'high_chol'
		END AS bucket,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY 1
),
bps_stats AS (
	SELECT
		CASE 
			WHEN trestbps < 140 THEN 'normal_bps'
			ELSE 'high_bps'
		END AS bucket,
	ROUND(100.0 * SUM(CASE WHEN CONDITION = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS sick_perc
FROM heart_data
GROUP BY 1
),
all_stats AS (
SELECT 'age' AS factor, bucket, sick_perc FROM age_stats
UNION ALL
SELECT 'cholesterol' AS factor, bucket, sick_perc FROM chol_stats
UNION ALL
SELECT 'blood_pressure' AS factor, bucket, sick_perc FROM bps_stats
)
SELECT 
	factor,
	ROUND(MIN(sick_perc), 2) AS min_sick_perc,
	ROUND(MAX(sick_perc), 2) AS max_sick_perc,
	ROUND(MAX(sick_perc) - MIN(sick_perc), 2) AS effect_pp
FROM all_stats 
GROUP BY factor
ORDER BY effect_pp DESC;