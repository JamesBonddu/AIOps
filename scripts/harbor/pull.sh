#!/bin/bash
img=$1
docker pull 47.242.140.211:30002/library/$img
docker tag 47.242.140.211:30002/library/$img $img
