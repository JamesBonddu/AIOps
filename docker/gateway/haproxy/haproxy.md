# haproxy

## install

```sh
apt install -y haproxy
```

```yaml
global
  chroot /var/lib/haproxy
  user haproxy
  group haproxy
  ca-base /etc/ssl/certs
  crt-base /etc/ssl/private
  master-worker
  stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
  stats timeout 30s
  ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets
  ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
  ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
  log /dev/log local0
  log /dev/log local1 notice
  insecure-fork-wanted

# daemon
# Default SSL material locations
# See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
defaults unnamed_defaults_1
  mode http
  log global
  option httplog
  option dontlognull
  timeout connect 5000
  timeout client 50000
  timeout server 50000
  errorfile 400 /etc/haproxy/errors/400.http
  errorfile 403 /etc/haproxy/errors/403.http
  errorfile 408 /etc/haproxy/errors/408.http
  errorfile 500 /etc/haproxy/errors/500.http
  errorfile 502 /etc/haproxy/errors/502.http
  errorfile 503 /etc/haproxy/errors/503.http
  errorfile 504 /etc/haproxy/errors/504.http

userlist dataplaneapi
  user admin insecure-password haproxy-admin-k8s

frontend stats
  mode http
  bind *:8404
  stats enable
  stats uri /stats
  stats refresh 10s
  stats admin if LOCALHOST

program api
  command /usr/sbin/dataplaneapi -f /etc/haproxy/dataplaneapi.yaml
  no option start-on-reload
```

## dataplane api


## install 

```sh
wget https://github.com/haproxytech/dataplaneapi/releases/download/v3.0.3/dataplaneapi_3.0.3_linux_x86_64.tar.gz
```

# haproxy stats


```yaml
frontend stats
    mode http
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 10s
    stats admin if LOCALHOST
```

https://www.haproxy.com/blog/exploring-the-haproxy-stats-page