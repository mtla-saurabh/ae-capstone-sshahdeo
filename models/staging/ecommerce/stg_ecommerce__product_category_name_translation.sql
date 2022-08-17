with product_category_name_translation as (

    select * from {{ source('ecommerce','product_category_name_translation') }}

),

final as (
    select

        -- details
        string_field_0 as product_category_name_portuguese,
        string_field_1 as product_category_name_english
    from product_category_name_translation
    -- where clause added to exclude a row containing header label
    where string_field_0 != "product_category_name"
)

select * from final
