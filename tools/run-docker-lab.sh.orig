#!/bin/bash
#
# start the linux 0.11 lab via docker with the shared source in $PWD/
#

TOP_DIR=$(dirname `readlink -f $0`)

docker_image=tinylab/linux-0.11-lab
local_lab_dir=`dirname $TOP_DIR`
remote_lab_dir=/linux-0.11-lab/

browser=chromium-browser
remote_port=6080
local_port=$((RANDOM/500+6080))
url=http://localhost:$local_port/vnc.html
pwd=ubuntu

CONTAINER_ID=$(docker run -d -p $local_port:$remote_port -v $local_lab_dir:$remote_lab_dir $docker_image)

echo "Wait for lab launching..."
sleep 5

pwd=`docker logs $CONTAINER_ID 2>/dev/null | grep Password | sed -e "s/.* Password: \(.*\)$/\1/g"`

echo $local_port > $TOP_DIR/.lab_local_port
echo $pwd > $TOP_DIR/.lab_login_pwd

$TOP_DIR/open-docker-lab.sh
