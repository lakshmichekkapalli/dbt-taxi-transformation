select
    pickup_borough,
    pickup_zone,
    count(*) as total_trips,
    round(sum(total_amount)::numeric, 2) as total_revenue,
    round(avg(fare_amount)::numeric, 2) as avg_fare,
    round(avg(tip_amount / nullif(fare_amount, 0) * 100)::numeric, 1) as avg_tip_pct
from {{ ref('fct_trips') }}
group by pickup_borough, pickup_zone
order by total_trips desc
