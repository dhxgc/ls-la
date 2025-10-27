#!/bin/bash

# DISKDIR - directory, where DEVICE is mounted
# HOMEDIR - directory, where mounted @home subvolume

DEV="/dev/nvmen1p1"
HOMEDIR="/mnt/nvme/home"
DISKDIR="/mnt/nvme/nvme-tmp"
SNAPSHOT="$1"

# ====================================================

# Mount drive without volumes
echo "Mounting dev without subvol..."
if [[ $2 == "--mount" ]]; then
	mount ${DEV} ${DISKDIR}
fi

echo "================="
echo "Check if @home is mounted..."
findmnt | grep ${HOMEDIR}
if [[ $? -eq 0 ]]; then
	umount ${HOMEDIR}
	echo "@home was unmounted"
else
	echo "@home wasn't unmounted, because it not mounted"
fi

cd ${DISKDIR}

# Remove broken @home subvolume, if it exist
echo "================="
echo "Deleting @home..."
if [ -d ${DISKDIR}/@home ]; then
	btrfs subvolume delete @home
	echo "@home was removed"
else
	echo "@home wasn't removed"
fi


# Create @home subvolume from snapshot
echo "================="
echo "Restoring from snapshot..."
if [ -d ${DISKDIR}/${SNAPSHOT} ]; then
	btrfs subvolume snapshot ${SNAPSHOT} @home
	echo "@home was restored"
	mount -a && umount ${DISKDIR}
else
	echo "Snapshot doesn't exist"
	exit 0
fi
