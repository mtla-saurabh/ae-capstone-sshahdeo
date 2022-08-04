
select
    -- primary key

    -- foreign keys

    -- timestamps

    -- dimensions
    string_field_0 as product_category_name_portuguese,
    string_field_1 as product_category_name_english

from {{source('ecommerce', 'product_category_name_translation')}}

where string_field_0!="product_category_name"