-- Chicago Traffic Crashes Analysis
-- Period: 2021-2025
-- SQL Engine: SQLite

-- 1. Verify total number of crashes
SELECT COUNT(*) AS total_crashes
FROM crashes;

-- 2. Severe crash rate by lighting condition
SELECT
    LIGHTING_CONDITION,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
GROUP BY LIGHTING_CONDITION
ORDER BY severe_rate_percent DESC;

-- 3. Severe crash rate by hour of day
SELECT
    CAST(CRASH_HOUR AS INTEGER) AS crash_hour,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
GROUP BY CAST(CRASH_HOUR AS INTEGER)
ORDER BY severe_rate_percent DESC;

-- 4. Severe crash rate by day of week
SELECT
    CAST(CRASH_DAY_OF_WEEK AS INTEGER) AS day_of_week,
    CASE CAST(CRASH_DAY_OF_WEEK AS INTEGER)
        WHEN 1 THEN 'Sunday'
        WHEN 2 THEN 'Monday'
        WHEN 3 THEN 'Tuesday'
        WHEN 4 THEN 'Wednesday'
        WHEN 5 THEN 'Thursday'
        WHEN 6 THEN 'Friday'
        WHEN 7 THEN 'Saturday'
    END AS day_name,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
GROUP BY CAST(CRASH_DAY_OF_WEEK AS INTEGER)
ORDER BY severe_rate_percent DESC;

-- 5. Severe crash rate by primary contributing cause
SELECT
    PRIM_CONTRIBUTORY_CAUSE,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
WHERE PRIM_CONTRIBUTORY_CAUSE NOT IN (
    'UNABLE TO DETERMINE',
    'NOT APPLICABLE'
)
GROUP BY PRIM_CONTRIBUTORY_CAUSE
HAVING COUNT(*) >= 1000
ORDER BY severe_rate_percent DESC;

-- 6. Severe crash rate by time period using a CTE
WITH time_periods AS (
    SELECT
        CASE
            WHEN CAST(CRASH_HOUR AS INTEGER) BETWEEN 0 AND 5 THEN 'Late Night'
            WHEN CAST(CRASH_HOUR AS INTEGER) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN CAST(CRASH_HOUR AS INTEGER) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_period,
        SEVERE_CRASH
    FROM crashes
)
SELECT
    time_period,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM time_periods
GROUP BY time_period
ORDER BY severe_rate_percent DESC;

-- 7. Rank hours by severe crash rate using a window function
WITH hourly_severity AS (
    SELECT
        CAST(CRASH_HOUR AS INTEGER) AS crash_hour,
        COUNT(*) AS total_crashes,
        SUM(SEVERE_CRASH) AS severe_crashes,
        100.0 * SUM(SEVERE_CRASH) / COUNT(*) AS severe_rate_percent
    FROM crashes
    GROUP BY CAST(CRASH_HOUR AS INTEGER)
)
SELECT
    crash_hour,
    total_crashes,
    severe_crashes,
    ROUND(severe_rate_percent, 2) AS severe_rate_percent,
    RANK() OVER (ORDER BY severe_rate_percent DESC) AS severity_rank
FROM hourly_severity
ORDER BY severity_rank;