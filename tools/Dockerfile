FROM dorowu/ubuntu-desktop-lxde-vnc
MAINTAINER Falcon wuzhangjin@gmail.com

RUN sed -i -e "s/archive.ubuntu.com/mirrors.163.com/g" /etc/apt/sources.list

RUN apt-get -y update

RUN apt-get install -y vim cscope exuberant-ctags

RUN apt-get install -y build-essential gcc gdb binutils

RUN apt-get install -y qemu-system-x86

RUN apt-get install -y bochs vgabios bochsbios bochs-doc bochs-x libltdl7 bochs-sdl bochs-term

RUN apt-get install -y graphviz cflow

RUN apt-get install -y git ca-certificates

RUN apt-get install -y xz-utils

# Allow ubuntu user use sudo without password
ADD sudoers.d/ubuntu /etc/sudoers.d/
RUN chmod 440 /etc/sudoers.d/ubuntu

# Add shortcuts on Desktop
ADD linux-lab.desktop /

# Add lab-name
ADD lab-name /

# Tune the screen size
ADD supervisord.conf /etc/supervisor/conf.d/

ADD startup.sh /

EXPOSE 6080
EXPOSE 5900
EXPOSE 22

ENTRYPOINT ["/startup.sh"]
