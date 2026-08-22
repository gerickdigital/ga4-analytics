-- Acquisition funnel by channel, GA4 sample data, January 2021
-- One row per channel. Users counted by user_pseudo_id (first-touch attributed).
SELECT
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(DISTINCT IF(event_name = 'view_item',     user_pseudo_id, NULL)) AS viewed_item,
  COUNT(DISTINCT IF(event_name = 'add_to_cart',   user_pseudo_id, NULL)) AS added_to_cart,
  COUNT(DISTINCT IF(event_name = 'begin_checkout',user_pseudo_id, NULL)) AS began_checkout,
  COUNT(DISTINCT IF(event_name = 'purchase',      user_pseudo_id, NULL)) AS purchased,
  SAFE_DIVIDE(
    COUNT(DISTINCT IF(event_name = 'purchase', user_pseudo_id, NULL)),
    COUNT(DISTINCT user_pseudo_id)
  ) AS conversion_rate
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20210131'
GROUP BY source, medium
HAVING users >= 100
ORDER BY users DESC;
