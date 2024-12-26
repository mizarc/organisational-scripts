@echo off
mkdir Output
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Input"
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Input" -OutputFolder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -inputFolder "Output" -outputFolder "X:\gaming-clips"

echo.
set /p input=Clean up? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Input"
)

echo Completed!
rmdir /s /q Output
pause