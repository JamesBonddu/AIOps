#!/bin/bash

helm upgrade nvidia-device-plugin ./nvidia-device-plugin \
  --namespace nvidia-device-plugin \
  --create-namespace \
  --set-file config.map.config=/tmp/mps-config.yaml

# helm upgrade -i nvdp nvdp/nvidia-device-plugin \
#   --namespace nvidia-device-plugin \
#   --create-namespace \
#   --set-file config.map.config=/tmp/mps-config.yaml