#!/bin/bash

grep -q closed /proc/acpi/button/lid/LID0/state
if [ $? = 0 ]
then
/usr/share/lightdm/myexit.sh
systemctl is-active --quiet lidclose || systemctl start lidclose
else
/usr/share/lightdm/myenter.sh
systemctl is-active --quiet myunlock || systemctl start myunlock
fi
