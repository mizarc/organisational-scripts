@echo off
for /f "delims=" %%x in (config.ini) do (set "%%x")
powershell -command "Write-Host 'Running the post-crop screen recording pipeline.' -ForegroundColor Magenta"
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "RenameFromModifiedDate.ps1" -folder "Post Crop"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1" -InputFolder "Post Crop" -OutputFolder "Output"
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

powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1" -inputFolder "Output" -outputFolder "%final_output_folder%"
if %ERRORLEVEL% == 1 (
    pause
    exit /b 1
)

set /p input=Clean up? (y/n): 
if /i "%input%"=="y" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1" -folder "Post Crop" -extensions ".mkv",".llc"
)

echo Completed!
pause
