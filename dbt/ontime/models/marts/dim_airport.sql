select
      iata_code,
      gps_code,                                           
      name,
      municipality,
      iso_region,                                         
      latitude_deg,
      longitude_deg

  from {{ source('raw', 'airports') }}
  where iata_code is not null and iata_code != ''

  union all
  
  select                                                  
      'PBI' as iata_code,
      gps_code,
      name,
      municipality,
      iso_region,
      latitude_deg,                                       
      longitude_deg

  from {{ source('raw', 'airports') }}                    
  where ident = 'KPBI'
