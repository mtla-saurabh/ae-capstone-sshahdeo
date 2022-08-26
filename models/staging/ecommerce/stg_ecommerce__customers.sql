with customers as (

    select * from {{ source('ecommerce','customers') }}

),

final as (
    select
        -- primary key
        customer_id,

        -- foreign keys
        customer_unique_id,

        -- timestamps

        -- dimensions
        customer_zip_code_prefix,
        customer_city,
        customer_state

    from customers
)

select * from final
