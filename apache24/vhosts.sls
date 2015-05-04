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

# Make sure this directory is included in the apache config or conf.d!
{{ apache24.vhosts_dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - require:
      - pkg: apache24

{% for vhost_file, settings in salt['pillar.get']('apache24:vhosts', {}).items() %}
{% set priority = settings.get('priority', '99') %}
{% set vhost_full_path = '{0}/{1}-{2}.conf'.format(apache24.vhosts_dir, priority, vhost_file) %}
{{ vhost_full_path }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://apache24/files/conf.tmpl
    - context:
        config: {{ settings.get('config', {})|json }}
    - require:
        - file: {{ apache24.vhosts_dir }}
        - pkg: apache24
  {% if mod_ssl %}
        - pkg: {{ apache24.ssl_package }}
  {% endif %}
  {% if mod_ldap %}
        - pkg: {{ apache24.ldap_package }}
  {% endif %}
    - listen_in:
        - module: apache24-reload
{% endfor %}
