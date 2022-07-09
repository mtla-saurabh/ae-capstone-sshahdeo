
select
    -- primary key
    seller_id,

    -- foreign keys

    -- timestamps

    -- dimensions
    seller_zip_code_prefix,
    seller_city,
    seller_state

from {{source('ecommerce', 'sellers')}}