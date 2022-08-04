

select
    -- primary key
    {{ dbt_utils.surrogate_key(['order_id', 'payment_sequential']) }} as order_payment_sk,

    -- foreign keys
    order_id,
    -- timestamps

    -- dimensions
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value

from {{source('ecommerce', 'order_payments')}}