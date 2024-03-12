#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/conditions-check.sh)

source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/logo.sh)

loadkeys de

# questions
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/questions.sh)

# Time
timedatectl set-ntp true
timedatectl set-timezone Europe/Berlin
systemctl enable systemd-timesyncd --now

# exporting eviormental variables
export testing; export res; export drivers; export pc_type; export usr_passwd; export luks_passwd; export disk

# base install first step
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/base_0.sh)

# base install second step
curl -LO https://raw.githubusercontent.com/jenjiru/june/main/base_1.sh
mv base_1.sh /mnt/
chmod +x /mnt/base_1.sh
arch-chroot "/mnt" "/bin/bash" -c "bash /base_1.sh ; rm /base_1.sh ; exit"

# rice
echo "export testing=\"$testing\"" >> ./rice_variables
echo "export res=\"$res\"" >> ./rice_variables
echo "export drivers=\"$drivers\"" >> ./rice_variables
echo "export pc_type=\"$pc_type\"" >> ./rice_variables
mv rice_variables /mnt/home/jen

curl -LO https://raw.githubusercontent.com/jenjiru/june/main/rice.sh
mv rice.sh /mnt/home/jen
chmod +x /mnt/home/jen/rice.sh

arch-chroot "/mnt" "/bin/bash" -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo ; su -l -c 'bash rice.sh' jen ; exit"

# reboot in to bios
if [ "$disk" != "/dev/vda" ]; then
	systemctl reboot --firmware-setup
else
	reboot
fi
