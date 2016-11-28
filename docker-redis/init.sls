{% set container_name = 'redis' %}
{% set image_name = 'redis:'+salt['pillar.get']('redis:tag_name', 'latest') %}


{{ image_name }}:
  dockerng.pulled:
    - name: redis

{{ container_name }}:
  require:
     - dockerng: {{ image_name }}
  dockerng.running:
    - name: {{ container_name }}
    - image: {{ image_name }}
    - restart_policy: always
    - port_bindings:
      - {{ salt['grains.get']('ip4_interfaces:eth0:0') }}:{{ host_port }}:6379/tcp
