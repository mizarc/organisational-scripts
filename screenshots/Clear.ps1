param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

Write-Host "Start clearing..." -ForegroundColor Cyan

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $folder -Filter "*.png"

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    Remove-Item -Path $file.FullName
}

Write-Host "Input has been cleared!`n" -ForegroundColor Green