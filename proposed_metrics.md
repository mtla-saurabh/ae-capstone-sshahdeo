## PROPOSED METRICS


### PRODUCT
Metric: Quantity Sold
Definition: count(order_items.order_item_id) as quantity_sold; this can be grouped by things like product category but doesn’t need to be filtered by any particular field.
Visualization: Weekly Quantity Sold by Product Category; stacked bar chart where the x-axis is orders.purchased_timestamp , the y-axis is count(order_items.order_item_id) , and the bar groupings are defined by products.product_category_name .


### MARKETING
Metric: Product survival rate
Definition: This will require few CTE SQL queries to eventually obtain survival rate of a product 
Visualization: Grouped bar chart - Product's survival Rate (%) on Y axis; Product Name on Y axis,  and the bar groupings are defined by products.product_category_name 


### FINANCE
Metric: Revenue
Definition: sum(order_payments.payment_value); This can be grouped by  orders.order_purchase_timestamp for all delivered orders (order_Status='delivered')
Visualization: Line chart with Revenue on Y axis and Payment Date in X axis


### LOGISTICS
Time to Deliver Order (in hours)
Metric: Time to Deliver Order (in hours)
Definition: date_diff(order_delivered_carrier_date, order_approved_at, hour) as time_to_deliver_order_hours; this can be grouped by things like city or day of week approved and needs to be filtered on orders where order_delivered_carrier_date is not null .
Visualization: Weekly Amount Sold by Product Category; stacked bar chart where the x-axis is orders.purchased_timestamp , the y-axis is sum(order_items.price) , and the bar groupings are defined by products.product_category_name


### OVERALL HEALTH OF THE COMPANY
Metric: Number of new users acquired - Year over Year comparison
Definition: Count of new customers count(distinct orders.customer_id) can be grouped by the year of their first ever purchase min(year(orders.order_purchase_timestamp)) 
Visualization:  Line chart - Number of new customers in Y -axis and Year in X-axis
