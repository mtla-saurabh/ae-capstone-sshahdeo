with sellers as (

    select * from {{ source('ecommerce','sellers') }}

),

final as (

    select
        -- primary key
        seller_id,

        -- foreign keys

        -- timestamps

        -- dimensions
        seller_zip_code_prefix,
        seller_city,
        seller_state

    from sellers
)

select * from final
