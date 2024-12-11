#!/bin/bash

func install-nvidia-device-plugin() {
    helm install nvidia-device-plugin ./nvidia-device-plugin --namespace gpu-device-plugin
}

func install-gpu-operator() {
    helm install gpu-operator ./gpu-operator \
    --namespace gpu-operator \
    --create-namespace \
    --set driver.version=535.183.01 \
    --set driver.enabled=false \
    --set toolkit.enabled=false
}


