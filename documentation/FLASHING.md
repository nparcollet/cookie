# Theory of operation

Flashing is the final step that will allow to run the system built with cookie on the Raspberry
hardware. The way this is done is by copying an image of the system onto an SD Card that will then
be plugged into the device. The box is configured to boot from such images.

The operation depend on specific tools on the host, and thus cannot be done directly in cookie
environment. Instead, cookie allow to create the image, and the below guides will detail how
to flash it on the sd cards for the main OS out there.

# Flashing on Mac OS

## Connect a sd card

## Find the sdcard id

- diskutil list

**Warning**: Choosing the wrong disk ID can be harmfull to you computer. Do not hesitate to list
the disks before and after connecting the SD Card to be sure to choose the right one.

## Flash the sdcard

Copying the SD
- diskutil unmountDisk /dev/rdisk<#>
- sudo dd bs=1m if=<path.to.img> of=/dev/<#>

**Note**: dd does not outpu anything while doing the copie. It can be a long operation. In order
to know the progress, you can use Ctrl+T in the terminal where is command is running.

## Boot

unmount the sdcard from the explorer
plug it into the pi
switch the pi power

# Login

user: pi
password: raspberry

