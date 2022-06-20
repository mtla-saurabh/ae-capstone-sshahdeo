

select
    -- primary key

    -- foreign keys
    order_id,

    -- timestamps

    -- dimensions
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value

from {{source('ecommerce', 'order_payments')}}