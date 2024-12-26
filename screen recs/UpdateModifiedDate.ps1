param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Recurse -Include *.mp4, *.mkv -File

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    if ($file.Name -match 'Screen Rec (\d{4})-(\d{2})-(\d{2}) (\d{2})-(\d{2})-(\d{2})') {
        $newDate = Get-Date -Year $matches[1] -Month $matches[2] -Day $matches[3] -Hour $matches[4] -Minute $matches[5] -Second $matches[6]
        $file.LastWriteTime = $newDate
    }
}

Write-Host "Files have had their modification date set!"