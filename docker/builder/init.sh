#!/bin/bash

if ! getent passwd $DOCKDEV_USER_NAME > /dev/null
  then
    echo "Creating user $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME"
    groupadd --gid $DOCKDEV_GROUP_ID -r $DOCKDEV_GROUP_NAME
    useradd --system --uid=$DOCKDEV_USER_ID --gid=$DOCKDEV_GROUP_ID \
        --home-dir /home --password $DOCKDEV_USER_NAME $DOCKDEV_USER_NAME
    usermod -a -G sudo $DOCKDEV_USER_NAME
    chown -R $DOCKDEV_USER_NAME:$DOCKDEV_GROUP_NAME /home
  fi
set -x

echo "TEMPLATECONF=$FOUNDATIONOS_CONF_DIR \
      source ${FOUNDATIONOS_ROOT}/platform/yocto/poky/oe-init-build-env ${FOUNDATIONOS_OUT} &&
      bitbake ${FOUNDATIONOS_IMAGE}" > /tmp/build.sh

sudo -E -u $DOCKDEV_USER_NAME bash -C "/tmp/build.sh"
if [ $? -ne 0 ]; then
	echo "FoundationOS build failed!!!!!"
	exit 1
fi
