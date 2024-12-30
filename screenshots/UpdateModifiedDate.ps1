param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

Write-Host "Start updating modified date..." -ForegroundColor Cyan

# Get all PNG files in the folder
$imageFiles = Get-ChildItem -Path $folder -Filter *.png

# Iterate through each PNG file
foreach ($file in $imageFiles) {
    if ($file.Name -match 'Screenshot (\d{4})-(\d{2})-(\d{2}) (\d{2})-(\d{2})-(\d{2})') {
        $newDate = Get-Date -Year $matches[1] -Month $matches[2] -Day $matches[3] -Hour $matches[4] -Minute $matches[5] -Second $matches[6]
        $file.LastWriteTime = $newDate
    }
}

Write-Host "Files have had their modification date set!" -ForegroundColor Green
Wrist-Host ""