
select
    -- primary  key
    product_id, 
    
    -- foreign keys

    -- timestamps

    -- dimensions
    product_category_name,
    product_name_lenght as product_name_length,
    product_description_lenght as product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm

from {{source('ecommerce', 'products')}}