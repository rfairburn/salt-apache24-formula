{% from "apache24/map.jinja" import apache24 with context %}

{% set mod_ssl = salt['pillar.get']('apache24:mod_ssl', False) %}
{% set mod_ldap = salt['pillar.get']('apache24:mod_ldap', False) %}
include:
  - apache24.package
{% if mod_ssl %}
  - apache24.ssl
{% endif %}
{% if mod_ldap %}
  - apache24.ldap
{% endif %}


{% for conf_d_file, settings in salt['pillar.get']('apache24:conf_d', {}).items() %}
{% set conf_d_full_path = '{0}/{1}.conf'.format(apache24.conf_dir, conf_d_file) %}
{{ conf_d_full_path }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://apache24/files/conf.tmpl
    - context:
        config: {{ settings.get('config', {})|json }}
    - require:
        - pkg: apache24
  {% if mod_ssl %}
        - pkg: {{ apache24.ssl_package }}
  {% endif %}
  {% if mod_ldap %}
        - pkg: {{ apache24.ldap_package }}
  {% endif %}
    - listen_in:
        - module: apache24-restart
{% endfor %}
