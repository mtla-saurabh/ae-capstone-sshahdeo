select sum(case when product_category_name is null then 1 else 0 end )*100/count(*) as null_percent
from {{ ref('stg_ecommerce__products' )}}
having null_percent > 2


