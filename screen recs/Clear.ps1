param (
    [string]$folder
)

Write-Host "Start clearing..." -ForegroundColor Cyan

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $folder

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    Remove-Item -Path $file.FullName
}

Write-Host "Folder has been cleared!`n" -ForegroundColor Green