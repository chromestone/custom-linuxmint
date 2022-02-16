#!/bin/bash

PROC_ID=$(pidof xfce4-session) || exit 0
XDG_SESSION_ID=$(strings "/proc/${PROC_ID}/environ" | grep 'XDG_SESSION_ID' | cut -d '=' -f2-)

while read X; do
#echo 'hello world';
echo "$X";
if [[ $X == *'org.freedesktop.login1.Session.Unlock ()' ]]; then
echo 'got it';
sleep 1;
/usr/share/lightdm/mylogin.sh;
exit 0;
fi
done < \
<(gdbus monitor --system --dest org.freedesktop.login1 --object-path "/org/freedesktop/login1/session/${XDG_SESSION_ID}")

#gdbus monitor --system --dest org.freedesktop.login1 --object-path /org/freedesktop/login1/seat/seat0

#sudo -u derekzhang -E dbus-monitor --session "type=signal,interface=org.xfce.ScreenSaver"

#sudo -i -u derekzhang bash <<< EOF
#thefile="/proc/$(pidof -s xfdesktop)/environ"
#DBUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS ${thefile} | tr -d '\0' | cut -d '=' -f2-)
#echo $DBUS_ADDRESS
#dbus-monitor --address "${DBUS_ADDRESS}" "type='signal',interface='org.xfce.ScreenSaver'"
#EOF

#dbus-monitor --session "type='signal',interface='org.xfce.ScreenSaver'"

