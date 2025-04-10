#!/bin/bash

curl -LO https://raw.githubusercontent.com/jenjiru/june/main/conditions-check.sh
bash conditions-check.sh > /dev/null 2>&1 &
conditions_check_PID=$!

source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/logo.sh)
sh ./error.sh

loadkeys de

# questions
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/questions.sh)

# Time
timedatectl set-ntp true
timedatectl set-timezone Europe/Berlin
systemctl enable systemd-timesyncd --now

# exporting eviormental variables
export testing; export res; export drivers; export pc_type; export usr_passwd; export luks_passwd; export disk
read

# base install first step
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/base_0.sh)
read

# base install second step
curl -LO https://raw.githubusercontent.com/jenjiru/june/main/base_1.sh
mv base_1.sh /mnt/
chmod +x /mnt/base_1.sh
read

arch-chroot "/mnt" "/bin/bash" -c "bash /base_1.sh ; rm /base_1.sh ; exit"
read

# rice
echo "export testing=\"$testing\"" >> ./rice_variables
echo "export res=\"$res\"" >> ./rice_variables
echo "export drivers=\"$drivers\"" >> ./rice_variables
echo "export pc_type=\"$pc_type\"" >> ./rice_variables
mv rice_variables /mnt/home/jen
read

curl -LO https://raw.githubusercontent.com/jenjiru/june/main/rice.sh
mv rice.sh /mnt/home/jen
chmod +x /mnt/home/jen/rice.sh
read

arch-chroot "/mnt" "/bin/bash" -c "echo '%wheel ALL=(ALL) NOPASSWD: ALL' | EDITOR='tee -a' visudo ; su -l -c 'bash rice.sh' jen ; exit"
read

# reboot in to bios
if [ "$disk" != "/dev/vda" ]; then
	systemctl reboot --firmware-setup
else
	reboot
fi
