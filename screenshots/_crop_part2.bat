@echo off
mkdir Output
if %ERRORLEVEL% == 1 (
    echo.
)

powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Crop" -OutputFolder "Output"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateExif.ps1" -folder "Output"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1" -folder "Output"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -OutputFolder "X:\screenshots"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

set /p input=Clean up? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Crop"
)

echo Completed!
rmdir /s /q Output
pause
