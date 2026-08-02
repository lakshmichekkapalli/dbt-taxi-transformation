with trips as (
    select * from {{ ref('int_trips_cleaned') }}
),

pickup_zone as (
    select * from {{ ref('stg_taxi_zone_lookup') }}
),

dropoff_zone as (
    select * from {{ ref('stg_taxi_zone_lookup') }}
)

select
    trips.trip_id,
    trips.vendor_id,
    trips.pickup_datetime,
    trips.dropoff_datetime,
    trips.pickup_date,
    trips.passenger_count,
    trips.trip_distance,
    trips.trip_duration_minutes,
    trips.pickup_location_id,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    trips.dropoff_location_id,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    trips.payment_type,
    trips.fare_amount,
    trips.tip_amount,
    trips.total_amount
from trips
left join pickup_zone on trips.pickup_location_id = pickup_zone.location_id
left join dropoff_zone on trips.dropoff_location_id = dropoff_zone.location_id
