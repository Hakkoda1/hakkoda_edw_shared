{% macro optionset_rename(table_name, schema_name='nay_dev') %}

{% set optionset_obj = api.Relation.create(
                  database=target.database,
                  schema=schema_name,
                  identifier=table_name+'_optionset') %}

{% set non_optionset_obj = api.Relation.create(
                  database=target.database,
                  schema=schema_name,
                  identifier=table_name) %}

{% set optionset_cols_renamed = [] %}
{% set non_optionset_cols = [] %}
{% for col in adapter.get_missing_columns(optionset_obj, non_optionset_obj) %}
    {% set optionset_col = col.name.lower() %}
    {% set non_optionset_col = '_'.join(optionset_col.split('_')[:-2]) %}
    {% set col_renamed = optionset_col+' as '+non_optionset_col  %}
    {{ optionset_cols_renamed.append(col_renamed) or "" }}
    {{ non_optionset_cols.append(non_optionset_col) or "" }}
{% endfor %}

{{ return([optionset_cols_renamed, non_optionset_cols]) }}

{% endmacro %}