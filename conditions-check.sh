#!/bin/bash

if [ "$(cat /sys/firmware/efi/fw_platform_size  2>/dev/null)" != "64" ]; then
	echo -e "\033[0;31mError! NOT 64-bit UEFI booted\033[0m" >&2
	exit  1
fi
