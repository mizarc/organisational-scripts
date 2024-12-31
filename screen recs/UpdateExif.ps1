param (
    [string]$folder
)

function Get-TimeZoneFromFileName {
    param (
        [string]$fileName
    )

    if ($fileName -match '\+(\d{2})(\d{2})') {
        $hours = $matches[1] 
        $minutes = $matches[2]
        return "+${hours}:${minutes}"
    } else { 
        return ""
    }
}

Write-Host "Start updating exif data..." -ForegroundColor Cyan

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Recurse -Include *.mp4, *.mkv -File

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    if ($file.Name -match 'Screen Rec (\d{4})-(\d{2})-(\d{2}) (\d{2})-(\d{2})-(\d{2})') {
        $timeZone = Get-TimeZoneFromFileName $file.Name
        if ($timeZone -eq "") { 
            $timeZone = "+0000"
        }

        $newDate = Get-Date -Year $matches[1] -Month $matches[2] -Day $matches[3] -Hour $matches[4] -Minute $matches[5] -Second $matches[6]
        $newDateString = $newDate.ToString("yyyy-MM-dd HH:mm:ss")
        exifTool "-DateTimeOriginal=$newDateString$timeZone" -overwrite_original $file.FullName
    }
}

Write-Host "Files have had their exif data set!`n" -ForegroundColor Green