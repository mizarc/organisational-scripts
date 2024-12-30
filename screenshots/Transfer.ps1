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

Write-Host "Start transferring..." -ForegroundColor Cyan

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $inputFolder

# Loop through each file and transfer them
foreach ($file in $imageFiles) {
    if ($file.Name -match '\d{4}') {
        $year = $matches[0]

        try {
            Write-Host "Moving $($file.Name) to $($outputFolder)\$year"

            # Define destination folder path using the extracted year
            $outputFolderPath = Join-Path -Path $outputFolder -ChildPath $year 2>$null

            # Create the destination folder if it doesn't exist 
            if (-not (Test-Path -Path $outputFolderPath)) { 
                New-Item -Path $outputFolderPath -ItemType Directory | Out-Null 
            }

            # Define the destination path for the file
            $outputPath = Join-Path -Path $outputFolderPath -ChildPath $file.Name

            # Move the file to the destination folder
            Move-Item -Path $file.FullName -Destination $outputPath
        } catch {
            Write-Host "Failed to move to $outputFolder, drive does not exist.`n" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host "Files have been moved to $outputFolder.`n" -ForegroundColor Green
