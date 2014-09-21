#!/usr/bin/env bash

sudo apt-get install libevdev-dev libevdev2
sudo apt-get build-dep xserver-xorg-input-evdev xserver-xorg-input-synaptics

wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-evdev_2.9.0.orig.tar.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-evdev_2.9.0-1ubuntu1.diff.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-evdev_2.9.0-1ubuntu1.dsc

wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-synaptics_1.8.0.orig.tar.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-synaptics_1.8.0-1~exp2ubuntu2.diff.gz
wget https://launchpad.net/ubuntu/+archive/primary/+files/xserver-xorg-input-synaptics_1.8.0-1~exp2ubuntu2.dsc

dpkg-source -x --no-check xserver-xorg-input-evdev_2.9.0-1ubuntu1.dsc
dpkg-source -x --no-check xserver-xorg-input-synaptics_1.8.0-1~exp2ubuntu2.dsc

wget https://aur.archlinux.org/packages/xf/xf86-input-evdev-trackpoint/xf86-input-evdev-trackpoint.tar.gz

tar -xzf xf86-input-evdev-trackpoint.tar.gz

mv xf86-input-evdev-trackpoint arch
mv xserver-xorg-input-evdev-2.9.0 evdev
mv xserver-xorg-input-synaptics-1.8.0 synaptics

cp synaptics/src/{eventcomm.c,eventcomm.h,properties.c,synaptics.c,synapticsstr.h,synproto.c,synproto.h} evdev/src
cp synaptics/include/synaptics-properties.h evdev/src
cp arch/*.patch evdev

cd evdev
patch -p1 -i 0001-implement-trackpoint-wheel-emulation.patch
patch -p1 -i 0004-disable-clickpad_guess_clickfingers.patch
patch -p1 -i 0006-add-synatics-files-into-Makefile.am.patch

dpkg-buildpackage

cd ..
sudo dpkg -i xserver-xorg-input-evdev_*.deb
sudo apt-get remove xserver-xorg-input-synaptics

sudo mkdir /etc/X11/xorg.conf.d/
sudo cp arch/90-evdev-trackpoint.conf /etc/X11/xorg.conf.d

echo If everything was OK, than logout/reboot and enjoy fully working ThinkPad Trackpoint/ClickPad
echo If you want to deactivate touch area of ClickPad for pure TrackPoint usage
echo edit /etc/X11/xorg.conf.d/90-evdev-trackpoint.conf and change "0" to "1" at line
echo Option "AreaBottomEdge" "0"
