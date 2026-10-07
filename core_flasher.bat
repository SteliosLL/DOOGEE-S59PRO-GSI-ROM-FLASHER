@echo off
setlocal EnableExtensions
set "ERROR_FLAG=0"
set "MODE=%~1"

if "%MODE%"=="" (
    echo [ERROR] Do not run this file directly. Please use one of the launcher scripts.
    pause
    exit /B 1
)

echo ---------------------------------------------------------------------------------------------------
if /I "%MODE%"=="TWRP" (
    echo GSI ROM Flasher for Doogee S59 Pro (TWRP INCLUDED)
    set "RECOVERY_IMG=%~dp0images\recovery_twrp.img"
) else (
    echo GSI ROM Flasher for Doogee S59 Pro (WITHOUT TWRP)
    set "RECOVERY_IMG=%~dp0images\recovery.img"
)
echo ---------------------------------------------------------------------------------------------------
echo.
echo Please connect your device in BOOTLOADER / FASTBOOT mode first.
echo.

:check_device
echo Checking device compatibility...
fastboot getvar product 2>&1 | findstr /R /C:"product: *S59Pro" >nul
if errorlevel 1 (
    echo [ERROR] Device mismatch or device not detected in fastboot mode!
    pause
    exit /B 1
)
echo OK
echo.

echo ----------------------------------------------------------------------------------------------------
echo Starting flashing process...
echo ----------------------------------------------------------------------------------------------------

echo Choose which boot image to flash:
echo [1] Rooted boot.img (Magisk)
echo [2] Stock boot.img
echo.
set /p "BOOT_CHOICE=Enter your choice (1 or 2): "

if "%BOOT_CHOICE%"=="1" (
    echo Flashing rooted boot.img...
    fastboot flash boot "%~dp0images\boot_rooted.img" || set "ERROR_FLAG=1"
) else if "%BOOT_CHOICE%"=="2" (
    echo Flashing stock boot.img...
    fastboot flash boot "%~dp0images\boot.img" || set "ERROR_FLAG=1"
) else (
    echo Invalid choice. Exiting...
    pause
    exit /B 1
)

echo Flashing VBMeta partitions...
fastboot --disable-verity --disable-verification flash vbmeta "%~dp0images\vbmeta.img" || set "ERROR_FLAG=1"
fastboot --disable-verity --disable-verification flash vbmeta_system "%~dp0images\vbmeta_system.img" || set "ERROR_FLAG=1"
fastboot --disable-verity --disable-verification flash vbmeta_vendor "%~dp0images\vbmeta_vendor.img" || set "ERROR_FLAG=1"

echo Flashing Recovery (%RECOVERY_IMG%)...
fastboot flash recovery "%RECOVERY_IMG%" || set "ERROR_FLAG=1"

echo.
echo ----------------------------------------------------------------------------------------------------
echo Rebooting to fastbootd...
echo ----------------------------------------------------------------------------------------------------
fastboot reboot fastboot
if errorlevel 1 (
    echo [ERROR] Failed to reboot into fastbootd mode. Flasher will exit.
    pause
    exit /B 1
)

echo.
echo Do you want to keep user data (apps, files, settings)?
echo WARNING: NOT RECOMMENDED WHEN FLASHING A GSI. MAY CAUSE BOOTLOOP.
echo Press ENTER to ERASE, or type YES to keep data.
echo.
set "USER_CHOICE="
set /p "USER_CHOICE=Enter your choice: "

if /I "%USER_CHOICE%"=="YES" (
    echo Keeping userdata partition...
) else (
    echo Erasing userdata partition...
    fastboot erase userdata || set "ERROR_FLAG=1"
)

echo.
echo ----------------------------------------------------------------------------------------------------
echo Flashing GSI System and Product Partitions...
echo ----------------------------------------------------------------------------------------------------
fastboot flash product "%~dp0images\product.img" || set "ERROR_FLAG=1"
fastboot flash system "%~dp0images\system.img" || set "ERROR_FLAG=1"

echo.
echo +-------------------------------------+
if "%ERROR_FLAG%"=="0" (
    echo |  DONE. Please reboot your phone. |
    echo +-------------------------------------+
    echo Rebooting to system...
    fastboot reboot
) else (
    echo |          DONE: WITH ERRORS          |
    echo +-------------------------------------+
    echo Please review the output above for failed steps.
)

pause