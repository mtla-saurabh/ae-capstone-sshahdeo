
select
    -- primary key

    -- foreign keys

    -- timestamps

    -- dimensions
    string_field_0 as product_category_name_portuguese,
    string_field_1 as product_category_name_english

from {{source('ecommerce', 'product_category_name_translation')}}
-- where clause added to exclude a row containing header label
where string_field_0!="product_category_name"