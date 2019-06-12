#!/bin/bash
QEMU_PARAMS="-kernel $REEFTAS_OUT/tmp/deploy/images/$MACHINE/bzImage \
			   -drive file=$REEFTAS_OUT/tmp/deploy/images/$MACHINE/$IMAGE-$MACHINE.ext4,if=virtio,format=raw \
			   -show-cursor  \
			   -m 256 \
			   -append 'root=/dev/vda rw highres=off  mem=256M ip=192.168.7.2::192.168.7.1:255.255.255.0  '
"
DOCKDEV_VARIABLES=(\
  DOCKDEV_USER_NAME=$USER\
  DOCKDEV_USER_ID=$UID\
  DOCKDEV_GROUP_NAME=$(id -g -n $USER)\
  DOCKDEV_GROUP_ID=$(id -g $USER)\
  DISPLAY=$DISPLAY \
  QEMU_PARAMS=$QEMU_PARAMS \
)

cmd="docker run -v /tmp/.X11-unix:/tmp/.X11-unix "

if [ ! -z "${DOCKDEV_VARIABLES}" ]; then
  for v in ${DOCKDEV_VARIABLES[@]}; do
    cmd="${cmd} -e ${v}"
  done
fi



# /home/usr/data contains init.sh
echo $cmd $@ /usr/bin/init.sh
$cmd $@  /usr/bin/init.sh
