with source as (
    select * from {{ source('raw', 'yellow_tripdata') }}
),

renamed as (
    select
        {{ dbt_utils.generate_surrogate_key([
            '"VendorID"', 'tpep_pickup_datetime', 'tpep_dropoff_datetime',
            '"PULocationID"', '"DOLocationID"', 'trip_distance', 'fare_amount'
        ]) }} as trip_id,

        "VendorID"::integer as vendor_id,
        tpep_pickup_datetime::timestamp as pickup_datetime,
        tpep_dropoff_datetime::timestamp as dropoff_datetime,
        passenger_count::integer as passenger_count,
        trip_distance::numeric as trip_distance,
        "PULocationID"::integer as pickup_location_id,
        "DOLocationID"::integer as dropoff_location_id,
        payment_type::integer as payment_type,
        fare_amount::numeric as fare_amount,
        tip_amount::numeric as tip_amount,
        total_amount::numeric as total_amount

    from source
)

select * from renamed
