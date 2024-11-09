#!/bin/bash

user=jsdu
bucket=https://xxx.oss-cn-hangzhou.aliyuncs.com/aiops
bucket_access_key=xx
bucket_secret_key=xxx
local_bucket_cache_dir=/var/jfsCache
juicefs_meta_storage_url=postgres://postgres:xxxx@host:port/juicefs?sslmode=disable
juicefs_sys_path=/data/turing_ai_jfs


if type juicefs > /dev/null; then
    echo "exists"
else
    echo "not exists"
    sudo curl -sSL https://d.juicefs.com/install | sh -
fi

sudo mkdir -p $local_bucket_cache_dir
sudo chown -R $user:$user $local_bucket_cache_dir
sudo mkdir -p $juicefs_sys_path
sudo chown -R $user:$user $juicefs_sys_path
sudo touch /var/log/juicefs.log
sudo chown -R $user:$user /var/log/juicefs.log

# 挂载文件系统
juicefs mount --update-fstab -d   \
--cache-dir $local_bucket_cache_dir \
--cache-size 512000 \
--log /var/log/juicefs.log \
$juicefs_meta_storage_url $juicefs_sys_path


# 卸载
# juicefs umount /data/turing_ai_jfs

# minio gateway 网关
# export MINIO_ROOT_USER=minioadmin
# export MINIO_ROOT_PASSWORD=minio123
# juicefs gateway postgres://postgres:postgres@host:port/juicefs_db?sslmode=disable 0.0.0.0:9000
