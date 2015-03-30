{% from "apache24/map.jinja" import apache24 with context %}

apache24:
  pkg.installed:
    - name: {{ apache24.package }}
  service.running:
    - name: {{ apache24.service }}
    - enable: True

apache24-reload:
  module.wait:
    - name: service.reload
    - m_name: {{ apache24.service }}

apache24-restart:
  module.wait:
    - name: service.restart
    - m_name: {{ apache24.service }}


