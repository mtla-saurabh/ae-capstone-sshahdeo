
select
    -- primary key

    -- foreign keys
    seller_id,

    -- timestamps

    -- dimensions
    seller_zip_code_prefix,
    seller_city,
    seller_state

from {{source('ecommerce', 'sellers')}}