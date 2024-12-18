$inputFolder = "Output"
$destinationFolder = "X:\screenshots"

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $inputFolder

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    if ($file.Name -match '\d{4}') {
        # Define destination folder path using the extracted year
        $year = $matches[0]
        $destinationFolderPath = Join-Path -Path $destinationFolder -ChildPath $year
        
        # Create the destination folder if it doesn't exist 
        if (-not (Test-Path -Path $destinationFolderPath)) { 
            New-Item -Path $destinationFolderPath -ItemType Directory | Out-Null 
        }

        # Define the destination path for the file
        $destinationPath = Join-Path -Path $destinationFolderPath -ChildPath $file.Name

        # Move the file to the destination folder
        Move-Item -Path $file.FullName -Destination $destinationPath
    }
}

Write-Host "Files have been moved to $destinationFolder."