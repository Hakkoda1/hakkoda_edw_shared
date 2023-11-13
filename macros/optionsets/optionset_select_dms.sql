{%macro optionset_select_dms(entity_name,staging_view,stringmap_name,schema='nay_dev') %}
{% set retrieve_attribute_names_query %}
    with attribute_names as (
        select attributename
        from {{ref(stringmap_name)}}
        where objecttypecode = '{{ entity_name}}'
        group by 1
    )
    select c.attributename
    ,column_name fivetran_column_name  
    from information_schema.columns a
    inner join attribute_names c ON lower(replace(a.column_name,'_','')) = REPLACE(c.attributename,'_','')
    where table_name = UPPER('{{staging_view}}')
    and table_schema = UPPER('{{schema}}')
{% endset %}
{% if execute %}
{% set results = run_query(retrieve_attribute_names_query) %}
{% else %}
{% set results = [] %}
{% endif %}
{% for i in results.rows  -%}
  
,string_map_{{ i[0] }}.value as {{ i[0] }}_stringmap_value
{% endfor -%}  
{% endmacro %}
