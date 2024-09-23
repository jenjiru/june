#!/bin/bash

# Set the time zone to Berlin
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# Set the locale
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Set the keyboard layout to German
echo KEYMAP=de-latin1 > /etc/vconsole.conf

# Set the hostname
echo btw > /etc/hostname

# more packages
pacman -Syu networkmanager git base-devel btrfs-progs gptfdisk zsh sudo ttf-dejavu sbctl amd-ucode polkit-gnome vim --noconfirm

# Unified Kernel Image Setup
if [ $drivers = "amd" ]; then
        sed -i '/^MODULES=/c\MODULES=(amdgpu)' /etc/mkinitcpio.conf
elif [ $drivers = "nvidia" ]; then
	sed -i '/^MODULES=/c\MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' /etc/mkinitcpio.conf
    echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf
fi

sed -i '/^HOOKS=/c\HOOKS=(base systemd plymouth modconf keyboard keymap block filesystems btrfs sd-encrypt fsck)' /etc/mkinitcpio.conf

echo "fbcon=rd.driver.pre=vfio-pci amd_iommu=on iommu=pt video=efifb:off nodefer rw rd.luks.allow-discards quiet bgrt_disable root=LABEL=system rootflags=subvol=@root,rw splash vt.global_cursor_default=0" > /etc/kernel/cmdline

echo "system /dev/disk/by-partlabel/cryptsystem none timeout=180,tpm2-device=auto" > /etc/crypttab.initramfs   # system /dev/disk/by-partlabel/cryptsystem none timeout=180,tpm2-device=auto

sbctl create-keys

sbctl bundle -s /efi/main.efi

pacman -S efibootmgr --noconfirm

efibootmgr --create --disk $disk --part 1 --label "Linux" --loader 'main.efi' --unicode

# users
usermod --lock root
useradd -m -G wheel jen
echo "jen:${usr_passwd}" | chpasswd
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers

# plymouth
pacman -S plymouth --noconfirm
plymouth-set-default-theme -R Spinfinity
# sudo sbctl generate-bundles -s
# sudo sbctl enroll-keys -m
read

systemctl enable NetworkManager.service
