#!/bin/bash

rm ./conditions-check.sh

pacman -Sy
pacman -S sbctl --noconfirm --needed

# Check if the system is booted with a 64-bit UEFI
if [ "$(cat /sys/firmware/efi/fw_platform_size  2>/dev/null)" != "64" ]; then
        echo 'echo -e "\033[0;31mError! NOT booted in 64-bit UEFI\033[0m" >&2' >> error.sh
fi

# Check if the system is in Secure Boot setup mode
if sbctl status | grep -qE "Setup Mode.*Disabled"; then
    echo 'echo -e "\033[0;31mError! Not booted in Secure Boot setup mode\033[0m" >&2' >> error.sh
fi

if [ -f "error.sh" ]; then
    echo "rm ./error.sh" >> "error.sh"
    echo "exit 1" >> "error.sh"
fi

sleep 10
