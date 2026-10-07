with bounds as (
        select min(flight_date) as d_min, max(flight_date) as d_max
        from {{ ref('int_flights') }}
    ),  
    
    spine as (
    {% if target.type == 'bigquery' %}
        select date_day
        from bounds, unnest(generate_date_array(d_min, d_max)) as date_day
    {% else %}
        select cast(d as date) as date_day
        from bounds, generate_series(d_min, d_max, interval 1 day) as t(d)
    {% endif %}
    )
    
    select
        date_day,
        extract(year from date_day) as year,              
        extract(quarter from date_day) as quarter,
        extract(month from date_day) as month,
        extract(day from date_day) as day_of_month,
        -- Convention conservée : 0 = dimanche … 6 = samedi.
        -- BigQuery DAYOFWEEK va de 1 (dimanche) à 7 → on retranche 1.
    {% if target.type == 'bigquery' %}
        extract(dayofweek from date_day) - 1 as day_of_week
    {% else %}
        extract(dow from date_day) as day_of_week
    {% endif %}
    from spine
