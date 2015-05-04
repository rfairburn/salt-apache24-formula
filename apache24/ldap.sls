{% from "apache24/map.jinja" import apache24 with context %}

include:
  - apache24.package

{{ apache24.ldap_package }}:
  pkg.installed:
    - require: 
        - pkg: apache24
    - listen_in:
        - module: apache24-restart
