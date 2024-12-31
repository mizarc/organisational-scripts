@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Pre Crop" -fallbackTimeZone "+1000"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Pre Crop"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

pause
