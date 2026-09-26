-- Chicago Traffic Crashes Analysis
-- Period: 2021-2025
-- SQL Engine: SQLite

-- 1. Verify total number of crashes
SELECT COUNT(*) AS total_crashes
FROM crashes;

-- SELECT COUNT(*) counts every crash record in the table.
-- SELECT COUNT(*), table'daki bütün crash kayıtlarını sayar.

-- AS total_crashes gives the result column a clear and readable name instead of displaying COUNT(*).
-- AS total_crashes, sonuç sütununa COUNT(*) yerine daha anlaşılır bir isim verir.

-- FROM crashes specifies that the data comes from our crashes table.
-- FROM crashes, verinin crashes table'ından alınacağını belirtir.

-- 2. Severe crash rate by lighting condition
SELECT
    LIGHTING_CONDITION,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
GROUP BY LIGHTING_CONDITION
ORDER BY severe_rate_percent DESC;

-- LIGHTING_CONDITION identifies the lighting condition recorded for each crash.
-- LIGHTING_CONDITION, her crash için kaydedilmiş aydınlatma koşulunu gösterir.

-- COUNT(*) AS total_crashes counts the total number of crashes in each lighting category.
-- COUNT(*) AS total_crashes, her lighting kategorisindeki toplam crash sayısını hesaplar.

-- SUM(SEVERE_CRASH) AS severe_crashes counts severe crashes because SEVERE_CRASH is coded as 1 for severe and 0 for non-severe.
-- SUM(SEVERE_CRASH) AS severe_crashes, SEVERE_CRASH severe için 1 ve non-severe için 0 olduğu için severe crash sayısını hesaplar.

-- 100.0 * SUM(SEVERE_CRASH) / COUNT(*) calculates the percentage of crashes that were severe within each lighting condition.
-- 100.0 * SUM(SEVERE_CRASH) / COUNT(*), her lighting condition içindeki crash'lerin yüzde kaçının severe olduğunu hesaplar.

-- ROUND(..., 2) rounds that percentage to two decimal places.
-- ROUND(..., 2), bu yüzdeyi iki ondalık basamağa yuvarlar.

-- GROUP BY LIGHTING_CONDITION creates one result row for each lighting category.
-- GROUP BY LIGHTING_CONDITION, her lighting kategorisi için bir sonuç satırı oluşturur.

-- ORDER BY severe_rate_percent DESC sorts the results from the highest severe-crash rate to the lowest.
-- ORDER BY severe_rate_percent DESC, sonuçları en yüksek severe-crash oranından en düşüğe doğru sıralar.

-- 3. Severe crash rate by hour of day
SELECT
    CAST(CRASH_HOUR AS INTEGER) AS crash_hour,
    COUNT(*) AS total_crashes,
    SUM(SEVERE_CRASH) AS severe_crashes,
    ROUND(100.0 * SUM(SEVERE_CRASH) / COUNT(*), 2) AS severe_rate_percent
FROM crashes
GROUP BY CAST(CRASH_HOUR AS INTEGER)
ORDER BY severe_rate_percent DESC;

-- CAST(CRASH_HOUR AS INTEGER) explicitly treats the imported crash hour as a number rather than text.
-- CAST(CRASH_HOUR AS INTEGER), CSV'den gelen crash hour değerini açıkça text yerine sayı olarak ele alır.

-- The rest of the calculation follows the same logic as Query 2: total crashes, severe crashes, and the severe-crash percentage for each hour.
-- Hesabın geri kalanı Query 2 ile aynı mantığı kullanır: her saat için toplam crash, severe crash ve severe-crash yüzdesi.

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

-- CASE converts the numeric day codes into readable day names, where the Chicago dataset uses 1 for Sunday through 7 for Saturday.
-- CASE, sayısal gün kodlarını okunabilir gün isimlerine çevirir; Chicago veri setinde 1 Sunday'den 7 Saturday'e kadar gider.

