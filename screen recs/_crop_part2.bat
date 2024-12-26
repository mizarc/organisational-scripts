@echo off
mkdir Output
powershell -NoProfile -ExecutionPolicy Bypass -File "RenameFromModifiedDate.ps1" -folder "Crop"
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Crop" -OutputFolder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -OutputFolder "X:\game-clips"

echo.
set /p input=Clean up? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Crop"
)

echo Completed!
rmdir /s /q Output
pause
