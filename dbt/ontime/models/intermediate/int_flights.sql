select
      -- identité du vol
      cast(flight_date as date) as flight_date,
      cast(nullif(day_of_week, '') as integer) as day_of_week,
      cast(nullif(carrier_id, '') as integer) as carrier_id,
      carrier_code,
      cast(nullif(flight_number, '') as integer) as flight_number,
      tail_number,

      -- aéroports
      origin,
      origin_city_name,                                 
      origin_state,
      dest,
      dest_city_name,
      dest_state,

      -- horaires / ponctualité
      cast(nullif(crs_dep_time, '') as integer) as crs_dep_time,
      cast(nullif(dep_time, '') as integer) as dep_time,
      cast(nullif(dep_delay, '') as double) as dep_delay,
      cast(nullif(dep_delay_minutes, '') as double) as dep_delay_minutes,
      cast(nullif(dep_del15, '') as double) as dep_del15,
      cast(nullif(taxi_out, '') as double) as taxi_out,
      cast(nullif(wheels_off, '') as integer) as wheels_off,
      cast(nullif(wheels_on, '') as integer) as wheels_on,
      cast(nullif(taxi_in, '') as double) as taxi_in,
      cast(nullif(crs_arr_time, '') as integer) as crs_arr_time,
      cast(nullif(arr_time, '') as integer) as arr_time,
      cast(nullif(arr_delay, '') as double) as arr_delay,
      cast(nullif(arr_delay_minutes, '') as double) as arr_delay_minutes,
      cast(nullif(arr_del15, '') as double) as arr_del15,
      cast(nullif(cancelled, '') as double) as cancelled,
      cancellation_code,
      cast(nullif(diverted, '') as double) as diverted,
      cast(nullif(crs_elapsed_time, '') as double) as crs_elapsed_time,
      cast(nullif(actual_elapsed_time, '') as double) as actual_elapsed_time,
      cast(nullif(air_time, '') as double) as air_time,
      cast(nullif(distance, '') as double) as distance,

      -- décomposition des causes de retard
      cast(nullif(carrier_delay, '') as double) as carrier_delay,
      cast(nullif(weather_delay, '') as double) as weather_delay,
      cast(nullif(nas_delay, '') as double) as nas_delay,
      cast(nullif(security_delay, '') as double) as security_delay,
      cast(nullif(late_aircraft_delay, '') as double) as late_aircraft_delay

  from {{ ref('stg_flights') }}
