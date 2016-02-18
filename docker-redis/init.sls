{% set container_name = 'redis' %}
{% set host_port = salt['pillar.get']('redis:port', '6379') %}
{% set host_ip = salt['grains.get']('ip4_interfaces:eth0:0') %}


redis:
  docker.pulled:
    - name: redis

redis-container:
  require:
     - docker: redis
  docker.installed:
    - name: {{ container_name }}
    - image: redis

redis-running:
  require:
    - docker: redis-container
  docker.running:
    - container: {{ container_name }}
    - image: redis
    - restart_policy: always
    - network_mode: bridge
    - ports:
        "6379/tcp":
            HostIp: {{ host_ip }}
            HostPort: {{ host_port }}
