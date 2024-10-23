#!/bin/bash

cd /home/jen/

source ./rice_variables

# logging
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/logging.sh)

# -------------- preperation --------------

# --- extra info :/ :{

# updating the system
sudo pacman -Syu --noconfirm

# getting functions
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/functions.sh)

# installing packages needed for the script :/
sudo pacman -S git base-devel imagemagick --needed --noconfirm

# downloading xyz for later use :/
# dotfiles
git clone https://github.com/jenjiru/dotfiles
# scripts and pictures
git clone https://github.com/jenjiru/tmp-june

# :( pacman
fsudo mvc pacman.conf /etc/

# updating repos
sudo pacman -Sy

# updating pacman keyring
sudo pacman-key --populate archlinux

# moving go directory :/
export GOPATH="$XDG_DATA_HOME"/go

# installing paru

{ git clone https://aur.archlinux.org/paru.git; cd paru ;
makepkg -si --noconfirm ; sudo rm -r $HOME/paru ;} || { git clone https://aur.archlinux.org/paru-bin.git; cd
paru-bin; makepkg-si --noconfirm; sudo rm -r $HOME/paru-bin ;}
cd $HOME
paru -Syu --noconfirm

# removing tmp packages
paru -Rsn $(paru -Qdtq) 2>/dev/null --noconfirm

# isntalling rust
install rust

# Installing extra firmware to get rid of the warnings when installing packages :/
install mkinitcpio-firmware

# creating GnuPG directory to insure ever package gets installed properly :/
mkdir -p $HOME/.local/share/gnupg/

# installing rpm tools
install rpm-tools

# -------------- setting up other stuff :/ --------------

# changing keymap
sudo localectl set-keymap de-latin1

# changing timezone
sudo timedatectl set-timezone Europe/Berlin
sudo systemctl enable systemd-timesyncd --now

# setting up xdg :/
install xdg-user-dirs selectdefaultapplication-fork-git
xdg DOWNLOAD $HOME/downloads
xdg PUBLICSHARE $HOME/misc/public
xdg DOCUMENTS $HOME/documents
xdg MUSIC $HOME/misc/music
xdg PICTURES $HOME/pictures
xdg VIDEOS $HOME/pictures/videos
xdg DESKTOP $HOME/misc/desktop
xdg TEMPLATES $HOME/documents/templates

# extra directory(s)
# mkdir $HOME/documents/install_media

# setting up default applications
mvc mimeapps.list $HOME/.config

