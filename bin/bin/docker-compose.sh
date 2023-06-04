#!/bin/sh
docker run --rm -v $(pwd):/app \
  -e DOCKER_IP=$DOCKER_IP \
  -e HOME=$HOME \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$(pwd):$(pwd)" -w "$(pwd)" \
  -it docker/compose:1.18.0 ${1+"$@"}
#  -it dduportal/docker-compose ${1+"$@"}
                                            
