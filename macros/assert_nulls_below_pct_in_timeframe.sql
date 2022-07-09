
{% test assert_nulls_below_pct_in_timeframe(model, column_name, comparison_timestamp , threshold_pct=2, last_n_days=7) %}

    select 
        sum(case when {{ column_name }} is null then 1 else 0 end )*100/count(*) as null_percent
    from {{ model }}
    where  {{ comparison_timestamp }} >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL {{ last_n_days }} DAY)
    having null_percent >  {{ threshold_pct }}

{% endtest %}