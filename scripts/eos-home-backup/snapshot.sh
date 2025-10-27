#!/bin/bash

DEV="/dev/nvme0n1p1"
DISKDIR="/mnt/nvme/nvme-tmp"

# Need to check this
mount ${DEV} ${DISKDIR}
cd ${DISKDIR}
btrfs subvolume snapshot @home $(date +%m-%d_%H-%M)

echo "Sleep on 5 seconds..."
sleep 5
umount ${DISKDIR}

