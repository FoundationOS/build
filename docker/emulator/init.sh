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

echo "$DOCKDEV_USER_NAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$DOCKDEV_USER_NAME

mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 666 /dev/net/tun

qemu-system-x86_64 -kernel $REEFTAS_OUT/tmp/deploy/images/$MACHINE/bzImage \
				   -drive file=$REEFTAS_OUT/tmp/deploy/images/$MACHINE/$IMAGE-$MACHINE.wic,if=virtio,format=raw \
				   -show-cursor  \
				   -m 256 \
				   -append 'root=/dev/vda2 rw highres=off  mem=256M ip=192.168.7.2::192.168.7.1:255.255.255.0  '
