@echo off
echo ---------------------------------------------------------------------------------------------------
echo SuperiorOS GSI ROM flasher for Doogee S59 Pro. Please connect your device in fastbootd mode
echo ---------------------------------------------------------------------------------------------------
echo NO TWRP FLASH
echo ----------------
set "ERROR_FLAG=0"

:check_device
REM --- Check if in fastbootd by querying a bootloader-specific variable ---
fastboot getvar version-bootloader 2>&1 | findstr /i "unknown" >nul
if %errorlevel%==1 (
    echo ------------------------------------------------------------------------------------------------
    echo Rebooting to fastbootd mode...
    echo ------------------------------------------------------------------------------------------------
    fastboot reboot fastboot || (echo Reboot to fastbootd error. Flasher will exit. & set ERROR_FLAG=1) && pause && exit /B 1
) 
echo Checking device compatibility....
fastboot getvar product 2>&1 | findstr /r /c:"^product: *S59Pro" || @echo "error : Missmatching image and device" && pause && exit /B 1
echo OK.
echo ----------------------------------------------------------------------------------------------------
echo Rebooting to fastboot mode to start flashing process...
echo ----------------------------------------------------------------------------------------------------
fastboot reboot bootloader || (echo Reboot to fastboot error. Flasher will exit. & set ERROR_FLAG=1) && pause && exit /B 1

setlocal

echo.
echo Do you want to keep user data (apps, files, settings)?NOT RECOMMENDED TO KEEP DATA. MAY CAUSE BOOTLOP
echo Press ENTER to ERASE, or type YES to keep the data.
echo.

set /p USER_CHOICE="Enter your choice: "
if /I "%USER_CHOICE%"=="YES" (
    echo Keeping userdata partition...
) else (
    echo Erasing userdata partition...
    fastboot erase userdata || (echo Erase userdata error & set ERROR_FLAG=1)
)
endlocal
setlocal

echo.
echo Choose which boot image to flash:
echo [1] Rooted boot.img (Magisk)
echo [2] Stock boot.img
echo.

set /p BOOT_CHOICE="Enter your choice (1 or 2): "

if "%BOOT_CHOICE%"=="1" (
    echo Flashing rooted boot.img...
    fastboot flash boot %~dp0\images\boot_rooted.img || (echo Flash rooted boot error & set ERROR_FLAG=1)
) else if "%BOOT_CHOICE%"=="2" (
    echo Flashing stock boot.img...
    fastboot flash boot %~dp0\images\boot.img || (echo Flash stock boot error & set ERROR_FLAG=1)
) else (
    echo Invalid choice. Exiting...
    pause
    exit /B 1
)

endlocal

fastboot --disable-verity --disable-verification flash vbmeta %~dp0\images\vbmeta.img || (echo Flash vbmeta error & set ERROR_FLAG=1)
fastboot --disable-verity --disable-verification flash vbmeta_system %~dp0\images\vbmeta_system.img || (echo Flash vbmeta_system error & set ERROR_FLAG=1)
fastboot --disable-verity --disable-verification flash vbmeta_vendor %~dp0\images\vbmeta_vendor.img || (echo Flash vbmeta_vendor error & set ERROR_FLAG=1)
fastboot flash recovery %~dp0\images\recovery.img || (echo Flash recovery error & set ERROR_FLAG=1)
echo ----------------------------------------------------------------------------------------------------------
echo Rebooting to fastbootd mode...
echo ----------------------------------------------------------------------------------------------------------
fastboot reboot fastboot || (echo Reboot to fastbootd error & set ERROR_FLAG=1)
fastboot flash product %~dp0\images\product.img || (echo Flash product error & set ERROR_FLAG=1)
fastboot flash system %~dp0\images\system.img || (echo Flash system error & set ERROR_FLAG=1)

REM @echo off
echo.
echo +------------------+
if %ERROR_FLAG% EQU 0 (
    echo ^|   DONE           ^|
) else (
    echo ^| DONE: with errors ^|
)
echo +------------------+
pause
