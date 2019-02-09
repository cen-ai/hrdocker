#!/bin/bash 

source $(dirname $0)/env.sh

snd_opts="--device /dev/snd \
	-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
    --env ALSA_CARD=Generic \
    -v /dev/snd:/dev/snd  \
	-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
    -v $HOME/.config/pulse/cookie:/root/.config/pulse/cookie \
	--group-add $(getent group audio | cut -d: -f3) \
	--group-add $(getent group video | cut -d: -f3)"

# Assorted grunge to let X11 use the 3D graphics acceleration.
# 11311 is the roscore port\
# -p 11311:11311 \
#--name="HEAD7" \
docker run -it \
    -e DISPLAY=$DISPLAY \
    --network host \
    --privileged \
    $snd_opts \
    -v /dev/dri:/dev/dri \
    -v /dev/shm:/dev/shm \
    -v /dev/video0:/dev/video0             \
    -v /run/dbus/:/run/dbus/:rw \
    -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
    $HR_IMAGE $*

