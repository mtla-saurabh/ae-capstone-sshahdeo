
select
    -- primary key

    -- foreign keys

    -- timestamps

    -- dimensions
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state

from {{source('ecommerce', 'geolocations')}}