{% from "apache24/map.jinja" import apache24 with context %}

include:
  - apache24.package

{% set config = salt['pillar.get']('apache24:config', {}) %}
{% if config %}
{{ apache24.conf }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://apache24/files/conf.tmpl
    - context:
        config: {{ config|json }}
    - require:
        - pkg: apache24
    - listen_in:
        - module: apache24-restart
{% endif %}
