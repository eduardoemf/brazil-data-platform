{% macro generate_schema_name(custom_schema_name=none, node=none) -%}

  {%- set schema = target.schema | trim -%}

  {# Remove o prefixo apenas se estiver no início #}
  {%- if schema.startswith('landing_zone_') -%}
    {%- set schema = schema[13:] -%}
  {%- endif -%}

  {%- if custom_schema_name is not none -%}
    {{ custom_schema_name | trim }}
  {%- else -%}
    {{ schema }}
  {%- endif -%}

{%- endmacro %}