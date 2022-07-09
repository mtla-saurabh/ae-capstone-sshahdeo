select
    -- primary key
    order_id,

    -- foreign keys
    customer_id,

    -- timestamps
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    -- dimensions
    order_status

from {{source('ecommerce', 'orders')}}