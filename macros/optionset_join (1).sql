{%macro optionset_join(entity_name,staging_view,schema='nay_dev') %} as {{entity_name}} 
{% set retrieve_fivetran_column_name_query %}
    with attribute_names as (
        select attributename
        from {{ref('raw_stringmap')}}
        where objecttypecode = '{{ entity_name}}'
        group by 1
    )
    select b.attributename
    ,column_name fivetran_column_name  
    from information_schema.columns a
    inner join attribute_names b ON lower(replace(a.column_name,'_','')) = replace(b.attributename,'_','')
    where table_name = UPPER('{{staging_view}}')
    and table_schema = UPPER('{{schema}}')
{% endset %}
{% if execute %}
{% set results = run_query(retrieve_fivetran_column_name_query) %}
{% else %}
{% set results = [] %}
{% endif %}
{% for i in results.rows  -%}  
LEFT JOIN {{ ref('raw_stringmap') }} as string_map_{{ i[0] }} 
    ON string_map_{{ i[0] }}.attributevalue = {{ entity_name }}.{{ i[1] }} 
    AND string_map_{{ i[0] }}.attributename = '{{ i[0] }}' 
    AND string_map_{{ i[0] }}.objecttypecode = '{{ entity_name }}'
{% endfor -%}  
{% endmacro %}