-- Using CASE also demonstrates an important SQL skill in the portfolio instead of only repeating simple GROUP BY queries.
-- CASE kullanmak ayrıca sadece basit GROUP BY sorgularını tekrarlamak yerine portföyümüzde önemli bir SQL becerisini göstermiş olur.

-- GROUP BY still groups the original day codes, while CASE gives those groups readable labels in the output.
-- GROUP BY hâlâ orijinal gün kodlarına göre gruplandırma yaparken CASE sonuçlarda bu gruplara okunabilir isimler verir.

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

-- WHERE ... NOT IN (...) removes the two non-specific cause categories before grouping the data.
-- WHERE ... NOT IN (...), veriyi gruplandırmadan önce iki belirsiz cause kategorisini çıkarır.

-- HAVING COUNT(*) >= 1000 keeps only contributing causes represented by at least 1,000 crashes.
-- HAVING COUNT(*) >= 1000, yalnızca en az 1,000 crash ile temsil edilen contributing cause'ları tutar.

-- This threshold helps prevent very rare categories with only a few crashes from appearing at the top because of unstable percentages.
-- Bu eşik, çok az crash içeren nadir kategorilerin güvenilir olmayan yüksek yüzdeler nedeniyle listenin başına çıkmasını önlemeye yardımcı olur.

-- WHERE filters individual rows before grouping, while HAVING filters the groups after GROUP BY; this is an important SQL distinction.
-- WHERE, satırları gruplandırmadan önce filtreler; HAVING ise GROUP BY sonrasında oluşan grupları filtreler ve bu SQL'de önemli bir ayrımdır.

-- This query is also valuable for the portfolio because it demonstrates WHERE, NOT IN, GROUP BY, HAVING, aggregation, calculation, and sorting in one meaningful analysis.
-- Bu sorgu portföy açısından da değerli çünkü tek bir anlamlı analiz içinde WHERE, NOT IN, GROUP BY, HAVING, aggregation, hesaplama ve sıralama kullanımını gösteriyor.

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

-- WITH time_periods AS (...) creates a temporary named result set called a Common Table Expression, or CTE.
-- WITH time_periods AS (...), Common Table Expression (CTE) adı verilen geçici ve isimlendirilmiş bir sonuç seti oluşturur.

-- The CASE statement converts the 24 individual hours into four interpretable periods: Late Night, Morning, Afternoon, and Evening.
-- CASE, 24 ayrı saati dört yorumlanabilir zaman dilimine dönüştürür: Late Night, Morning, Afternoon ve Evening.

-- The outer query then calculates the crash volume and severe-crash rate for each of those periods.
-- Dıştaki sorgu daha sonra bu zaman dilimlerinin her biri için toplam crash sayısını ve severe-crash oranını hesaplar.

-- This is useful for the analysis and also demonstrates CTE + CASE + GROUP BY + aggregation in our portfolio SQL.
-- Bu hem analiz açısından faydalı hem de portföy SQL'imizde CTE + CASE + GROUP BY + aggregation kullanabildiğimizi gösteriyor.

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

-- The CTE first calculates the severe-crash rate for each hour.
-- CTE önce her saat için severe-crash oranını hesaplar.

-- RANK() OVER (...) is a window function that assigns each hour a rank based on its severe-crash rate without collapsing the existing rows.
-- RANK() OVER (...), mevcut satırları birleştirmeden her saate severe-crash oranına göre bir sıralama veren bir window function'dır.

-- ORDER BY severe_rate_percent DESC inside the window means the hour with the highest rate receives rank 1.
-- Window içindeki ORDER BY severe_rate_percent DESC, en yüksek orana sahip saatin rank 1 almasını sağlar.

-- This query is partly analytical and partly intentional portfolio evidence that you can use CTEs and SQL window functions, not only basic aggregation.
-- Bu sorgu hem analitik amaçlı hem de yalnızca basit aggregation değil, CTE ve SQL window function kullanabildiğini portföyde göstermek için bilinçli olarak ekleniyor.