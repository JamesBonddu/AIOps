# """
# - 配置代理 privoxy
# - 更新 linux 内核为安装 gpu驱动准备
# - 安装 gpu 驱动
# - 安装 criu
# - 安装 nvidia-docker
# - 通过kubekey 安装集群
# """

proxy_host_port=127.0.0.1:27800

proxy_privoxy_conf() {
    sudo sed -i 's/listen-address  127.0.0.1:8118/listen-address  127.0.0.1:27800/' /etc/privoxy/config
    sudo sed -i 's/listen-address  \[::1\]:8118/listen-address  \[::1\]:27800/' /etc/privoxy/config
    sudo echo "forward-socks5t   /               127.0.0.1:11080 ." >> /etc/privoxy/config
    sudo systemctl restart privoxy.service
}

proxy_apt() {
# 配置 apt 代理
echo "Configuring apt proxy..."

# 创建或编辑 /etc/apt/apt.conf.d/99proxy 文件
sudo tee /etc/apt/apt.conf.d/99proxy > /dev/null <<EOF
Acquire::http::Proxy "http://127.0.0.1:27800";
Acquire::https::Proxy "http://127.0.0.1:27800";
EOF

# 更新包列表
echo "Updating package list..."
sudo apt update
}


edit_bashrc() {
    export KKZONE=cn
    # 检查端口是否被占用
    if ! lsof -i:11080 > /dev/null; then
        # 启动 SSH 隧道
        ssh -ND 11080  root@47.242.140.211 &
        echo "SSH tunnel started on port 11080"
    else
        echo "Port 11080 is already in use"
    fi
}

install_criu() {
    sudo apt install -y build-essential libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler protobuf-compiler python3-protobuf libnl-3-dev libcap-dev pkg-config python3-future python3-protobuf python3-ipaddr libnet-dev
    sudo apt install -y software-properties-common
    sudo sudo add-apt-repository ppa:criu/ppa
    sudo apt-get update -y
    sudo apt install libnftables-dev -y
    sudo apt-get install -y criu
}

update_kernel_for_gpu() {
    uname -a
    sudo apt install -y linux-image-5.15.0-88-generic linux-headers-5.15.0-88-generic
}

install_nvidia_docker() {
    # https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-the-nvidia-container-toolkit
    cd ./nvidia-docker2
    sudo dpkg -i *.deb
    sudo nvidia-ctk runtime configure --runtime=crio
}

install_nvidia_driver() {

}

install_cudatookit() {
    # https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_network
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-6
}

# install ssh

install_ssh_auth() {
    # install ssh auth
    ssh-copy-id k8s-gpu@192.168.211.115
    ssh-copy-id k8s-gpu@192.168.211.118
}
