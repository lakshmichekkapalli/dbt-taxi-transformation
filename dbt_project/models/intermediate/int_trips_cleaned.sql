with trips as (
    select * from {{ ref('stg_yellow_tripdata') }}
),

deduped as (
    select distinct * from trips
),

with_derived_fields as (
    select
        *,
        extract(epoch from (dropoff_datetime - pickup_datetime)) / 60.0 as trip_duration_minutes,
        pickup_datetime::date as pickup_date
    from deduped
    where pickup_datetime is not null
      and dropoff_datetime is not null
      and fare_amount > 0
      and trip_distance > 0
      and passenger_count between 1 and 6
)

-- Same validity rules as the batch-etl-pipeline project's pandas transform:
-- trips must last 1-180 minutes to survive. Keeping the business rules
-- identical across both projects, just expressed in SQL here instead of pandas.
select *
from with_derived_fields
where trip_duration_minutes > 0
  and trip_duration_minutes <= 180
