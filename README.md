thinkpad_t440s
==============

Some configuration and scripts I use to run Linux on the Lenovo ThinkPad T440s.

Background
==========

I am using this code on a T440s running Ubuntu 13.10 "Saucy Salamander," running the latest Cinnamon desktop (v2.0.13 as of this writing). I have the non-touchscreen FHD display option, so there is nothing in here regarding touchscreen support. My main purpose is for improving the trackpad experience, but I am happy to accept additional tweaks if people care to submit them. 

Insofar as there is any original source code here, I am releasing it under the MIT free software license. 

Happy hacking!

Scott Garman
sgarman at zenlinux dot com

Touchpad Support
================

The out of box touchpad experience leaves a lot to be desired. The touchpad acts very jumpy and unstable, and the GNOME acceleration and sensitivity settings do not appear to have much impact. The first thing you'll want to do is disable GNOME/Cinnamon control of the touchpad settings. Install the dconf-editor with:

	sudo apt-get install dconf-editor

Then run dconf-editor and un-check the "active" option in the following settings:

* org.cinnamon.settings-daemon.plugins.mouse
* org.gnome.settings-daemon.plugins.mouse

If you're not running the Cinnamon desktop, then ignore the first line.

Now create a directory /etc/X11/xorg.conf.d and copy the custom Xorg synaptics config file into it:

	sudo mkdir /etc/X11/xorg.conf.d
	sudo cp 99-synaptics-t440s.conf /etc/X11/xorg.conf.d/

Restart Xorg by either rebooting or logging out and restarting lightdm (service lightdm restart).

This should give you a much more stable mousing experience with the touchpad. It also enables features such as middle mouse click emulation with a three-finger tap. Feel free to customize this file as desired.

Syndaemon
=========

Syndaemon is a program that watches keyboard activity and can disable the touchpad while you're typing, which can help to reduce accidental mouse movement and clicks while you're typing should your palms/thumb hit the touchpad. Unfortunately, palm detection does not work with the Linux synaptics driver, so measures like this are usually needed. Syndaemon is included in the xserver-xorg-input-synaptics package in Ubuntu, so you should have it installed already.

Syndaemon takes an option -i whose argument is the number of seconds to keep the touchpad disabled after you stop typing. This value is highly personal, but tends to be in the 0.5 - 2.0 second range for most people. The -d option tells it to run in the background in daemon mode.

I recommend starting syndaemon upon logging in - you can do this by adding the following command to your desktop manager's Startup Programs:

	syndaemon -i 1.2 -d

Toggling the Touchpad with a Keyboard Binding
=============================================

Even with syndaemon, I often find it handy to completely disable the touchpad while typing long emails or documents. The included toggletouchpad script does this and kills or restarts syndaemon as needed, and sends a desktop notification to give some visual feedback of what is happening. I keep this script in /usr/local/bin/ and tied it to Ctrl-F9 by creating a custom keybinding in my Cinnamon Keyboard settings.

Synaptics Touchpad Resources
============================

The synclient command is very handy for learning about what driver settings you can change. synclient -l will list all settings and their current values. Here's an example of how you can update these values:

	synclient TouchPadOff=1

Changes to these settings will be lost upon rebooting. To make them permanent, add them to the /etc/X11/xorg.conf.d/99-synaptics-t440s.conf file.

To learn more about the Synaptics Touchpad settings, see:

http://linux.die.net/man/5/synaptics
