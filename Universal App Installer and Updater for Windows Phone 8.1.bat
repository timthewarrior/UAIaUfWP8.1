@echo off
setlocal enabledelayedexpansion
title Universal App Installer and Updater for Windows Phone 8.1

:main
cls
echo(
echo =============================================================
echo   Universal App Installer and Updater for Windows Phone 8.1
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

call :gettime
if "%method%"=="1" (
    echo Installing !filename! [!now!]
    if /i "%launch%"=="y" (
        call :runcommand "/installlaunch" "!filepath!" "!filename!" result
    ) else (
        call :runcommand "/install" "!filepath!" "!filename!" result
    )
) else (
    echo Updating !filename! [!now!]
    if /i "%launch%"=="y" (
        call :runcommand "/updatelaunch" "!filepath!" "!filename!" result
    ) else (
        call :runcommand "/update" "!filepath!" "!filename!" result
    )
)

call :gettime
if "!result!"=="success" (
    if "%method%"=="1" (
        echo Install complete [!now!]
    ) else (
        echo Update complete [!now!]
    )
) else (
    if "%method%"=="1" (
        echo Install failed — exit code: !result! [!now!]
    ) else (
        echo Update failed — exit code: !result! [!now!]
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

set count=0
for %%F in ("%folderpath%\*.xap" "%folderpath%\*.appx" "%folderpath%\*.appxbundle") do (
    set /a count+=1
)

if %count%==0 (
    echo No valid files found in %folderpath%
    pause
    goto main
)

set success=0
set failed=0
set i=0

for %%F in ("%folderpath%\*.xap" "%folderpath%\*.appx" "%folderpath%\*.appxbundle") do (
    set /a i+=1
    set "filepath=%%~fF"
    set "filename=%%~nF"

    call :gettime
    if "%method%"=="1" (
        echo Installing !filename! (!i!/!count!) [!now!]
        call :runcommand "/install" "!filepath!" "!filename!" result
    ) else (
        echo Updating !filename! (!i!/!count!) [!now!]
        call :runcommand "/update" "!filepath!" "!filename!" result
    )

    if "!result!"=="success" (
        set /a success+=1
    ) else (
        call :gettime
        echo [ERROR] Failed to process !filename! — Exit code: !result! [!now!]
        set /a failed+=1
    )
)

call :gettime
if "%method%"=="1" (
    echo(
    echo Install complete: %success% succeeded, %failed% failed [!now!]
) else (
    echo(
    echo Update complete: %success% succeeded, %failed% failed [!now!]
)
pause
goto main

:runcommand
rem Args: %1 = mode, %2 = full path, %3 = filename, %4 = output variable name
setlocal
set "outcome="
"C:\Program Files (x86)\Microsoft SDKs\Windows Phone\v8.1\Tools\AppDeploy\AppDeployCmd.exe" %1 %2 /targetdevice:0
if errorlevel 1 (
    endlocal & set "%4=%errorlevel%"
) else (
    endlocal & set "%4=success"
)
exit /b

:gettime
for /f "tokens=1-2 delims= " %%a in ("%time%") do (
    set "now=%%a"
)
exit /b
