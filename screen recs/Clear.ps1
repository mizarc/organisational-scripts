param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}


# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $folder -Filter "*.mkv"

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    Remove-Item -Path $file.FullName
}

Write-Host "Input has been cleared!"