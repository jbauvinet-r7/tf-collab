#!/bin/bash

repository_url=$1
aws_region=$2

# Build the Docker image locally
docker build -t helloo-world:latest .

# Authenticate Docker to your ECR registry
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $repository_url
docker pull 739423076117.dkr.ecr.us-east-1.amazonaws.com/ias-sim-lab:juice-shop
# Tag the Docker image
docker tag 739423076117.dkr.ecr.us-east-1.amazonaws.com/ias-sim-lab:juice-shop 739423076117.dkr.ecr.$aws_region.amazonaws.com/ias-sim-lab:juice-shop:juice-shop

# Push the Docker image to ECR
docker push $repository_url:juice-shop