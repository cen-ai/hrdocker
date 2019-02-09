#!/bin/bash

#
# build.sh
#
# Build this docker image.
#
source $(dirname $0)/env.sh

docker build -t $HR_IMAGE .
