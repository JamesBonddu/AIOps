# juicefs 手动 format

```sh
juicefs format --storage s3 \
    --bucket https://xx.oss-cn-hangzhou.aliyuncs.com/jfs \
    --access-key xx\
    --secret-key xx\
    'postgres://postgres:postgres@host:port/juicefs' \
    jfs
```

# helm install juicefs csi driver

```sh
helm upgrade --install juicefs-csi-driver ./juicefs-csi-driver -n default -f juicefs-csi-driver/values.yaml
```
