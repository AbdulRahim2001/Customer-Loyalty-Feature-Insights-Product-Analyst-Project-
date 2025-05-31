-- SQL Insights for Customer Loyalty Feature Analysis

-- 1. Daily Active Users (DAU)
SELECT 
    CAST(session_date AS DATE) AS date,
    COUNT(DISTINCT user_id) AS daily_active_users
FROM feature_usage
GROUP BY date
ORDER BY date;

-- 2. Monthly Conversion Rate by Feature
SELECT 
    DATE_TRUNC('month', session_date) AS month,
    feature_used,
    COUNT(*) AS total_sessions,
    SUM(conversion_flag) AS total_conversions,
    ROUND(SUM(conversion_flag) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM feature_usage
GROUP BY month, feature_used
ORDER BY month, conversion_rate_pct DESC;

-- 3. Top 5 Cities by Average Satisfaction
SELECT 
    location_city,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM feature_usage
GROUP BY location_city
HAVING COUNT(*) > 100
ORDER BY avg_satisfaction DESC
LIMIT 5;

-- 4. Conversion Rate by A/B Test Group and Platform
SELECT 
    ab_test_group,
    platform,
    COUNT(*) AS total,
    SUM(conversion_flag) AS converted,
    ROUND(SUM(conversion_flag) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM feature_usage
GROUP BY ab_test_group, platform;

-- 5. Loyalty Tier Analysis with Engagement
SELECT 
    loyalty_tier,
    COUNT(DISTINCT user_id) AS total_users,
    ROUND(AVG(session_duration_min), 2) AS avg_session_duration,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction,
    ROUND(SUM(conversion_flag) * 100.0 / COUNT(*), 2) AS overall_conversion_rate
FROM feature_usage
GROUP BY loyalty_tier
ORDER BY loyalty_tier;

-- 6. Feature Usage Funnel: Step 1 to Conversion
WITH feature_counts AS (
    SELECT 
        feature_used,
        COUNT(*) AS total,
        SUM(conversion_flag) AS converted
    FROM feature_usage
    GROUP BY feature_used
)
SELECT 
    feature_used,
    total,
    converted,
    ROUND(converted * 100.0 / total, 2) AS funnel_conversion_rate_pct
FROM feature_counts
ORDER BY funnel_conversion_rate_pct DESC;

-- 7. Session Hourly Trend
SELECT 
    EXTRACT(HOUR FROM session_date) AS hour_of_day,
    COUNT(*) AS session_count
FROM feature_usage
GROUP BY hour_of_day
ORDER BY hour_of_day;