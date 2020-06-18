FROM library/debian:stable-20200607-slim
RUN DEBIAN_FRONTEND="noninteractive" && \
    apt-get update && \
    apt-get install --assume-yes \
        deluged=1.3.15-2

# App user
ARG APP_USER="deluge"
ARG APP_UID=1364
ARG HOME_DIR="/var/lib/deluged"
RUN useradd --uid "$APP_UID" --no-create-home --home "$HOME_DIR" --user-group --shell /sbin/nologin "$APP_USER"

# Configuration
ARG CONF_DIR="$HOME_DIR/config"
ARG DATA_DIR="$HOME_DIR/data"
RUN echo '{\n\
  "file": 1,\n\
  "format": 1\n\
}{\n\
  "info_sent": 0.0,\n\
  "lsd": true,\n\
  "max_download_speed": -1.0,\n\
  "send_info": false,\n\
  "natpmp": true,\n\
  "move_completed_path": "$DATA_DIR",\n\
  "peer_tos": "0x00",\n\
  "enc_in_policy": 1,\n\
  "queue_new_to_top": false,\n\
  "ignore_limits_on_local_network": true,\n\
  "rate_limit_ip_overhead": true,\n\
  "daemon_port": 58846,\n\
  "torrentfiles_location": "$DATA_DIR",\n\
  "max_active_limit": -1,\n\
  "geoip_db_location": "/usr/share/GeoIP/GeoIP.dat",\n\
  "upnp": true,\n\
  "utpex": true,\n\
  "max_active_downloading": 1,\n\
  "max_active_seeding": -1,\n\
  "allow_remote": true,\n\
  "outgoing_ports": [\n\
    0,\n\
    0\n\
  ],\n\
  "enabled_plugins": [],\n\
  "max_half_open_connections": 50,\n\
  "download_location": "$DATA_DIR",\n\
  "compact_allocation": false,\n\
  "max_upload_speed": -1.0,\n\
  "plugins_location": "$CONF_DIR/plugins",\n\
  "max_connections_global": 200,\n\
  "enc_prefer_rc4": true,\n\
  "cache_expiry": 60,\n\
  "dht": true,\n\
  "stop_seed_at_ratio": false,\n\
  "stop_seed_ratio": 2.0,\n\
  "max_download_speed_per_torrent": -1,\n\
  "prioritize_first_last_pieces": false,\n\
  "max_upload_speed_per_torrent": -1,\n\
  "auto_managed": true,\n\
  "enc_level": 2,\n\
  "copy_torrent_file": false,\n\
  "max_connections_per_second": 20,\n\
  "listen_ports": [\n\
    6881,\n\
    6891\n\
  ],\n\
  "max_connections_per_torrent": -1,\n\
  "del_copy_torrent_file": false,\n\
  "move_completed": false,\n\
  "autoadd_enable": true,\n\
  "proxies": {\n\
    "peer": {\n\
      "username": "",\n\
      "password": "",\n\
      "hostname": "",\n\
      "type": 0,\n\
      "port": 8080\n\
    },\n\
    "web_seed": {\n\
      "username": "",\n\
      "password": "",\n\
      "hostname": "",\n\
      "type": 0,\n\
      "port": 8080\n\
    },\n\
    "tracker": {\n\
      "username": "",\n\
      "password": "",\n\
      "hostname": "",\n\
      "type": 0,\n\
      "port": 8080\n\
    },\n\
    "dht": {\n\
      "username": "",\n\
      "password": "",\n\
      "hostname": "",\n\
      "type": 0,\n\
      "port": 8080\n\
    }\n\
  },\n\
  "dont_count_slow_torrents": true,\n\
  "add_paused": false,\n\
  "random_outgoing_ports": true,\n\
  "max_upload_slots_per_torrent": -1,\n\
  "new_release_check": false,\n\
  "enc_out_policy": 1,\n\
  "seed_time_ratio_limit": -1,\n\
  "remove_seed_at_ratio": false,\n\
  "autoadd_location": "$DATA_DIR",\n\
  "max_upload_slots_global": -1,\n\
  "seed_time_limit": 180,\n\
  "cache_size": 512,\n\
  "share_ratio_limit": -1,\n\
  "random_port": true,\n\
  "listen_interface": ""\n\
}' > "$CONF_DIR/core.conf"

# Volumes
RUN mkdir "$DATA_DIR" && \
    chown -R "$APP_USER":"$APP_USER" "$HOME_DIR"
VOLUME ["$CONF_DIR", "$DATA_DIR"]

#      CONTROL   TRAFFIC TCP     TRAFFIC UDP
EXPOSE 58846/tcp
#EXPOSE 58846/tcp 56881:56889/tcp 56881:56889/udp

USER "$APP_USER"
WORKDIR "$HOME_DIR"
ENV CONF_DIR="$CONF_DIR"
ENTRYPOINT exec deluged --do-not-daemonize --config "$CONF_DIR"