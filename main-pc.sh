#!/bin/sh

#xrandr --output DisplayPort-0 --mode 3840x2160 --pos 1920x0 --rate 119.99 --output DisplayPort-1 --mode 1920x1080 --pos 0x0 --rate 74.97 --output HDMI-A-0 --mode 1920x1080 --pos 5760x0 --rate 74.97

# Updating system
paru -Syu --noconfirm

install etcher-bin gimp bitwarden spotify lutris multimc-bin jre-openjdk wally-cli qtwebflix-git wacom-settings-git libfido2 yubikey-personalization-gui tidal-hifi-bin avidemux-qt youtube-dl upscayl-bin

# tuta
install tutanota-desktop-bin
sudo mvc tutanota-desktop.desktop $HOME/.local/share/applications/

# Installing solaar
install solaar
echo '' | sudo tee -a /usr/local/bin/wm-program-check
echo '# solaar' | sudo tee -a /usr/local/bin/wm-program-check
echo 'slc=$(ps aux | grep solaar > /dev/null | wc -l) && if [ $slc -eq 1 ]; then solaar -w hide &; fi' | sudo tee -a /usr/local/bin/wm-program-check

# Installing discord
install discord-screenaudio
echo '' | sudo tee -a /usr/local/bin/wm-program-check
echo '# discord' | sudo tee -a /usr/local/bin/wm-program-check
echo 'dlc=$(ps aux | grep discord-screenaudio > /dev/null | wc -l) && if [ $dlc -le 2 ]; then discord-screenaudio &; fi' | sudo tee -a /usr/local/bin/wm-program-check

# Installing streamdeck
install streamdeck-ui
echo '' | sudo tee -a /usr/local/bin/wm-program-check
echo '# streamdeck' | sudo tee -a /usr/local/bin/wm-program-check
echo 'sd=$(ps aux | grep streamdeck > /dev/null | wc -l) && if [ $sd -eq 1 ]; then streamdeck --no-ui &; fi' | sudo tee -a /usr/local/bin/wm-program-check
sudo mkdir -p /usr/share/streamdeck/pictures
sudo cp $HOME/tmp-june/streamdeck/* /usr/share/streamdeck/pictures
curl -LO https://raw.githubusercontent.com/jenjiru/dotfiles/main/.streamdeck_ui.json

# Installing GitHub
install github-cli github-desktop-bin
mkdir $HOME/documents/github
git config --global user.email "94796499+jenjiru@users.noreply.github.com"
git config --global user.name "jenjiru"

# Installing steam
install steam
install protonup-qt proton-ge-custom-bin gamescope
rm .local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libfontconfig.so.1
ln -s /usr/lib/i386-linux-gnu/libfontconfig.so.1 ~/.local/share/Steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu/libfontconfig.so.1
install lib32-fontconfig
sudo setcap 'CAP_SYS_NICE=eip' $(which gamescope)

# thunderstore
install r2modman-bin

# Installing mangoHUD
install mangohud
mvc MangoHud.conf $HOME/.config/MangoHud

# Installing KVM
install qemu libvirt virt-manager lxsession dnsmasq   #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER
# sudo chown -R $USER:libvirt-qemu $HOME/documents/install_media
# mkdir $HOME/documents/kvms
# sudo chown -R $USER:libvirt-qemu $HOME/documents/kvms
# POOL_XML=$(cat <<EOF
# <pool type='dir'>
#   <name>install_media_pool</name>
#   <target>
#     <path>$HOME/documents/install_media</path>
#   </target>
# </pool>
# EOF
# )
# sudo virsh pool-define-as --name "install_media_pool" --type dir --target "$HOME/documents/install_media"
# sudo virsh pool-autostart "install_media_pool"
# sudo virsh pool-start "install_media_pool"
# POOL_UUID=$(sudo virsh pool-uuid "install_media_pool")
# sudo rm -f /etc/libvirt/storage/default-pool.xml
# sudo ln -s "/etc/libvirt/storage/${POOL_UUID}.xml" /etc/libvirt/storage/default-pool.xml
# sudo virsh pool-destroy default
# sudo virsh pool-undefine default
# sudo virsh pool-define-as --name default --type dir --target "$HOME/documents/kvms"
# sudo virsh pool-start default
# sudo virsh pool-autostart default
# sudo systemctl restart libvirtd
# sudo virsh pool-list | grep default

# a2ln
install a2ln
systemctl --user enable a2ln
sudo ufw allow 23045
echo '' | sudo tee -a /usr/local/bin/wm-program-check
echo '# a2ln' | sudo tee -a /usr/local/bin/wm-program-check
echo "a2ln --command 'notify-send \"{app}: {title}\" \"{body}\" --urgency=critical'" | sudo tee -a /usr/local/bin/wm-program-check

# sddm resolution
cd /usr/share/sddm/scripts/
sudo curl -LO https://raw.githubusercontent.com/jenjiru/dotfiles/main/Xsetup
cd $HOME

# monitor setup
rc_num=$(grep -n monitor $HOME/.config/awesome/rc.lua | cut -d : -f1)
rc_num=$(expr $rc_num + 1)
perl -i -slpe 'print $s if $. == $n; $. = 0 if eof' -- -n=$rc_num -s='awful.spawn.with_shell("xrandr --output DisplayPort-0 --mode 3840x2160 --pos 1920x0 --rate 119.99 --output DisplayPort-1 --mode 1920x1080 --pos 0x0 --rate 74.97 --output HDMI-A-0 --mode 1920x1080 --pos 5760x0 --rate 74.97")' $HOME/.config/awesome/rc.lua*

#cd /etc/X11/
#sudo curl -LO https://raw.githubusercontent.com/jenjiru/dotfiles/main/xorg.conf
#cd $HOME

# Wake on lan
#paru -S wol-systemd --noconfirm
#sudo systemctl enable wol@enp39s0
#sudo systemctl start wol@enp39s0

# ssh
#paru -S openssh --noconfirm
#sudo systemctl enable sshd.service
#sudo systemctl start sshd.service
