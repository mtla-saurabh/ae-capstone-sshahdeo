
with 
orders as (
    select * from {{ ref("stg_ecommerce__orders") }}
	),
    
order_items as (
    select * from {{ ref("stg_ecommerce__order_items") }}
	),

order_reviews as (
    select * from {{ ref("stg_ecommerce__order_reviews") }}
	),

products as (
    select * from {{ ref("stg_ecommerce__products") }}
	),

customers as (
    select * from {{ ref("stg_ecommerce__customers") }}
	),

cancelled_missing_orders as (
    select
    distinct order_id
    from    orders
    where  order_status NOT IN ("canceled","unavailable")
	) ,

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

latest_order_reviews as (
    select *, review_creation_date,
    row_number() over (partition by order_id order by review_creation_date desc) as highest_review_rank
    from `ae-capstone-raw.ecommerce.order_reviews`
    qualify highest_review_rank =1
    ),


final as (
    select
        -- primary key
        order_items.order_item_sk,

        -- foreign keys
        order_items.order_id as order_id,
        order_items.order_item_id as order_item_id,
        order_items.product_id as product_id,
        orders.customer_id as customer_id,

        -- timestamps
        orders.order_purchase_timestamp as order_purchase_timestamp,
        orders.order_approved_at as order_approved_at,

        -- dimensions
        orders.order_status as order_status,
        products.product_category_name as product_category_name,

        -- booleans/flags
        orders.order_approved_at = first_n_last_order.first_order_approved_at as is_first_order_of_customer,
        orders.order_approved_at = first_n_last_order.last_order_approved_at as is_last_order_of_customer,

        -- metrics
        order_items.price as price,
        latest_order_reviews.review_score as review_score,
		customer_lifespan

    FROM order_items
    LEFT OUTER JOIN orders
    ON order_items.order_id=orders.order_id
    LEFT OUTER JOIN products
    ON order_items.product_id=products.product_id
    LEFT OUTER JOIN latest_order_reviews
    ON order_items.order_id=latest_order_reviews.order_id
    LEFT OUTER JOIN first_n_last_order
    ON orders.customer_id=first_n_last_order.customer_id
	)

select * from final