#!/bin/bash

DEV="/dev/nvmen1p1"
DISKDIR="/mnt/nvme/nvme-tmp"

# Need to check this
mount {$DEV} ${DISKDIR}
cd ${DISKDIR}

btrfs subvolume snapshot @home $(date +%m-%d_%H-%M)

umount ${DISKDIR}