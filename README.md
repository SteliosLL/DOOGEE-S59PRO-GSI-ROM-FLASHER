# DOOGEE-S59PRO-GSI-ROM-INSTALLER
Flash scripts that allow you to flash any GSI system image with TWRP and rooted boot.img options included.

### TWRP issues:
The touchscreen in the included TWRP does not work. You will instead need to use ADB, or an OTG usb adapter with a mouse.

## How to flash a GSI:
You need to unlock your bootloader before you continue. On Doogee phones its pretty easy. All you need to do is enable OEM unlocking in Developer settings and then boot into fastboot mode and type "fastboot flashing unlock".

Also install adb and fastboot drivers.

How to flash:
- Flash the Stock rom using SP flash tool.
- Dwnload the GSI of your choice and extract to find the .img system image and rename it to system.img. MAX SYSTEM.IMG SIZE IS ABOUT 2.9GB. Any higher will fail to flash.
- Download this repo and extract it. Copy the system.img of the GSI into the "images" folder inside the extracted folder of the repo.
- Go back a folder and you will see 2 batch files. Choose either to install with TWRP or without.
- After you run the batch file its going to ask you whether you want to keep the data (DO NOT KEEP UNLESS YOU KNOW WHAT YOU ARE DOING) and if you want to flash rooted boot.img so that you can install magisk.
- Wait for the installation to finish. Done.
