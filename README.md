# `build-airconnect`

This is a simple and small docker container for
[AirConnect](https://github.com/philippe44/AirConnect).

The repo points to uses a Docker image maintened by linuxserver.io image, which insists on running as root and then runs a whole init
system for some reason.

This image just uses the precompiled
binaries that are in a `.zip` file in the AirConnect repo (see the [`Dockerfile`](Dockerfile)), it doesn't build AirConnect.

## Running 

Since we don't want to run an init system in a docker container and
AirConnect has separate binaries for UPnP and Chromecast, just run two
containers:

For `airupnp` (UPnP/Sonos):

```bash
# pass cmdline args:
docker run --name airconnect-airupnp -it --net=host \
    git.sudo.is/ben/airconnect airupnp -Z -l 1000:2000

# if you want to mount an /etc/airupnp.xml config file instead:
docker run --name airconnect-airupnp -it --net=host \
    -v airupnp.xml:/etc/airupnp.xml \
    git.sudo.is/ben/airconnect airupnp
```

Here the `-Z` argument is importabt, it instructs
airconnect to not listen to input on stdin. Otherwise
it will loop indefinitely and use 100% cpu.

For `aircast` (Chromecast):

```bash
docker run --name airconnect-aircast -it --net=host \
    git.sudo.is/ben/airconnect aircast
```

You can also set the environment vars `${AIRCONNECT_PROG}` and
`${AIRCONNECT_ARGS}` respectively instead. this is for example useful
in ansible playbooks using `docker_container` tasks:

```yaml
- name: "start airconnect containers"
  docker_container:
    name: airconnect-{{ item }}
    hostname: airconnect-{{ item }}
    image: git.sudo.is/ben/airconnect
    detach: true
    pull: true
    auto_remove: false
    restart_policy: "unless-stopped"
    state: "started"
    network_mode: host
    env:
      AIRCONNECT_PROG: "{{ item }}"
  loop_control:
    label: airconnect-{{ item }}
  with_items:
    - airupnp
    - aircast
```
