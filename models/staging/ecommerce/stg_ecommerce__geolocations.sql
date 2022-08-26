with source as (

    select * from {{ source ('ecommerce', 'geolocations') }}

),

ranked as (

    select
        geolocation_lat as geolocation_lattitude,
        geolocation_lng as geolocation_longitude,
        geolocation_state,
        geolocation_city,
        geolocation_zip_code_prefix,
        row_number() over (partition by cast(geolocation_lat as string), cast(geolocation_lng as string)) as rank

    from source
    qualify rank = 1

),

final as (

    select
        -- primary key
        {{ dbt_utils.surrogate_key(['geolocation_lattitude', 'geolocation_longitude']) }} as geolocation_sk,

        -- details
        geolocation_zip_code_prefix,
        geolocation_lattitude,
        geolocation_longitude,
        geolocation_city,
        geolocation_state

    from ranked

)

select * from final
