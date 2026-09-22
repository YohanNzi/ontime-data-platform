select
    -- identité du vol
    flight_date,
    day_of_week,
    dot_id_reporting_airline as carrier_id,
    reporting_airline as carrier_code,
    flight_number_reporting_airline as flight_number,
    tail_number,

    -- aéroports (minimal, la dimension enrichie viendra d'OurAirports en marts)
    origin,
    origin_city_name,
    origin_state,
    dest,
    dest_city_name,
    dest_state,

    -- horaires / ponctualité
    crs_dep_time,
    dep_time,
    dep_delay,
    dep_delay_minutes,
    dep_del15,
    taxi_out,
    wheels_off,
    wheels_on,
    taxi_in,
    crs_arr_time,
    arr_time,
    arr_delay,
    arr_delay_minutes,
    arr_del15,
    cancelled,
    cancellation_code,
    diverted,
    crs_elapsed_time,
    actual_elapsed_time,
    air_time,
    distance,

    -- décomposition des causes de retard
    carrier_delay,
    weather_delay,
    nas_delay,
    security_delay,
    late_aircraft_delay

from {{ source('raw', 'flights') }}
