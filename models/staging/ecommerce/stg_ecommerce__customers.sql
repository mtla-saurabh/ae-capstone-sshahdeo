
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

from {{source('stg_ecommerce__customers', 'customers')}}
