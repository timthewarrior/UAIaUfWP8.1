@echo off
setlocal EnableDelayedExpansion
title Universal App Installer and Updater for Windows Phone 8.1

:main
cls
echo.
echo =============================================================
echo   Universal App Installer and Updater for Windows Phone 8.1
echo =============================================================
echo.
echo 1. Install/Update a Single File
echo 2. Install/Update from Folder
echo 3. About+Credits
echo 4. Exit
echo.
set /p choice="Choose an option (1-4): "

if "%choice%"=="1" goto singlefile
if "%choice%"=="2" goto folder
if "%choice%"=="3" goto about
if "%choice%"=="4" exit
goto main

:singlefile
cls
echo.
echo --- Single File Mode Selected ---
echo.
set /p method="Select action: 1 = Install, 2 = Update: "
set /p rawpath="Enter full path to the .xap/.appx/.appxbundle file: "
set /p launch="Launch app after installation? (y/n): "

set "filepath=%rawpath:"=%"
for %%A in ("%filepath%") do set "filename=%%~nA"

if "%method%"=="1" (
    echo Installing %filename%
    if /i "%launch%"=="y" (
        call :runcommand "/installlaunch" "%filepath%" result
    ) else (
        call :runcommand "/install" "%filepath%" result
    )
) else (
    echo Updating %filename%
    if /i "%launch%"=="y" (
        call :runcommand "/updatelaunch" "%filepath%" result
    ) else (
        call :runcommand "/update" "%filepath%" result
    )
)

if "%result%"=="success" (
    if "%method%"=="1" (
        echo Install complete
    ) else (
        echo Update complete
    )
) else (
    if "%method%"=="1" (
        echo Install failed — exit code: %result%
    ) else (
        echo Update failed — exit code: %result%
    )
)

pause
goto main

:folder
cls
echo.
echo --- Folder Mode Selected ---
echo.
set /p method="Select action: 1 = Install, 2 = Update: "
set /p rawfolder="Enter full path to folder containing files: "
set "folderpath=%rawfolder:"=%"

set /a count=0
for %%F in ("%folderpath%\*.xap") do set /a count+=1
for %%F in ("%folderpath%\*.appx") do set /a count+=1
for %%F in ("%folderpath%\*.appxbundle") do set /a count+=1

if %count% EQU 0 (
    echo No valid files found in "%folderpath%"
    pause
    goto main
)

set /a success=0
set /a failed=0
set /a i=0

for %%F in ("%folderpath%\*.xap" "%folderpath%\*.appx" "%folderpath%\*.appxbundle") do (
    set /a i+=1
    call :processFile "%%~fF" "%%~nF" !i! %count% %method%
)

echo.
if "%method%"=="1" (
    echo Install complete: %success% succeeded, %failed% failed
) else (
    echo Update complete: %success% succeeded, %failed% failed
)
pause
goto main

:processFile
set "filepath=%~1"
set "filename=%~2"
set /a i=%~3
set /a count=%~4
set "method=%~5"

if "%method%"=="1" (
    echo Installing %filename% (%i%/%count%)
    call :runcommand "/install" "%filepath%" result
) else (
    echo Updating %filename% (%i%/%count%)
    call :runcommand "/update" "%filepath%" result
)

if "%result%"=="success" (
    set /a success+=1
) else (
    echo [ERROR] Failed to process %filename% — Exit code: %result%
    set /a failed+=1
)
exit /b

:runcommand
setlocal
set "exitcode=success"
"C:\Program Files (x86)\Microsoft SDKs\Windows Phone\v8.1\Tools\AppDeploy\AppDeployCmd.exe" %1 %2 /targetdevice:0
if errorlevel 1 (
    set "exitcode=%errorlevel%"
)
endlocal & set "%3=%exitcode%"
exit /b

:about
cls
echo.
echo =============================================================
echo                    About + Credits
echo =============================================================
echo.
echo This program was made by timthewarrior on GitHub
echo with the help of ChatGPT.
echo.
echo Version: v0.1.0
echo.
echo 1. Open GitHub Repository
echo 2. Return to Main Menu
echo.
set /p aboutchoice="Choose an option (1-2): "
if "%aboutchoice%"=="1" (
    start https://github.com/timthewarrior/UAIaUfWP8.1
    goto about
)
if "%aboutchoice%"=="2" goto main
goto about
