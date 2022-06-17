#! /bin/bash

# Formatting the disk
# To maximize disk performance, use the recommended formatting options in the -E flag. 
# It is not necessary to reserve space for the root volume on this secondary disk, so specify -m 0 to use all of the available disk space.
sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

# Mounting the disk
# Create a directory that serves as the mount point for the new disk on the VM. 
# You can use any directory. The following example creates a directory under /mnt/disks/.
sudo mkdir -p /mnt/disks/data

# Use the mount tool to mount the disk to the instance, and enable the discard option:
sudo mount -o discard,defaults /dev/sdb /mnt/disks/data

## Configure read and write permissions on the disk.
sudo chmod a+w /mnt/disks/data


# Configuring automatic mounting on VM restart
sudo cp /etc/fstab /etc/fstab.backup # Create a backup of your current /etc/fstab file.

# Use the blkid command to list the UUID for the disk.
sudo blkid /dev/sdb

# Open the /etc/fstab file in a text editor and create an entry that includes the UUID. For example:
uuid=$(blkid -o value -s UUID /dev/sdb)
UUID=$uuid /mnt/disks/data ext4 discard,defaults,nofail 0 2

# Use the cat command to verify that your /etc/fstab entries are correct
# cat /etc/fstab