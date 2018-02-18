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
sudo apt-get install build-essential module-assistant
sudo m-a prepare
sudo apt-get install -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)

# tools
sudo apt-get install git

# XOrg
sudo apt-get install xorg
sudo apt-get install dwm
mkdir -p ~/src
cd ~/src
git clone git://git.suckless.org/st
cd st
make
sudo make install

# TODO test for existance of .xinitrc otherwise create it

# add pip / setuptools
#
# add Neovim
#
#

