# vboxdebian
Scripts and stuff to fire up a new VirtualBox guest Debian instance

THIS IS NOT READY FOR USE -- Feb 2018

I'm not trying to automate everything, just eliminate some of the
tedium of firing up a new Debian instance as a VirtualBox guest running on
a Windows 10 (Surface Pro in my case) host.

I'm looking for a minimal almost exclusively text-based environment.

## What This Installs In Rough Order of Appearance

* XOrg
* Window Manager: dwm / suckless-tools / st 
* VirtualBox Guest Additions for Linux
* Git
* Go
* Neovim


## Starting Off

We need to do a few things by hand both on the Windows host side and in our new
Debian instance.

In the VB admin app in Windows:

* Create a new vm ("Stretch")
* Assign something like 20GB for the VDI drive and create.
* Add the downloaded netinst as an IDE optical drive; start the vm 

In the Debian guest:

* Proceed through the install. 
* When prompted, don't install a Desktop Environment or print server (unless
  you need one); do install ssh server and base system utils. See you in a few minutes.
* Logon as root and:
	apt-get update
	apt-get upgrade
	apt-get install sudo
	adduser yournotrootuser sudo

Exit your root shell and logon as yournotrootuser and try to sudo:
	sudo ls /root

If all goes well, carry on.

Next ensure the VirtualBox Guest Additions ISO is mounted as a virtual optical discu on the Windows host.

## Time for some automation

This script will add a bunch of packages after which we'll finish setting up
VirtualBox Guest Additions on the linux guest.

As your non-root-user:

	wget https://raw.githubusercontent.com/solutionroute/vboxdebian/master/configure-new-host.sh
	sh configure-new-host.sh



