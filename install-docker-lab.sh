#!/bin/bash
#
# need to run with sudo
#

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
version=`sed -n -e "/main$/p" /etc/apt/sources.list | head -1 | cut -d' ' -f3`
echo "deb https://apt.dockerproject.org/repo ubuntu-${version} main" > /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get -y install docker-engine
usermod -aG docker $USER

docker build -t tinylab/linux-0.11-lab ./

echo "Note: To let docker work without sudo, please restart the X session."

# pkill X
