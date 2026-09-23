with spine as (
      select cast(d as date) as date_day
      from generate_series(
          (select min(flight_date) from {{ ref('int_flights') }}),
          (select max(flight_date) from {{ ref('int_flights') }}),
          interval 1 day
      ) as t(d)
  )   
  
  select
      date_day,
      extract(year from date_day) as year,              
      extract(quarter from date_day) as quarter,
      extract(month from date_day) as month,
      extract(day from date_day) as day_of_month,
      extract(dow from date_day) as day_of_week
  from spine
