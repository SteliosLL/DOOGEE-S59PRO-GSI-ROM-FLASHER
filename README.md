# DOOGEE-S59PRO-GSI-ROM-INSTALLER
Flash scripts that allow you to flash any GSI system image with TWRP and rooted boot.img options included.

### TWRP issues:
The touchscreen in the included TWRP does not work. You will instead need to use ADB, or an OTG usb adapter with a mouse.

## How to flash a GSI:
You need to unlock your bootloader before you continue. On Doogee phones its pretty easy. All you need to do is enable OEM unlocking in Developer settings and then boot into fastboot mode and type "fastboot flashing unlock".

Also install adb and fastboot drivers.

### How to choose the right GSI ROM (or image, whatever you wanna call it)
The Doogee S59Pro CPU architecture is arm64 and the partition layout is A only but supports dynamic partitions with system-as-root and works with A/B GSIs.
That means, when you choose a GSI, you need to find one that says arm64 and then bvS, bgS, bvN or bgN.
The letter "g" in bgS means that it has the GAPPS already preinstalled. I suggest you to use one with GAPPS preinstalled so that you don't need to install TWRP recovery, since the once provided does not work well because of the touchscreen issue.

**DO NOT DOWNLOAD GSIs that say vndklite.**

For example, ff you want to download a superior OS android 12 GSI, you should download the file:<br>
SuperiorOS_A12L-RO-arm64-bgN-slim_20230806.img.xz 

**NOTE: DO NOT USE A GSI WHOSE .img FILES ARE LARGER THAN 2.9GB OTHERWISE THE FLASHING PROCESS WILL FAIL.**

### How to flash:
- Flash the Stock rom using SP flash tool.
- Download this repo and extract it. Go into the extracted folder and find the "images" folder. Inside it you will find a file "product.7z". Extract it.
- Download the GSI of your choice and extract it. You will get the .img system image. Rename it to system.img. 
- Now while you are still in the "images" folder of the repo, copy there the system.img you renamed earlier.
- Go back a folder and you will see 2 batch files. Choose either to install with TWRP or without.
- After you run the batch file its going to ask you whether you want to keep the data (DO NOT KEEP UNLESS YOU KNOW WHAT YOU ARE DOING) and if you want to flash rooted boot.img so that you can install magisk.
- Wait for the installation to finish. Done.

## Recommended GSI ROMs
Superior OS with GAPPS (Android 12): [Download](https://github.com/ChonDoit/treble_superior_patches/releases/tag/A12L) <br>
CAOS (Android11) with GAPPS: [Download](https://sourceforge.net/projects/treblerom/files/CAOS11/2022.03.21/caos-v316-220321-arm64-bgZ.img.xz) <br>
CAOS (Android10) with GAPPS: [Download](http://sourceforge.net/projects/treblerom/files/CAOS/2020.10.29/caos-v224-201029-arm64-bgN.img.xz) <br>
