select 
    -- primary key
    distinct {{ dbt_utils.surrogate_key(['geolocation_zip_code_prefix', 'geolocation_lat', 'geolocation_lng', 'geolocation_city', 'geolocation_state']) }} as geolocation_sk,

    -- foreign keys

    -- timestamps

    -- dimensions
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
from {{source('ecommerce', 'geolocations')}} 


 