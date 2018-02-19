# vboxdebian
Scripts and stuff to fire up a new VirtualBox guest Debian instance

*This is a bit of a work in progress and more of a reminder to myself of what
I want in a fresh system.*

Trying to eliminate some of the tedium involved in firing up a new minimal
Debian instance running as a VirtualBox guest on a Windows 10 host. 

The end result will be a minimal, almost exclusively text-based, environment
based on a tiling window manager (dwm).  

## Discovery Tools

	apt-cache search . | grep -i "metapackage\|meta-package" | more
	apt-cache search . | grep -i "xorg" | more
	apt-cache depends pkgname
	apt-cache policy pkgname

## What This Installs In Rough Order of Appearance

* XOrg
* DBus and Gnome Terminal
* Window Manager: dwm / suckless-tools + source (for configuration)
* VirtualBox Guest Additions for Linux
* Git, Go, Python `pip`
* Neovim & supporting apps for Go / Python / web development
* Tweaks /etc/bash.bashrc

## Starting Off

We need to do a few things by hand both on the Windows host side and in our new
Debian instance.

**In the VBox admin app in Windows**:

* Create a new vm ("Stretch")
* Assign something like 20GB for the VDI drive and create.
* Add the downloaded netinst as an IDE optical drive; start the vm 

**In the Debian guest**:

* Proceed through the install. 
* When prompted, don't install a Desktop Environment or print server (unless
  you need one); do install ssh server and base system utils. See you in a few minutes.
* Logon as root and:
	apt-get update
	apt-get upgrade
	apt-get install sudo
	adduser yournotrootuser sudo

Exit your root shell and yournotrootuser shell and logon as yournotrootuser and try to sudo:
	sudo vi /etc/apt/sources.list

If all goes well, carry on and append to sources.list stretch-backports from
whatever mirror you prefer:

	deb http://mirror.it.ubc.ca/debian stretch-backports main contrib
	deb-src http://mirror.it.ubc.ca/debian stretch-backports main contrib 

	sudo apt-get update

**In the VBox admin app in Windows**:

In Settings, Storage, add or ensure the VBoxGuestAdditions.iso is mounted as
IDE primary master / virtual optical disc. Return to Debian and:

	sudo mount /dev/cdrom /media/cdrom 
	> replies with a mount confirmation; don't proceed otherwise.

## Time for some automation

This script will add a bunch of packages after which we'll finish setting up
VirtualBox Guest Additions on the linux guest.

As your non-root-user:

	wget https://raw.githubusercontent.com/solutionroute/vboxdebian/master/configure-new-host.sh
	sh configure-new-host.sh

## Afterwards

As your non-root user:

	cd
	ssh-keygen


