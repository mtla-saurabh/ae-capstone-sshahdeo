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
    select
    distinct order_id
    from    orders
    where  order_status NOT IN ("canceled","unavailable")
    ),

first_n_last_order as (
    select
       customers.customer_id,
        min(order_approved_at) as first_order_approved_at,
        max(order_approved_at) as last_order_approved_at,
        date_diff(max(order_approved_at),min(order_approved_at),DAY) as customer_lifespan
    from    customers  
    left outer join orders
    on customers.customer_id=orders.customer_id
    inner join cancelled_missing_orders  -- Inner Join with cancelled_missing_orders ensures that Orders that are either cancelled or unavailable are not factored in when determining a customer's lifespan
    on orders.order_id=cancelled_missing_orders.order_id
    where  order_approved_at is not null -- The assumption is that if an order is approved than, it will have a date and can be factored into calculation a customer's lifespan
    group by 1 
     
    ),

order_price_agg as (
    select orders.customer_id,
    sum(price) as sum_purchase_amount, 
    count(distinct orders.order_id)  as count_orders
    from orders
    left outer join order_items 
    on orders.order_id=order_items.order_id
    group by 1
    ),

latest_order_reviews as (
    select *, review_creation_date,
    row_number() over (partition by order_id order by review_creation_date desc) as highest_review_rank
    from `ae-capstone-raw.ecommerce.order_reviews`
    qualify highest_review_rank =1
    ),

review_agg as (
    select customer_id,avg(review_score) as review_score_avg
    from latest_order_reviews 
    left outer join orders 
    on latest_order_reviews.order_id=orders.order_id
    group by 1
    ),
  
final as (
select 
--primary key
customers.customer_id as customer_id,

--unique key
customer_unique_id,

-- dimensions
customer_zip_code_prefix,
customer_city,
customer_state,

--dates
first_order_approved_at,
last_order_approved_at,

--metric
review_score_avg,
customer_lifespan,
sum_purchase_amount,
count_orders

from customers
left outer join first_n_last_order
on customers.customer_id=first_n_last_order.customer_id

left outer join review_agg
on customers.customer_id=review_agg.customer_id

left outer join order_price_agg
on customers.customer_id=order_price_agg.customer_id
)

select * from final
