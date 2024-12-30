@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Crop" -fallbackTimeZone "+1000"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

pause
