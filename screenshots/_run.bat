@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "D:\Screenshot Organiser\Input"
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "D:\Screenshot Organiser\Input" -OutputFolder "D:\Screenshot Organiser\Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "D:\Screenshot Organiser\Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "D:\Screenshot Organiser\Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "D:\Screenshot Organiser\Output" -OutputFolder "X:\screenshots"
powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "D:\Screenshot Organiser\Input"
pause
