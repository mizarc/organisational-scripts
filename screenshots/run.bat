@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "Process.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "GenerateMetadata.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "Transfer.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -File "Clear.ps1"
pause
