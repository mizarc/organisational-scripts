@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Crop"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Crop"
pause
