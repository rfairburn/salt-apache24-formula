{% from "apache24/map.jinja" import apache24 with context %}

include:
  - apache24.package

{{ apache24.sysconfig }}:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - template: jinja
    - source: salt://apache24/files/etc/sysconfig/httpd
    - context:
        config: {{ salt['pillar.get']('apache24:sysconfig', {})|json }}
    - require:
        - pkg: {{ apache24.package }}
    - listen_in:
        - module: apache24-restart
