@echo off
for /f "delims=" %%x in (config.ini) do (set "%%x")
powershell -command "Write-Host 'Running calculation pipeline.' -ForegroundColor Magenta"
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "TimestampAddition.ps1" -folder "Merge" -fallbackTimeZone "%fallback_time_zone%"

pause