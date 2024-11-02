#!/bin/bash

# Function to download and install karmadactl
install_karmadactl() {
    echo "Downloading karmadactl..."
    wget https://github.com/karmada-io/karmada/releases/download/v1.12.0-alpha.1/karmadactl-linux-amd64.tgz
    tar -xzf karmadactl-linux-amd64.tgz
    sudo mv karmadactl /usr/bin/karmadactl
    sudo chmod a+x /usr/bin/karmadactl
    rm karmadactl-linux-amd64.tgz
    echo "karmadactl installed successfully."
}

# Function to install kubectl-karmada plugin
install_kubectl_karmada() {
    echo "Installing kubectl-karmada plugin..."
    curl -s https://raw.githubusercontent.com/karmada-io/karmada/master/hack/install-cli.sh | sudo bash -s kubectl-karmada
    echo "kubectl-karmada plugin installed successfully."
}

# Function to initialize Karmada
init_karmada() {
    echo "Initializing Karmada..."
    kubectl karmada init
    echo "Karmada initialized successfully."
}

# Main function to orchestrate the installation
main() {
    install_karmadactl
    install_kubectl_karmada
    init_karmada
    echo "Karmada installation completed successfully."
}

# Execute the main function
main