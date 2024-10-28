#!/bin/bash

# Function to update package list
update_package_list() {
    sudo apt update -y
}

# Function to install required packages
install_required_packages() {
    sudo apt-get install -y bison git
    sudo apt install -y socat conntrack ebtables ipvsadm ipset
}

# Function to install gvm (Go Version Manager)
install_gvm() {
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
}

# Function to install Docker
install_docker() {
    curl https://releases.rancher.com/install-docker/20.10.sh | sh
}

# Function to install kubekey
install_kubekey() {
    curl -sfL https://get-kk.kubesphere.io | VERSION=v3.1.6 sh -
    tar -xvf kubekey-v3.1.6-linux-amd64.tar.gz
    chmod a+x kk && cp kk /usr/bin/
}

# Function to install Go
install_go() {
    source /root/.gvm/scripts/gvm
    gvm install go1.23.2 -B
    gvm use go1.23.2
}

# Function to set hostname
set_hostname() {
    hostnamectl set-hostname node1
}

# Function to create KubeKey config file
create_kubekey_config() {
    kk create config --with-kubesphere v3.4.1
    echo "Generate KubeKey config file successfully"
}

# Function to create Kubernetes cluster
create_cluster() {
    kk create cluster -f config-sample.yaml
}



# Function to load IPVS modules
load_ipvs_modules() {
    sudo modprobe -- ip_vs
    sudo modprobe -- ip_vs_rr
    sudo modprobe -- ip_vs_wrr
    sudo modprobe -- ip_vs_sh
    sudo modprobe -- nf_conntrack
}

# Function to copy IPVS configuration file
copy_ipvs_config() {
    sudo cp ipvs.conf /etc/modules-load.d/ipvs.conf
}

# Function to check if IPVS modules are loaded
check_ipvs_modules() {
    lsmod | grep -E 'ip_vs|nf_conntrack'
}

# Main function
ipvs_loading() {
    echo "Loading IPVS modules..."
    load_ipvs_modules

    echo "Copying IPVS configuration file..."
    copy_ipvs_config

    echo "Checking if IPVS modules are loaded..."
    check_ipvs_modules

    echo "IPVS modules loaded successfully."
}

# Execute main function
main

# Main function
main() {
    update_package_list
    install_required_packages
    install_gvm
    install_docker
    install_kubekey
    install_go
    set_hostname
    create_kubekey_config
    ipvs_loading
    create_cluster
}

# Execute main function
main
