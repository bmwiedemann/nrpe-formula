# Include :download:`map file <map.jinja>` of OS-specific package names and
# file paths. Values can be overridden using Pillar.
{% from "nrpe/map.jinja" import nrpe with context %}

nrpe:
  pkg.installed:
    - name: {{ nrpe.server }}
  service.running:
    - name: {{ nrpe.service }}
    - enable: True
    - require:
      - pkg: {{ nrpe.server }}

{% set nrpe_conf_src = 0 -%} #salt['pillar.get']('nrpe:nrpe_conf', 'salt://nrpe/nrpe.conf') -%}

{%- if nrpe_conf_src %}
nrpe_conf:
  file.managed:
    - name: {{ nrpe.nrpe_conf }}
    - template: jinja
    - source: {{ nrpe_conf_src }}
    - require:
      - pkg: {{ nrpe.client }}
    - watch_in:
      - service: {{ nrpe.service }}
{%- endif %}
