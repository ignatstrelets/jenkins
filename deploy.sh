#!/bin/bash

echo "Starting to deploy docker image.."
CURRENT_IMAGE=$DOCKER_REPO/$DOCKER_IMAGE:latest
docker pull $CURRENT_IMAGE
docker ps -q --filter ancestor=$DOCKER_IMAGE | xargs -r docker stop
docker run -d -p $APP_PORT:$APP_PORT $CURRENT_IMAGE
