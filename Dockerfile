FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  vim tightvncserver xfce4 python-pip wmctrl mesa-utils wget freeglut3 libsdl1.2debian

EXPOSE 5900

RUN apt-get install -y libjpeg62 libcurl3

RUN wget -O itksnap.tar.gz https://sourceforge.net/projects/itk-snap/files/itk-snap/3.8.0/itksnap-3.8.0-20190612-Linux-x86_64.tar.gz/download && \
      tar xvzf itksnap.tar.gz && \
      rm itksnap.tar.gz

ENV PATH=$PATH:/itksnap-3.8.0-20190612-Linux-gcc64/bin/

ADD virtualgl_2.6_amd64.deb /
RUN dpkg -i /virtualgl_2.6_amd64.deb

ADD startvnc.sh /
ADD xstartup /root/.vnc/xstartup
ENV USER=root X11VNC_PASSWORD=override

CMD ["/startvnc.sh"]

