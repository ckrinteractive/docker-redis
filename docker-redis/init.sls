{% set container_name = 'redis' %}
{% set image_name = 'redis:'+salt['pillar.get']('redis:tag_name', 'latest') %}
{% set host_port = salt['pillar.get']('redis:port', '6379') %}
{% set data_dir = salt['pillar.get']('redis:data_dir', '/srv/redis/data') %}


{{ image_name }}:
  dockerng.image_present

{{ container_name }}:
  require:
     - dockerng: {{ image_name }}
  dockerng.running:
    - name: {{ container_name }}
    - image: {{ image_name }}
    - restart_policy: always
    - port_bindings:
      - {{ salt['grains.get']('ip4_interfaces:eth0:0') }}:{{ host_port }}:6379/tcp
    - binds:
      - {{ data_dir }}:/data
