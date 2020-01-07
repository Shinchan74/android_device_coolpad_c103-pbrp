#!/sbin/sh
#
# Unlock vendor partition
#

VENDOR=/dev/block/bootdevice/by-name/vend
BLOCKDEV=/dev/block/mmcblk0

safeRunCommand() {
   cmnd="$@"
   $cmnd
   ERROR_CODE=$?
   if [ ${ERROR_CODE} != 0 ]; then
      printf "Error when executing command: '${command}'\n"
      exit ${ERROR_CODE}
   fi
}

if [ ! -e "$VENDOR" ]; then
    echo "Vendor partition does not exist"

    command="/sbin/sgdisk --change-name=35:vendor $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --delete=27 $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --delete=35 $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --new=27:580M:4000M $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --new=35:4010M:4650M $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --change-name=27:system $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --change-name=35:vendor $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --typecode=27:8300 $BLOCKDEV"
    safeRunCommand $command

    command="/sbin/sgdisk --typecode=35:8300 $BLOCKDEV"
    safeRunCommand $command

else
    echo "Found vendor partiton. Good!"
fi

exit 0
