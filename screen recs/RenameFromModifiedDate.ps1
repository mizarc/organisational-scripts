param (
    [string]$folder
)

Write-Host "Start renaming..." -ForegroundColor Cyan

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Regular expression pattern to match the date format in the filename 
$datePattern = "\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2}"

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Filter *.mkv

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    if ($file.Name -match $datePattern) { 
        $oldDate = $matches[0]
        $newDate = $file.LastWriteTime.ToString("yyyy-MM-dd HH-mm-ss")
        $newName = $file.Name -replace [regex]::Escape($oldDate), $newDate
        
        try { 
            Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
            Write-Host "Renamed '$($file.Name)' to '$newName'"
        } catch { 
            Write-Host "Failed to rename '$($file.Name)' to '$newName', file already exists.`n" -ForegroundColor Red
            exit 1
        }
    }
}

Write-Host "Files have been renamed!`n"  -ForegroundColor Green