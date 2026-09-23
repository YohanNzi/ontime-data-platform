select distinct
      carrier_id,
      carrier_code
  from {{ ref('int_flights') }}
