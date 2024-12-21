@echo off
mkdir Output
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Input"
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Input" -OutputFolder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -OutputFolder "X:\screenshots"
powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Input"
rmdir /s /q Output
pause
