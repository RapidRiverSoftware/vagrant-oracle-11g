# Mount a big ol' drive for Oracle
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 512 100%
mkfs.ext4 /dev/sdb1
mkdir /oracle
echo `blkid /dev/sdb1 | awk '{print $2}' | sed -e 's/"//g'` /oracle ext4 noatime,nobarrier 0 0 >> /etc/fstab
mount /oracle
