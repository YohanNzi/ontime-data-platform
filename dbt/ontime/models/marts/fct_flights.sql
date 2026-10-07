{# Partitionnement/clustering : options BigQuery uniquement.
     dbt-duckdb interprète aussi partition_by (écriture de fichiers partitionnés)
     avec une autre syntaxe → ne pas lui transmettre. #}
  {% if target.type == 'bigquery' %}
  {{
      config(
          partition_by={
              "field": "flight_date",
              "data_type": "date",
              "granularity": "month"
          },
          cluster_by=["carrier_id", "origin"]
      )
  }}
  {% endif %} select
      flight_date,
      carrier_id,
      flight_number,
      tail_number,
      origin,
      dest,
      crs_dep_time,
      dep_time,
      dep_delay,
      dep_delay_minutes,                                  
      dep_del15,
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
      carrier_delay,                                      
      weather_delay,
      nas_delay,
      security_delay,                                     
      late_aircraft_delay
      
  from {{ ref('int_flights') }}
