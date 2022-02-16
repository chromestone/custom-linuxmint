# Custom Linux Mint
This repo tracks what I've done with my computer.

** READMEs are WIP **

This repo was born out of the curiosity to play lightsaber sounds boot/login/logout/shutdown/etcetera.

Since I abstracted playing each sound into its own script, I realized that I am essentially creating an event hook. I hope that this is useful to someone. It took me a very long time to piece together everything.

_I've excluded the assets from this repo as to not infringe on any copyright._

_The scripts in ```/usr/share/lightdm``` are not actually dependent on lightdm. I simply started trying to configure the sounds there and out of laziness kept them there._

_Since I am running Linux Mint on Apple hardware, there will be Mac specific scripts. To keep this repo as general as possible for Linux Mint users, I will not put information on that in this top level README. Instead README(s) for Mac specific scripts will be within same folder._

## General Scripts

* /usr/share/lightdm/lidclose.sh
  * Sleeps 5 seconds, checks if the lid is closed, and suspends the system.
  * **I set the XFCE power manager to always lock on lid close regardless of plugged in or on battery power.**
  * Unsure how this exactly interacts with the power manager or security settings. Sometimes there is a bug where the screen switches off after opening the lid and unlocking. For me, this is always resolved by closing the lid and unlocking again.
* /usr/share/lightdm/my(enter|exit|login).sh
  * This is fairly straightforward. I installed the SOX library to play a sound with the play command.
  * I will note that you can easily add scripts that run on login by going to "Session and Startup".

## XFCE4 Specific Scripts

* /usr/share/lightdm/myunlock.sh
  * This script can be run as sudo to check for a running ```xfce4-session``` process. If the script finds that the process running, it will wait for the user to unlock the session and execute a script (such as ```mylogin.sh```).
  * Unlocking is when the user doesn't log out but say closes the laptop lid. This script is useful if you don't want to have some daemon always running but want something like a "login sound" to play **anytime the user successfully completes the password challenge**.
  * **This has only been tested on a system with a single user.**

### Notes

These have the potential to be adapted for other desktop environments.

### Resources

I basically combined these two ideas to arrive at a solution.

https://www.freedesktop.org/wiki/Software/systemd/logind/

https://serverfault.com/questions/699718/how-do-i-properly-launch-a-dbus-monitor-session-as-root

## Laptop Specific Events + Scripts

* /etc/acpi/laptop-lid.sh
  * This script hooks to the laptop lid open and close events.
  * Specifically, I've configured mine to play a sound and then start a systemd service (if not started yet).
  * For lid open, this service is ```myunlock.service```. The idea is to wait until the user unlocks, play a sound, and then exit.
  * For lid close, this service is ```lidclose.service```. The idea is to suspend after a set time so that if the user quickly opens the lid again, the system does not need to waste time resuming. (Again in practice not sure how well this works.)
* /etc/acpi/events/laptop-lid
  * This file tells acpid to run ```laptop-lid.sh``` on all lid events.

### Resources

I found out about acpi from here.

https://askubuntu.com/questions/1140329/how-to-run-a-script-when-the-lid-is-closed

## LightDM Specific Configurations

* /etc/lightdm/*

### Notes

This is the least significant part of the repo. All this does is display a background (which can be set using the prepackaged UI).

I've included this because my initial attempts were to play sounds by configuring lightdm. lightdm configurations exist both in ```/etc/lightdm``` and ```/usr/share/lightdm```. (Don't get confused.)

At first I used these configurations to play a startup sound (before login/after boot). (Here I say startup to distinguish from boot. I tried to use GRUB2's play but I found that this functionality is hardware dependent.) See ```/etc/lightdm/slick-greeter.conf```

Then I realized systemd is much better for this. 

I also tried to use these configurations to hook onto session create (which is excluded but would be in something like /usr/share/lightdm/lightdm-gtk...).

In the end I concluded that it was much more consistent to just run the script on login using "Session and Startup".
