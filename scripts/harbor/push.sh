#!/bin/bash
IMG=$1
docker tag $IMG hongkong.com:30002/library/$IMG
docker push hongkong.com:30002/library/$IMG
