#!/bin/sh
# Installs a bunch of stuff; it's a dumb script.
# Add some build tools needed by various apps including VBox

# Update version as need be from: https://golang.org/dl/
export GOVERSION=1.10

# Just in case
sudo apt-get update

# TODO ensure not root
# TODO - add test for stretch-backports main contrib in   /etc/apt/sources.list

cd ~
# for later
mkdir -p src
mkdir -p go/src

# Installing go early on since it has no dependencies
if grep -q "/usr/local/go/bin" /etc/bash.bashrc
then
    echo "Go already installed, skipping"
else
	echo $GOVERSION
	wget https://dl.google.com/go/go$GOVERSION.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz
	rm go$GOVERSION.linux-amd64.tar.gz
	sudo sh 'echo "export GOBIN=\~/go/bin" >> /etc/bash.bashrc'
	sudo sh 'echo "export PATH=\$PATH:/usr/local/go/bin:\$GOBIN" >> /etc/bash.bashrc'
	echo "Go installed."
	# shoving this in here too as it'll only be run once
	sudo sh 'echo "alias ll='ls -l'" >> /etc/bash.bashrc'
	sudo sh 'echo "alias la='ls -A'" >> /etc/bash.bashrc'
	sudo sh 'echo "alias l='ls -CF'" >> /etc/bash.bashrc'
fi

# XOrg / X11
sudo apt-get install -y xorg xorg-dev x11-xserver-utils x11-common x11-utils
# Window Manager dwm and dmenu
sudo apt-get install -y dwm suckless-tools

# Gnome Terminal & DBus (runs only one term no matter how many windows) & lightdm
sudo apt-get install -y gnome-terminal dbus-x11 dbus-user-session lightdm

# VBox pre-requisites
sudo apt-get install -y build-essential module-assistant
sudo m-a prepare
sudo apt-get install -y -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)

# tools
sudo apt-get install -y git

cd ~/src
# grab dwm source for later customization if needed
apt-get source dwm 

# TODO test for existance of .xinitrc otherwise create it

# ssh key gen
#
#
# add pip / setuptools
#
# add Neovim & python supports / Go / Python customization + dotfiles
sudo apt-get install neovim


# Finish off VirtualBox
sudo mount /dev/cdrom /media/cdrom 
cd /media/cdrom
# TODO add a file test for the shell script and abort if not found
read -p "If the following command does not complete, check the end of this script and investigate /media/cdrom - is the ISO mounted?"
sudo ./VBoxLinuxAdditions.run
cd ~
echo "\nDone!"
