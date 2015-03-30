{% load_yaml as includes %}
- modules
- config
- vhosts
- conf_d
- sysconfig
{% endload %}

include:
  - apache24.package
{% if salt['pillar.get']('apache24:mod_ssl', False) %}
  - apache24.ssl
{% endif %}
{% for include in includes %}
  {% if include in salt['pillar.get']('apache24', {}) %}
  - apache24.{{ include }}
  {% endif %}
{% endfor %}
