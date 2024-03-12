#!/bin/bash

# to use sudo with functions (made by SebMa https://unix.stackexchange.com/users/135038/sebma with small modifications)
function fsudo {
        local firstArg=$1
        if [ $(type -t $firstArg) = function ]
        then
                shift && command sudo -E bash -c "$(declare -f $firstArg);$firstArg $*"
        elif [ $(type -t $firstArg) = alias ]
        then
                alias sudo='\sudo '
                eval "sudo $@"
        else
                command sudo -E "$@"
        fi
}

# to install packages
function install {
paru -S $@ --needed --noconfirm
}

# to move config files
function mvc {
mkdir -p $2
cp -rf $HOME/dotfiles/$1 $2    # doesn't have teh variable because its with sudo (I don't know what i meant anymore)
}

# to have a more compact xdg-user-dirs :/
function xdg {
mkdir -p $2
xdg-user-dirs-update --set $1 $2
}

# to have a more compact librewolf addon setup
function addon {
wget https://addons.mozilla.org/firefox/downloads/file/$1/$2.xpi
mv $HOME/$2.xpi $HOME/$3.xpi
mv $HOME/$3.xpi $HOME/.librewolf/*.default-default/extensions/
}
