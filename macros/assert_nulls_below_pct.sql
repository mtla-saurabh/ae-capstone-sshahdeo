
{% test assert_nulls_below_pct(model, column_name, threshold_pct=2) %}

    select 
        sum(case when {{ column_name }} is null then 1 else 0 end )*100/count(*) as null_percent
    from {{ model }}
    having null_percent >  {{ threshold_pct }}

{% endtest %}