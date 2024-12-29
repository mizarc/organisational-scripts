@echo off
mkdir Output
powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Input"
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Input" -OutputFolder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateExif.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -OutputFolder "X:\screenshots"

echo.
set /p input=Clean up? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Input"
)

echo Completed!
rmdir /s /q Output
pause