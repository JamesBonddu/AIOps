#!/bin/bash

func install_haproxy() {
    apt install -y haproxy;
}

func install_dataplaneapi() {
    wget https://github.com/haproxytech/dataplaneapi/releases/download/v3.0.3/dataplaneapi_3.0.3_linux_x86_64.tar.gz
    tar -zxvf dataplaneapi_3.0.3_linux_x86_64.tar.gz
    chmod +x dataplaneapi
    sudo cp dataplaneapi /usr/local/bin/
    sudo cp dataplaneapi.yml.dist /etc/haproxy/dataplaneapi.yml
}
