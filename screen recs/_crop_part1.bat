@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Pre Crop"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Pre Crop"
pause
