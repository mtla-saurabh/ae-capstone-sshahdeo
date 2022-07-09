
select
    -- primary key
    {{ dbt_utils.surrogate_key(['order_id', 'order_item_id']) }} as order_item_sk,

    -- foreign keys
    order_id,
    order_item_id,
    product_id,
    seller_id,

    -- timestamps
    shipping_limit_date,

    -- dimensions
    price,
    freight_value

from {{source('ecommerce', 'order_items')}}