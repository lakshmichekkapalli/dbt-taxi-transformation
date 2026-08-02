select
    pickup_date as trip_date,
    count(*) as total_trips,
    round(sum(total_amount)::numeric, 2) as total_revenue,
    round(avg(fare_amount)::numeric, 2) as avg_fare,
    round(avg(trip_distance)::numeric, 2) as avg_trip_distance_miles,
    round(avg(trip_duration_minutes)::numeric, 2) as avg_trip_duration_minutes,
    round(avg(tip_amount)::numeric, 2) as avg_tip_amount
from {{ ref('fct_trips') }}
group by pickup_date
order by pickup_date
