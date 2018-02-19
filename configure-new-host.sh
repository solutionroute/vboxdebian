#!/bin/sh
# Installs a bunch of stuff, meant for spooling up a new Debian instance running as
# a guest under VirtualBox; includes setup of VBoxGuestAdditions.
#
#
# It's a fairly dumb script, beware!

# Settings =====================================================================
# The only GUI app (other than X / LightDM / dwm / Gnome-Terminal) installed is 
# Google Chrome, if enabled.
INSTALL_CHROME=yes
GOOGLE_CHROME="deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"

# You'll want to adjust this to your own or use the Debian standard
BACKPORTS="deb http://mirror.it.ubc.ca/debian/ stretch-backports main contrib
deb-src http://mirror.it.ubc.ca/debian/ stretch-backports main contrib"

# TODO make Go optional
# Update desired version as need be from: https://golang.org/dl/
GOVERSION=1.10

# Start ========================================================================
# Don't run as root
if [ $(id -u) = 0 ]; then
   echo "Do not run this script as root. Exiting."
   exit 1
fi

# Misc 
POSTSCRIPT_MESSAGE=""
sudo apt-get update

# for later
mkdir -p ~/tmp
mkdir -p ~/src
mkdir -p ~/go/src
cd ~

# XOrg / X11 Stuff =============================================================
sudo apt-get install -y xorg xorg-dev x11-xserver-utils x11-common x11-utils
sudo apt-get install -y fonts-liberation2
# Window Manager dwm and dmenu
sudo apt-get install -y dwm suckless-tools
cd ~/src
# grab dwm source for later customization if needed
apt-get source dwm 
cd ~

# Add .xinitrc, .Xresources if not there
if [ ! -f ~/.xinitrc ]
then
	cat <<EOF >>~/.xinitrc
#!/bin/sh
xrdb -merge ~/.Xresources
exec dwm
EOF
fi

# I'm running a HiDPI Microsoft Surface Pro (2017)
if [ ! -f ~/.Xresources ]
then
	cat <<EOF >>~/.Xresources
Xft.antialias:  1
Xft.autohint:   0
Xft.dpi:        192
Xft.hinting:    0
Xft.hintstyle:  hintnone
Xft.lcdfilter:  lcddefault
Xft.rgba:       rgb
EOF

# Gnome Terminal & DBus (runs only one term no matter how many windows) & lightdm
sudo apt-get install -y gnome-terminal dbus-x11 dbus-user-session lightdm

# One Time  ====================================================================
# Installing Go early on since it has no dependencies; don't use Go? Don't worry
# about it. It's a self-contained executable; it and related files only occupy a
# few megabytes of space.

# Installs Go / Google Chrome and makes updates to /etc/apt/sources.list

# Using this one test for Go as a "do-once" step when modifying /etc/apt/sources.list 
# in case this script is being or needs to be run again.
# TODO - use another mechanism

if grep -q "/usr/local/go/bin" /etc/bash.bashrc
then
    echo "Go already installed, skipping"
else
	echo "Installing Go" $GOVERSION
	wget https://dl.google.com/go/go$GOVERSION.linux-amd64.tar.gz
	sudo tar -C /usr/local -xzf go$GOVERSION.linux-amd64.tar.gz
	rm go$GOVERSION.linux-amd64.tar.gz
	# Update system bashrc
	sudo sh -c 'echo "export GOBIN=\~/go/bin" >> /etc/bash.bashrc'
	sudo sh -c 'echo "export PATH=\$PATH:/usr/local/go/bin:\$GOBIN" >> /etc/bash.bashrc'
	echo "Go installed"
	# shoving this in here too
	sudo sh -c 'echo "alias ll='ls -l'" >> /etc/bash.bashrc'
	sudo sh -c 'echo "alias la='ls -A'" >> /etc/bash.bashrc'
	sudo sh -c 'echo "alias l='ls -CF'" >> /etc/bash.bashrc'
	# backports
	if grep -qv "stretch-backports" /etc/apt/sources.list 
	then
		sudo sh -c 'echo $BACKPORTS' >> /etc/apt/sources.list
	fi
	# add Google Chrome to apt/sources.list if not already there
	if grep -qv "dl.google.com" /etc/apt/sources.list 
	then 
		sudo sh -c 'echo $GOOGLE_CHROME' >> /etc/apt/sources.list
		# add the key:
		cd ~/tmp
		wget https://dl-ssl.google.com/linux/linux_signing_key.pub
		sudo apt-key add linux_signing_key.pub
	fi
    	apt-get update
	# Do we want to install it?
	case $INSTALL_CHROME in
	  ([Yy][Ee][Ss]) sudo apt-get install google-chrome-stable;;
	  (*)        echo "Not installing Chrome";;
	esac
fi

# VirtualBox ===================================================================
# VBox pre-requisites
sudo apt-get install -y build-essential module-assistant
sudo m-a prepare
sudo apt-get install -y -t stretch-backports virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)
# Finish off VirtualBox 
sudo mount /dev/cdrom /media/cdrom 
cd /media/cdrom
if [ ! -f /media/cdrom/VBoxLinuxAdditions.run ]
	clear
	echo "WARNING: VirtualBox Guest Additions apparently not mounted at /media/cdrom"
	echo "You will need to complete installation of the Linux additions by hand."
	echo "Guest additions impact video and other factors. Do it soon!"
	echo "This script will continue installing everything else."
	POSTSCRIPT_MESSAGE="Remember to install VirtualBox Guest Additions"
	read -p "To continue with balance of installation, press any key"
else
	sudo ./VBoxLinuxAdditions.run
fi
cd ~

# Tools ========================================================================
# The world runs on Git; Go requires git.
sudo apt-get install -y git

# add Neovim to replace ViM & python supports / Go / Python customization 
sudo apt-get install neovim

cd
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py 
sudo python3 get-pip.py 
sudo pip install neovim
sudo pip3 install neovim

# TODO
# include other dotfiles

# Last Step ====================================================================
if [ ! -f ~/.ssh/id_rsa.pub ]
then
	ssh-keygen
fi

echo $POSTSCRIPT_MESSAGE
echo "\nReboot for good measure and enjoy finishing any configuration off in a better terminal."
echo "Shift-Alt-Enter starts a new terminal in dwm"
echo "\n\n(Check out ~/src/dwm*/config.def.h for other dwm key mappings)"
