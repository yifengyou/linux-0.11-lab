FROM dorowu/ubuntu-desktop-lxde-vnc
MAINTAINER Falcon wuzhangjin@gmail.com

RUN sed -i -e "s/archive.ubuntu.com/mirrors.163.com/g" /etc/apt/sources.list

RUN apt-get -y update

RUN apt-get install -y vim cscope exuberant-ctags build-essential qemu-system-x86

RUN apt-get install -y bochs vgabios bochsbios bochs-doc bochs-x libltdl7 bochs-sdl bochs-term

RUN apt-get install -y graphviz cflow

RUN apt-get install -y git ca-certificates

ADD . /linux-0.11-lab
RUN chmod -R 777 /linux-0.11-lab
WORKDIR /linux-0.11-lab

EXPOSE 6080
EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["/startup.sh"]
