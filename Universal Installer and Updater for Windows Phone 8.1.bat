@echo off
setlocal enabledelayedexpansion
title Windows Phone 8.1 XAP & Appx/Bundle Installer

:main
cls
echo(
echo =============================================================
echo [1m[4m       Windows Phone 8.1 XAP & Appx/Bundle Installer[0m
echo =============================================================
echo(
echo 1. Install/Update a Single File
echo 2. Install/Update from Folder
echo 3. Exit
echo(
set /p choice="Choose an option (1-3): "

if "%choice%"=="1" goto singlefile
if "%choice%"=="2" goto folder
if "%choice%"=="3" exit
goto main

:singlefile
cls
echo(
echo --- Single File Mode Selected ---
echo(
set /p method="Select action: 1 = Install, 2 = Update: "
set /p rawpath="Enter full path to the .xap/.appx/.appxbundle file: "
set /p launch="Launch app after installation? (y/n): "

rem Strip quotes if any
set "filepath=%rawpath:"=%"

for %%A in ("%filepath%") do (
    set "filename=%%~nA"
)

if "%method%"=="1" (
    echo Installing !filename!...
    if /i "%launch%"=="y" (
        call :runcommand "/installlaunch" "!filepath!"
    ) else (
        call :runcommand "/install" "!filepath!"
    )
) else if "%method%"=="2" (
    echo Updating !filename!...
    if /i "%launch%"=="y" (
        call :runcommand "/updatelaunch" "!filepath!"
    ) else (
        call :runcommand "/update" "!filepath!"
    )
)

pause
goto main

:folder
cls
echo(
echo --- Folder Mode Selected ---
echo(
set /p method="Select action: 1 = Install, 2 = Update: "
set /p rawfolder="Enter full path to folder containing files: "

set "folderpath=%rawfolder:"=%"

if "%method%"=="1" (
    echo Installing all files from %folderpath%...
) else (
    echo Updating all files from %folderpath%...
)

for %%F in ("%folderpath%\*.xap" "%folderpath%\*.appx" "%folderpath%\*.appxbundle") do (
    set "filepath=%%~fF"
    set "filename=%%~nF"

    if "%method%"=="1" (
        echo Installing !filename!...
        call :runcommand "/install" "!filepath!"
    ) else (
        echo Updating !filename!...
        call :runcommand "/update" "!filepath!"
    )
)

pause
goto main

:runcommand
"C:\Program Files (x86)\Microsoft SDKs\Windows Phone\v8.1\Tools\AppDeploy\AppDeployCmd.exe" %1 %2 /targetdevice:0
exit /b
