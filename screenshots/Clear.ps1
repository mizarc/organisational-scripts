$inputFolder = "Input"

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $inputFolder -Filter "*.png"

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    Remove-Item -Path $file.FullName
}

Write-Host "Input has been cleared!"