FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
MAINTAINER Soichi Hayashis <hayashis@iu.edu>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y vim tightvncserver xfce4 python-pip wmctrl mesa-utils tightvncserver xfce4 wget freeglut3 libsdl1.2debian

EXPOSE 5900

#We are not allowed to re-distribute TrackVis software. It has to be mounted from the host
#-v /usr/local/licensed-bin
RUN apt-get install -y libjpeg62

ADD virtualgl_2.6_amd64.deb /
RUN dpkg -i /virtualgl_2.6_amd64.deb

ADD startvnc.sh /
ADD xstartup /root/.vnc/xstartup
ENV USER=root X11VNC_PASSWORD=override

CMD ["/startvnc.sh"]

