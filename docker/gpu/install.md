# git clone nvidia-device-plugin
<!-- kubectl apply -f nvidia-device-plugin.yml  -->
```sh
git clone git@github.com:NVIDIA/k8s-device-plugin.git

helm uninstall nvidia-device-plugin -n gpu-device-plugin

helm install nvidia-device-plugin ./nvidia-device-plugin --namespace gpu-device-plugin
```

# k8s install nvidia-device-plugin

```sh
helm install nvidia-device-plugin ./nvidia-device-plugin --namespace gpu-device-plugin
NAME: nvidia-device-plugin
LAST DEPLOYED: Fri Sep 27 15:28:45 2024
NAMESPACE: gpu-device-plugin
STATUS: deployed
REVISION: 1
TEST SUITE: None
```
