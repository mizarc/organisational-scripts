@echo off
for /f "delims=" %%x in (config.ini) do (set "%%x")
powershell -command "Write-Host 'Running the pre-crop screen recording pipeline.' -ForegroundColor Magenta"
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "Rename.ps1" -folder "Pre Crop" -fallbackTimeZone "%fallback_time_zone%"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "UpdateModifiedDate.ps1" -folder "Pre Crop"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

pause
