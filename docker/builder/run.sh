#!/bin/bash

DOCKDEV_VARIABLES=(\
  DOCKDEV_USER_NAME=$USER\
  DOCKDEV_USER_ID=$UID\
  DOCKDEV_GROUP_NAME=$(id -g -n $USER)\
  DOCKDEV_GROUP_ID=$(id -g $USER)\
)

cmd="docker run"

if [ ! -z "${DOCKDEV_VARIABLES}" ]; then
  for v in ${DOCKDEV_VARIABLES[@]}; do
    cmd="${cmd} -e ${v}"
  done
fi

# /home/usr/data contains init.sh
echo $cmd $@ /usr/bin/init.sh
$cmd $@ /usr/bin/init.sh
