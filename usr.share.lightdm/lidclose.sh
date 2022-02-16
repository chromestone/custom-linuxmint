#!/bin/bash
sleep 5
grep -q closed /proc/acpi/button/lid/LID0/state
if [ $? = 0 ]
then
systemctl suspend
fi
