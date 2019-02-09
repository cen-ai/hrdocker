#
# Base ROS indigo installation.
# Bare bones install; does not launch any nodes.
#
# To build:
# docker build -t opencog/ros-indigo-base .
#
# To run:
# docker run --rm --name="indigo-base" -i -t opencog/ros-indigo-base
#
FROM ubuntu:16.04
MAINTAINER Ed Guy "edguy@eguy.org"

# Avoid triggering apt-get dialogs (which may lead t o errors). See:
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        curl \
        jq \
        lsb-core \
        parallel \
        python-configobj \
        python-pip \
        python-virtualenv \
        python3-pip \
        software-properties-common \
        wget \
        x11-apps \
    && add-apt-repository ppa:graphics-drivers/ppa \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y nvidia-390

RUN pip install python-dateutil==2.5.0 \
    && pip install numpy==1.12.0


RUN apt-get update \
    && wget https://github.com/hansonrobotics/hrtool/releases/download/v0.12.6/head-hr_0.12.6_amd64.deb \
    && dpkg -i head-hr_0.12.6_amd64.deb  \
    && apt install -f -y 
RUN apt-get install -y npm
RUN ASSUME_YES=1 hr install head 
RUN ASSUME_YES=1 hr install -p head-basic-head-api \
    && ASSUME_YES=1 hr install head-hr-msgs \
    && ASSUME_YES=1 hr install head-ros-tts 
RUN ASSUME_YES=1 hr role user

RUN apt-get install -y vim

RUN cd /root/hansonrobotics/launchpad \
    && git remote rename origin upstream \
    && git remote add origin https://github.com/cen-ai/launchpad.git \
    && git fetch origin \
    && git branch --set-upstream-to=origin/master \
    && git pull 

COPY scripts/runRunRobot.sh /root/bin/

RUN /opt/hansonrobotics/py2env/bin/python -m pip install --upgrade python-dateutil==2.5.0 numpy==1.12.0 pip

CMD ["/root/bin/runRunRobot.sh"]

