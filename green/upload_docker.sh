#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
# dockerpath=<your docker ID/path>
dockerpath=awsdev123/testgreenimage

# Step 2:  
# Authenticate & tag
echo "Docker ID and Image: $dockerpath"
docker login --username awsdev123
docker tag testgreenimage awsdev123/testgreenimage
# Step 3:
# Push image to a docker repository
docker push awsdev123/testgreenimage
