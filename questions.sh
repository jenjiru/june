#!/bin/bash

# --------------------------- Q-disk ---------------------------
if ! [ -e "/dev/vda" ]; then
	devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
	disk=$(whiptail --title "Installation Disk Selection" --menu "Select installation disk:"   25   80   0 --cancel-button Cancel --default-item "$(echo $devicelist | head -n1)" $(echo "$devicelist" | sed 's/\t/\\t/g')   3>&1   1>&2   2>&3) || exit   1
else
	disk="/dev/vda"
	usr_passwd=12
	luks_passwd=12
	drivers=testing
	res=1080p
	poweroff_q=0
	testing=0
fi

# --------------------------- passwd's ---------------------------
if [ "$disk" != "/dev/vda" ]; then
    # User password
    while true; do
        # Prompt for password
        usr_passwd=$(whiptail --passwordbox "Enter your user password:"   8   78 --title "Password Entry"   3>&1   1>&2   2>&3)
        exitstatus=$?
        if [ $exitstatus !=   0 ]; then
            break
        fi

        # Prompt for password confirmation
        confirm_passwd=$(whiptail --passwordbox "Confirm your user password:"   8   78 --title "Password Confirmation"   3>&1   1>&2   2>&3)
        exitstatus=$?
        if [ $exitstatus !=   0 ]; then
            break
        fi

        # Check if passwords match and are not empty
        if [ "$usr_passwd" == "$confirm_passwd" ] && [ -n "$usr_passwd" ]; then
            break
        else
            whiptail --msgbox "Passwords do not match or are empty. Please try again."   8   60 --title "Error"
        fi
    done

    # Encryption password
    while true; do
        # Prompt for password
        luks_passwd=$(whiptail --passwordbox "Enter your encryption password:"   8   78 --title "Password Entry"   3>&1   1>&2   2>&3)
        exitstatus=$?
        if [ $exitstatus !=   0 ]; then
            break
        fi

        # Prompt for password confirmation
        confirm_passwd=$(whiptail --passwordbox "Confirm your encryption password:"   8   78 --title "Password Confirmation"   3>&1   1>&2   2>&3)
        exitstatus=$?
        if [ $exitstatus !=   0 ]; then
            break
        fi

        # Check if passwords match and are not empty
        if [ "$luks_passwd" == "$confirm_passwd" ] && [ -n "$luks_passwd" ]; then
            break
        else
            whiptail --msgbox "Passwords do not match or are empty. Please try again."   8   60 --title "Error"
        fi
    done
fi

# --------------------------- Q-pc-type ---------------------------
pc_type=$(whiptail --title "PC type" --notags --nocancel --menu "Select the PC type"  25  78  5 \
        "general" "General" \
        "main" "Main PC" \
        "laptop" "Laptop"  3>&1  1>&2  2>&3)

if [ "$disk" != "/dev/vda" ]; then
	if [ "$pc_type" = "main" ]; then
		res=4k
		drivers=amd
	elif [ "$pc_type" = "laptop" ]; then
		res=1080p
		drivers=none
	fi
fi

# --------------------------- Q-drivers ---------------------------
if [ -z "$drivers" ]; then
    drivers=$(whiptail --title "GPU Drivers" --notags --nocancel --menu "Select GPU drivers"  25  78  5 \
            "nvidia" "Nvidia" \
            "amd" "AMD"  3>&1  1>&2  2>&3)
fi

# --------------------------- Q-resolution ---------------------------
if [ -z "$res" ]; then
    res=$(whiptail --title "Resolution" --notags --nocancel --menu "Select a resolution"  25  78  5 \
            "1080p" "1920x1080" \
            "ultrawide" "2560x1080" \
            "2k" "2560x1440" \
            "ultrawide2k" "3440x1440" \
            "4k" "3840x2160"  3>&1  1>&2  2>&3)
fi

# --------------------------- Q-poweroff/reboot ---------------------------
# if [ -z "$poweroff_q" ]; then
# 	whiptail --yesno "What to do after the script?" --yes-button "poweroff" --no-button "reboot"   10  40
# 	poweroff_q=$?
# fi

clear

