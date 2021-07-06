#!/bin/bash

set -x

sudo apt update
sudo apt upgrade -y
docker pull bitwardenrs/server:latest
docker stop bitwarden
docker rm bitwarden
docker run -d --name bitwarden \
-v /bw-data/:/data/ \
-p 80:80 \
bitwardenrs/server:latest
docker update --restart unless-stopped bitwarden
docker ps
 
