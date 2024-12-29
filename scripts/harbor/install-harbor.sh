#!/bin/bash

wget https://github.com/goharbor/harbor/releases/download/v2.12.1/harbor-offline-installer-v2.12.1.tgz
tar -xvf harbor-offline-installer-v2.12.1.tgz -C /data
cd /data/harbor
# 修改harbor相关的配置
cp harbor.yml.tmpl  harbor.yml
chmod a+x install.sh
bash install.sh

docker compose down
docker compose up -d

