param (
    [string]$folder,
    [string]$fallbackTimeZone
)

function Get-DateFromFileName {
    param (
        [string]$fileName
    )

    # Regular expression to match the date string in the file name
    if ($fileName -match '\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2}') {
        $dateString = $matches[0]
        
        try {   
            # Convert the date string to a DateTime object
            $lastModified = [datetime]::ParseExact($dateString, "yyyy-MM-dd HH-mm-ss", $null)
            return $lastModified
        }
        catch {
            Write-Error "Failed to parse the date string: $dateString"
            return $null
        }
    } else {
        return ""
    }
}

function Get-TimeZoneFromFileName {
    param (
        [string]$fileName
    )

    if ($fileName -match '\+\d{4}') {
        $timeZone = $matches[0]
        return $timeZone
    } else {
        return ""
    }
}

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

if (!$fallbackTimeZone) {
    $fallbackTimeZone = ""
}

# Prompt the user for the game name
$newName = Read-Host -Prompt "Enter name of game"

# Get all PNG files in the folder
$imageFiles = Get-ChildItem -Path $folder -Filter *.png

# Iterate through each PNG file
foreach ($file in $imageFiles) {
    # Get date from file name, otherwise fall back to last write time
    $date = Get-DateFromFileName -fileName $file.Name
    if ($date -eq "") { 
        $date = $file.LastWriteTime
    }
    $dateString = $date.ToString("yyyy-MM-dd HH-mm-ss")
    
    # Get timezone from file name, otherwise fall back to param which defaults to UTC if unprovided
    $timeZone = Get-TimeZoneFromFileName -fileName $file.Name
    if ($timeZone -eq "") {
        $timeZone = $fallbackTimeZone
    }
    if ($timeZone -ne "") {
        $timeZone = " " + $timeZone
    }
    
    $newFileName = "Screenshot $dateString$timeZone $newName$($file.Extension)"
    Rename-Item -Path $file.FullName -NewName $newFileName
}

Write-Host "Files have been renamed!"