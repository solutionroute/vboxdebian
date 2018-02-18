#!/bin/sh
# Installs a bunch of stuff; it's a dumb script.

#* XOrg
#* Window Manager: dwm / suckless-tools / st 
#* VirtualBox Guest Additions for Linux
#* Git
#* Go
#* Neovim

# Add some build tools needed by various apps including VBox

# TODO - add stretch-backports main contribu  - to /etc/apt/sources.list

# VBox pre-requisites
sudo apt-get install -y build-essential module-assistant
sudo m-a prepare
sudo apt-get install -y -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)

# tools
sudo apt-get install -y git

# XOrg
sudo apt-get install -y xorg
sudo apt-get install -y fontconfig pkgconfig libfreetype6 libfreetype6-dev xorg-dev
sudo apt-get install -y dwm
mkdir -p ~/src
cd ~/src
git clone git://git.suckless.org/st
cd st
make
sudo make install
cd ~/src
# grab the source for later customization
apt-get source dwm

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


# Finish off VirtualBox
sudo mount /dev/cdrom /media/cdrom 
cd /dev/cdrom
read -p "If the following command does not complete, check the end of this script and investigate /media/cdrom - is the ISO mounted?"
sudo ./VBoxLinuxAdditions.run
cd ~
echo "\nDone!"
