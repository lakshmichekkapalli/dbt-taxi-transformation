-- Singular test: fails (returns rows) if any trip in the mart has a
-- negative fare or total — the intermediate filtering should make this
-- impossible, so this is a regression guard on that logic.
select trip_id, fare_amount, total_amount
from {{ ref('fct_trips') }}
where fare_amount < 0 or total_amount < 0
