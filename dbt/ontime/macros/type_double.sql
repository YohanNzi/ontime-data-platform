{% macro type_double() %}
    {%- if target.type == 'bigquery' -%}
      float64
    {%- else -%}
      double
    {%- endif -%}
  {% endmacro %}