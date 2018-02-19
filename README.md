# vboxdebian
Scripts and stuff to fire up a new VirtualBox guest Debian instance

*This is a bit of a work in progress and more of a reminder to myself of what
I want in a fresh system.*

Trying to eliminate some of the tedium involved in firing up a new minimal
Debian instance running as a VirtualBox guest on a Windows 10 host. 

## What You Get

Should the script make it through to completion, the end result will be a minimal, 
almost exclusively text-based, environment based on a tiling window manager (dwm) and
a GUI login using lightdm.

## Alternatives

Choose a full desktop environment during the intial Debian installation, or, if you try
a lightweight approach like this one and find it lacking, you can:

	sudo tasksel

To install one of the big desktop metapackages. `man tasksel` to discover what else you can learn.

## Discovery Tools

As a long time FreeBSD `ports` user now migrated to Linux I sometimes need reminders like these:

	apt-cache search . | grep -i "metapackage\|meta-package" | more
	apt-cache search . | grep -i "xorg" | more
	apt-cache depends pkgname
	apt-cache policy pkgname
	tasksel --list-tasks
	# check out one of the stock tasks presented during initial install...
	apt-cache depends task-desktop
	apt-cache depends task-desktop

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

If all goes well you'll now have a decently if not minimally configured Debian / X / dwm environment with Neovim and Google Chrome installed. Reboot and check it out.

## Afterwards

Key mappings for `dwm` can be found by reading `~/src/dwm-1.x/config.def.h` but here's a
quick cheat sheet for the default mappings that are so sensible you probably won't change them:

	Shift-Alt-Enter - launches a terminal window. 
	Shift-Alt-Enter - launches another terminal window. 
	Shift-Alt-Enter - launches another terminal window. 
	Alt-Enter - zooms the top right Window to the main (left)
	Alt-2 - switches to the second workspace
	ALt-j, Alt-k - move forward and back through the desktop window stack
	Alt-h, Alt-l - resize the main (left) window, others adjust automatically
	Alt-p - launches the menu system. Try typing chrome and hit Enter
