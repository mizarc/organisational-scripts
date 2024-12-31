@echo off
for /f "delims=" %%x in (config.ini) do (set "%%x")
powershell -command "Write-Host 'Running the main screenshot pipeline.' -ForegroundColor Magenta"
echo.

mkdir Output
if %ERRORLEVEL% == 1 (
    echo.
)

powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Input" -fallbackTimeZone "%fallback_time_zone%"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Input" -OutputFolder "Output"
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

powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -InputFolder "Output" -outputFolder "%final_output_folder%"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

set /p input=Pipeline complete. Clean up inputs? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Input"
)

echo Done!
rmdir /s /q Output
pause