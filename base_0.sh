#!/bin/bash

# https://wiki.archlinux.org/title/User:ZachHilman/Installation_-_Btrfs_%2B_LUKS2_%2B_Secure_Boot

# Clear and create GPT table
sgdisk --zap-all $disk

# creating partitions
sgdisk --clear --new=1:0:+512MiB --typecode=1:ef00 --change-name=1:EFI --new=2:0:+4GiB --typecode=2:8200 --change-name=2:cryptswap --new=3:0:0 --typecode=3:8300 --change-name=3:cryptsystem $disk

# Encrypted Containers
cryptsetup luksFormat --type luks2 --align-payload=8192 -s 256 -c aes-xts-plain64 --batch-mode /dev/disk/by-partlabel/cryptsystem <(echo -n "$luks_passwd")
temp_file=$(mktemp)
echo -n "$luks_passwd" > "$temp_file"
trap "rm -f $temp_file" EXIT
cryptsetup open /dev/disk/by-partlabel/cryptsystem system --key-file "$temp_file"

# Swap
cryptsetup open --type plain --key-file /dev/urandom --batch-mode /dev/disk/by-partlabel/cryptswap swap
mkswap -L swap /dev/mapper/swap
swapon -L swap

# Btrfs
mkfs.btrfs --label system /dev/mapper/system
mount -t btrfs LABEL=system /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
umount -R /mnt

mount -t btrfs -o defaults,x-mount.mkdir,ssd,noatime,subvol=@root LABEL=system /mnt
mount -t btrfs -o defaults,x-mount.mkdir,ssd,noatime,subvol=@home LABEL=system /mnt/home
mount -t btrfs -o defaults,x-mount.mkdir,ssd,noatime,subvol=@snapshots LABEL=system /mnt/.snapshots

# EFI System Partition
mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI
mkdir /mnt/efi
mount LABEL=EFI /mnt/efi

# keyring
pacman -Sy archlinux-keyring

# Install Base System
pacstrap /mnt base linux linux-firmware
genfstab -L -p /mnt >> /mnt/etc/fstab
sed -i 's/LABEL=swap/\/dev\/mapper\/swap/g' /mnt/etc/fstab
echo "swap /dev/disk/by-partlabel/cryptswap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=256" >> /mnt/etc/crypttab