# setting up scripts :/
install aria2
sudo cp $HOME/tmp-june/scripts/* /usr/local/bin/
ls -A1 $HOME/tmp-june/scripts | xargs -i echo /usr/local/bin/{} | xargs -L1 sudo chmod +x
cp -r $HOME/tmp-june/scripts-pic $HOME/pictures
sudo mv /opt/hysome /usr/local/bin
sudo chmod +x /usr/local/bin/hysome

# setting up wallpapers :/
install feh
git clone https://gitlab.com/jenjiru/wallpaper.git $HOME/pictures/wallpaper
sudo rm -r $HOME/pictures/wallpaper/.git
mvc .fehbg $HOME
if [ "$testing" = "0" ]
then
  sed -i '$s/$/ravens\/dark-raven.webp/' $HOME/.fehbg
else
  sed -i '$s/$/ravens\/stains_white-raven.webp/' $HOME/.fehbg
fi
chmod +x $HOME/.fehbg

# -------------- setting up programms :/ --------------

# Installing Keyring
install gnome-keyring
mkdir -p $HOME/.librewolf/native-messaging-hosts
echo 'auth optional pam_gnome_keyring.so' | sudo tee -a /etc/pam.d/login
echo 'session optional pam_gnome_keyring.so auto_start' | sudo tee -a /etc/pam.d/login
dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# --security--
# ufw
install ufw
sudo systemctl enable ufw.service --now
sudo ufw allow VNC
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
# ---

# changing bash-files location
# check all of this again :{
mkdir -p $HOME/.cache/bash/
mkdir -p $HOME/.config/bash/
mv .bash_logout $HOME/.cache/bash/
mv .bash_profile $HOME/.config/bash/
mv .bashrc $HOME/.config/bash/

# Installing dash
install dash
sudo ln -sfT /bin/dash /bin/sh
fsudo mvc bash-update.hook /usr/share/libalpm/hooks/

# Installing zsh
install zsh thefuck zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search zsh-theme-powerlevel10k spaceship-prompt
mkdir -p $HOME/.cache/zsh
mvc .zshenv $HOME
mvc .zshrc $HOME/.config/zsh
mvc .p10k.zsh $HOME/.config/zsh

# aliases
mvc aliasrc $HOME/.config

# reflector setup
install reflector
fsudo mvc reflector.conf /etc/xdg/reflector/
sudo systemctl enable reflector.service --now
sudo reflector --country 'Germany' --latest 30 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Setting up audio
install alsa-ucm-conf
install pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber carla pavucontrol
mvc 51-alsa-disable.lua $HOME/.config/wireplumber/main.lua.d/
systemctl enable --user pipewire pipewire-pulse wireplumber

# picom setup
install picom
mvc picom.conf $HOME/.config/picom/

# alacritty config
install alacritty
mvc alacritty.toml $HOME/.config/alacritty/

# xorg setup
install xorg-server xorg-xinit

# awesome Setup
install awesome
mkdir -p $HOME/.config/awesome/
mvc rc.lua $HOME/.config/awesome
mvc mytheme.lua $HOME/.config/awesome
git clone https://github.com/Elv13/collision $HOME/.config/awesome/collision

# wayland setup
install wayland lib32-wayland wayland-protocols qt5-wayland qt6-wayland xorg-xwayland wlr-randr python-pywayland

# Hyprland setup
install wlroots-hidpi-xprop
install hyprland hyprlock hyprpaper xdg-desktop-portal-hyprland xdg-desktop-portal-gtk hyprpicker-git wl-clipboard dunst
mvc hyprland.conf $HOME/.config/hypr
mvc hyprlock.conf $HOME/.config/hypr
mvc hyprpaper.conf $HOME/.config/hypr
if [ $drivers = "amd" ]; then
ln -sf /dev/dri/by-path/pci-0000:03:00.0-card $HOME/.config/hypr/ecard
ln -sf /dev/dri/by-path/pci-0000:18:00.0-card $HOME/.config/hypr/icard
fi

# Plymouth theming
# paru -S plymouth-theme-neat --noconfirm
# sudo plymouth-set-default-theme -R neat

# wofi setup
install wofi
mvc wofi $HOME/.config

# # installing ydotool
# paru -S scdoc --noconfirm && \
# git clone https://github.com/ReimuNotMoe/ydotool.git && \
# cd ydotool && \
# mkdir build && \
# cd build && \
# cmake .. && \
# make -j $(nproc) && \
# sudo make install && \
# cd $HOME && \
# rm -rf ydotool
# echo 'ALL ALL=(ALL) NOPASSWD: /usr/local/bin/ydotool' | sudo EDITOR='tee -a' visudo
# echo 'ALL ALL=(ALL) NOPASSWD: /usr/local/bin/ydotoold' | sudo EDITOR='tee -a' visudo

# waybar setup
install waybar
mvc waybar $HOME/.config

# eww setup
install eww-tray-wayland-git

# ---drivers setup---
if [ $drivers = "nvidia" ]; then
        install nvidia nvidia-utils lib32-nvidia-utils nvidia-settings opencl-nvidia nvidia-dkms
		echo "env = LIBVA_DRIVER_NAME,nvidia" > $HOME/.config/hypr/hyprland.conf
		echo "env = XDG_SESSION_TYPE,wayland" > $HOME/.config/hypr/hyprland.conf
		echo "env = GBM_BACKEND,nvidia-drm" > $HOME/.config/hypr/hyprland.conf
		echo "env = __GLX_VENDOR_LIBRARY_NAME,nvidia" > $HOME/.config/hypr/hyprland.conf
		echo "env = WLR_NO_HARDWARE_CURSORS,1" > $HOME/.config/hypr/hyprland.conf
elif [ $drivers = "amd" ]; then
	install mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau
elif [ $drivers = "testing" ]; then
	install xf86-video-amdgpu
fi

# Setup for testing
if [ "$testing" = "0" ]
then
	sudo sed -i 's/^TryExec=picom/#&/' /etc/xdg/autostart/picom.desktop
	sudo sed -i 's/^Exec=picom/#&/' /etc/xdg/autostart/picom.desktop
        fsudo mvc 52-resolution-fix.conf /etc/X11/xorg.conf.d/
fi

# rofi setup
install rofi
mvc config.rasi $HOME/.config/rofi
mvc power.rasi $HOME/.config/rofi
mvc rofi3.druncache $HOME/.cache
fsudo mvc config.rasi /root/.config/rofi
fsudo mvc power.rasi /root/.config/rofi
fsudo mvc rofi3.druncache $HOME/.cache

# themes
install qogir-gtk-theme oxygen-cursors bibata-cursor-theme-bin lxappearance nwg-look
# mvc settings.ini $HOME/.config/gtk-3.0
# mvc .gtkrc-2.0 $HOME
# mvc index.theme $HOME/.icons/default/
# fsudo mvc settings.ini /root/.config/gtk-3.0
# fsudo mvc .gtkrc-2.0 /root/
# fsudo mvc index.theme /root/.icons/default/

# installing SDDM
install sddm sddm qt5‑graphicaleffects qt5‑quickcontrols2 qt5‑svgz
curl -LO https://gitlab.com/Matt.Jolly/sddm-eucalyptus-drop/-/archive/master/sddm-eucalyptus-drop-master.zip
unzip sddm-eucalyptus-drop-master.zip
rm -rf sddm-eucalyptus-drop-master.zip
sudo mv sddm-eucalyptus-drop-master /usr/share/sddm/themes
sudo systemctl enable sddm.service
fsudo mvc sddm.conf /etc/sddm.conf.d/
fsudo mvc theme.conf /usr/share/sddm/themes/sugar-candy/
sudo cp $HOME/tmp-june/pictures/login-dark-raven.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/

# theming grub
# fsudo mvc grub /etc/default/
# git clone https://github.com/vinceliuice/grub2-themes
# cp $HOME/tmp-june/pictures/grub-rocket-dark.jpg $HOME/grub2-themes/background.jpg
# sudo $HOME/grub2-themes/install.sh -b -t whitesur -s $res -i white
# sudo rm -r grub2-themes
# sudo sed -i 's/, with Linux linux//g' /boot/grub/grub.cfg
# install grub-customizer

# Installing fonts
install ttf-jetbrains-mono-nerd noto-fonts-cjk ttf-ancient-fonts fonts-noto-hinted terminus-font gnu-free-fonts ttf-liberation noto-fonts-cjk noto-fonts-emoji adobe-source-sans-fonts powerline-fonts # ttf-ms-win11-auto

# Setting up the printer
if [[ "$testing" -eq   1 && ("$pc_type" == "main" || "$pc_type" == "laptop") ]]; then
install cups cups-pdf
sudo systemctl enable --now cups
sudo usermod -aG lp $USER
install system-config-printer
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now systemd-resolved
# sudo lpadmin -p "EPSON_WF-2930" -E -v "dnssd://EPSON%20WF-2930%20Series._ipp._tcp.local/?uuid=cfe92100-67c4-11d4-a45f-dccd2f75ee23" -m "everywhere"
sudo systemctl restart cups
fi

# Setting up bluetooth
install bluez bluez-utils bluez-libs bluez-utils
install bluez-tools overskride blueberry
sudo systemctl enable --now bluetooth.service

# Setting up dkms
install dkms linux-headers

# Setting up controllers
install xpadneo-dkms
install joycond-git
sudo systemctl enable joycond

# Setting up redshift
install redshift-minimal
mvc redshift.conf $HOME/.config

# Setting up wget
install wget
mvc wgetrc $HOME/.config/wget

# Setting up timeshift
install timeshift

# Setting up flameshot
install flameshot
mvc flameshot.ini $HOME/.config/flameshot

# PDF-Viewer setup
install evince-no-gnome
gsettings set org.gnome.Evince page-cache-size 'uint32 1000'

# Installing packages
install libreoffice-fresh libreoffice-fresh-de nemo signal-desktop lf-bin eza htop tldr++ bat downgrade procs rsync man xdg-ninja exfat-utils fzf galculator btop bottom arandr mpv peazip cups qbittorrent obsidian zip vscodium-bin ranger xterm stress ntfs-3g xorg-xev advcpmv blanket polkit-gnome cmake wget yarn paruz rawtherapee ninja meson gparted dnsutils socat xdotool tofi chromium nvtop hyprshot iwd iwgtk


# Setting up Neovim
install neovim vim-commentary neovim-surround vim-visual-multi neovim-nerdtree vim-devicons # vim-nerdtree-syntax-highlight nvim-packer-git :{
mvc init.lua $HOME/.config/nvim

# Setting up nsxiv
git clone https://github.com/nsxiv/nsxiv
cd $HOME/nsxiv
mvc config.h $HOME/nsxiv
sudo make install-all
cd $HOME
sudo rm -r $HOME/nsxiv

# networkmanager
install networkmanager
sudo systemctl enable NetworkManager.service --now

# setting up ripgrep
install ripgrep
mkdir -p $HOME/.config/ripgrep
touch $HOME/.config/ripgrep/ripgreprc

# setting up syncthing
install syncthing
echo "" >> .config/awesome/rc.lua
echo "-- syncthing" >> .config/awesome/rc.lua
echo 'awful.spawn.with_shell("syncthing")' >> .config/awesome/rc.lua
sudo ufw allow 631/tcp
sudo ufw allow 515/tcp

# setting up Librewolf
install librewolf-bin
librewolf --headless &
sleep 10
pkill -SIGTERM librewolf
# downloading addons
addon 3902154 decentraleyes-2.0.17 jid1-BoFifL9Vbdl2zQ@jetpack # decentraleyes
addon 3910598 canvasblocker-1.8 CanvasBlocker@kkapsner.de # canvasblocker
addon 3980848 clearurls-1.25.0 {74145f27-f039-47ce-a470-a662b129930a} # clear urls
addon 3993826 duckduckgo_for_firefox-2022.8.25 jid1-ZAdIEUB7XOzOJw@jetpack # duckduckgo
addon 4006940 sponsorblock-5.0.5 sponsorBlocker@ajay.app # sponsor block
addon 3449086 df_youtube-1.13.504 dfyoutube@example.com # df youtube
addon 4005382 return_youtube_dislikes-3.0.0.6 {762f9885-5a13-4abd-9c77-433dcd38b8fd} # return youtube dislikes
addon 4027038 youtube_shorts_block-1.3.4.xpi {34daeb50-c2d2-4f14-886a-7160b24d66a4} # youtube shorts block
addon 3982830 distract_me_not-2.8.0.xpi {5f884915-160e-4276-a216-770a753a3abe} # distract me not
# setting up addons
mvc extension-preferences.json $HOME/.librewolf/*.default-default/

# -------------- :( --------------

# remove tmp packages
paru -Rsn $(paru -Qdtq) 2>/dev/null --noconfirm

# remove script :/
sudo rm -r $HOME/tmp-june
sudo rm -r $HOME/dotfiles
rm -f $HOME/rice.sh
rm -f $HOME/rice_variables

# possibly starting main-pc.sh :/
if [ "$pc_type" = "main" ]
then
	source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/main-pc.sh)
fi

# ----------

# adding the need for a passwd :/
sudo sed -i '$ d' /etc/sudoers

# endscreen with script duration
source <(curl -s https://raw.githubusercontent.com/jenjiru/june/main/time.sh)

# -----------

# Would be a good idea to change or document the autostart of programms with rc.lua
