param (
    [string]$inputFolder,
    [string]$outputFolder
)

if (!$InputFolder) {
  $InputFolder = Read-Host "Please enter the input folder path"
}

if (!$OutputFolder) {
  $OutputFolder = Read-Host "Please enter the output folder path"
}


# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $inputFolder

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    if ($file.Name -match '\d{4}') {
        # Define destination folder path using the extracted year
        $year = $matches[0]
        $outputFolderPath = Join-Path -Path $outputFolder -ChildPath $year
        
        # Create the destination folder if it doesn't exist 
        if (-not (Test-Path -Path $outputFolderPath)) { 
            New-Item -Path $outputFolderPath -ItemType Directory | Out-Null 
        }

        # Define the destination path for the file
        $outputPath = Join-Path -Path $outputFolderPath -ChildPath $file.Name

        # Move the file to the destination folder
        Move-Item -Path $file.FullName -Destination $outputPath
    }
}

Write-Host "Files have been moved to $outputFolder."