{# Use the custom schema (staging/intermediate/marts/seeds) as-is instead of
   dbt's default "<target_schema>_<custom_schema>" concatenation — keeps the
   schema names in the warehouse matching the folder names in models/. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
