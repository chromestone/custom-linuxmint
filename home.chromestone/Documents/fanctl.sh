#!/bin/bash

if [[ $EUID -ne 0 ]];
then
echo 'This script must be run as root.';
exit 1;
fi

if [ -z "$1" ];
then
echo 'Auto Fan Enabled';
echo 0 > /sys/devices/platform/applesmc.768/fan1_manual;
exit 0;
fi

if [[ $1 == 'read' ]];
then
cat /sys/devices/platform/applesmc.768/fan1_input;
exit 0;
fi

re='^[0-9]+$'
if ! [[ $1 =~ $re ]];
then
echo 'Invalid Input';
exit 1;
fi

mymin=$(cat /sys/devices/platform/applesmc.768/fan1_min)
mymax=$(cat /sys/devices/platform/applesmc.768//fan1_max)

if [[ $1 -lt $mymin ]];
then
echo 'Input Too Small';
exit 1;
fi

if [[ $1 -gt $mymax ]];
then
echo 'Input Too Big';
exit 1;
fi

echo "Setting Fan To $1"
echo 1 > /sys/devices/platform/applesmc.768/fan1_manual
echo $1 > /sys/devices/platform/applesmc.768/fan1_output
