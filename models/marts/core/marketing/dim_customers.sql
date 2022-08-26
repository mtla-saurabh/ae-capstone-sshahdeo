with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

order_reviews as (
    select * from {{ ref('stg_ecommerce__order_reviews') }}
),

cancelled_missing_orders as (
    select distinct order_id
    from orders
    where order_status not in ("canceled", "unavailable")
),

first_n_last_order as (
    select
        customers.customer_id,
        min(orders.order_approved_at) as first_order_approved_at,
        max(orders.order_approved_at) as last_order_approved_at,
        date_diff(max(orders.order_approved_at), min(orders.order_approved_at), day) as customer_lifespan

    from customers
    left join orders
        on customers.customer_id = orders.customer_id
    inner join cancelled_missing_orders -- Inner Join with cancelled_missing_orders ensures that Orders that are either cancelled or unavailable are not factored in when determining a customer's lifespan
        on orders.order_id = cancelled_missing_orders.order_id
    where orders.order_approved_at is not null -- The assumption is that if an order is approved than, it will have a date and can be factored into calculation a customer's lifespan
    group by 1
),

order_price_agg as (
    select
        orders.customer_id,
        sum(orders.price) as sum_purchase_amount,
        count(distinct orders.order_id) as count_orders

    from orders
    left join order_items
        on orders.order_id = order_items.order_id
    group by 1
),

latest_order_reviews as (
    select
        *,
        review_creation_date,
        row_number() over (partition by order_id order by review_creation_date desc) as highest_review_rank

    from order_reviews
    qualify highest_review_rank = 1
),

review_agg as (
    select
        orders.customer_id,
        avg(latest_order_reviews.review_score) as review_score_avg

    from latest_order_reviews
    left join orders
        on latest_order_reviews.order_id = orders.order_id
    group by 1
),

final as (
    select
        --primary key
        customers.customer_id as customer_id,

        --unique key
        customers.customer_unique_id,

        -- dimensions
        customers.customer_zip_code_prefix,
        customers.customer_city,
        customers.customer_state,

        --dates
        first_n_last_order.first_order_approved_at,
        first_n_last_order.last_order_approved_at,

        --metric
        review_agg.review_score_avg,
        first_n_last_order.customer_lifespan,
        order_price_agg.sum_purchase_amount,
        order_price_agg.count_orders

    from customers
    left join first_n_last_order
        on customers.customer_id = first_n_last_order.customer_id

    left join review_agg
        on customers.customer_id = review_agg.customer_id

    left join order_price_agg
        on customers.customer_id = order_price_agg.customer_id
)

select * from final
