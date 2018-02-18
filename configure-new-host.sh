#!/bin/sh
# Installs a bunch of stuff; it's a dumb script.

#* XOrg
#* Window Manager: dwm / suckless-tools / st 
#* VirtualBox Guest Additions for Linux
#* Git
#* Go
#* Neovim

# Add some build tools needed by various apps including VBox

# VBox pre-requisites
sudo apt-get install -y build-essential module-assistant
sudo m-a prepare
sudo apt-get install -y -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)
read -p "Press any key to continue"
sudo mount /dev/cdrom /media/cdrom && cd /dev/cdrom
sudo ./VBoxLinuxAdditions.run
cd ~

# tools
sudo apt-get install -y git

# XOrg
sudo apt-get install -y xorg
sudo apt-get install -y dwm
mkdir -p ~/src
cd ~/src
git clone git://git.suckless.org/st
cd st
make
sudo make install

# TODO test for existance of .xinitrc otherwise create it

# ssh key gen
#
#
# add pip / setuptools
#
# add Neovim & python supports / Go / Python customization + dotfiles
#
#
# add Go / httphere / etc
