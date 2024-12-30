@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Crop" -fallbackTimeZone "+1000"
pause
