@echo off
mkdir Output
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Crop" -OutputFolder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -OutputFolder "X:\screenshots"
powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Crop"
rmdir /s /q Output
pause
