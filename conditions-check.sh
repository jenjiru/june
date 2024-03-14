#!/bin/bash

pacman -Sy
pacman -S sbctl --noconfirm --needed

# Check if the system is booted with a 64-bit UEFI
if [ "$(cat /sys/firmware/efi/fw_platform_size  2>/dev/null)" != "64" ]; then
        echo -e "\033[0;31mError! NOT booted in 64-bit UEFI\033[0m" >&2
        exit  1
fi

# Check if the system is in Secure Boot setup mode
if sbctl status | grep -qE "Setup Mode.*Disabled"; then
    echo -e "\033[0;31mError! Not booted in Secure Boot setup mode\033[0m" >&2
    exit 1
fi
