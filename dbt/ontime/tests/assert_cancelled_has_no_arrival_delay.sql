select *
from {{ ref('fct_flights') }}
where cancelled = 1.0
  and arr_delay is not null
