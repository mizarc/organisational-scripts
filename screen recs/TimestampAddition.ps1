param (
    [string]$folder,
    [string]$fallbackTimeZone
)

function Get-DateFromFileName {
    param (
        [string]$fileName
    )

    # Regular expression to match the date string in the file name
    if ($fileName -match 'Screen Rec (\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2})') {
        $dateString = $matches[1]
        
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

Write-Host "Start calculation..." -ForegroundColor Cyan

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Prompt the user for the game name
$inputTime = Read-Host -Prompt "Enter time to add (MM:SS)"

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Filter *.mkv

# Iterate through each PNG file
$datetimeList = @()
$timeZone = ""
foreach ($file in $videoFiles) {
    $currentTime = Get-DateFromFileName -fileName $file.Name
    $datetimeList += $currentTime
    $timeZone = Get-TimeZoneFromFileName -fileName $file.Name
}

if ($timeZone -eq "") {
    $timeZone = $fallbackTimeZone
}

$sortedDatetimes = $datetimeList | Sort-Object
$earliestDatetime = $sortedDatetimes[0]

# Parse the input to get minutes and seconds 
$minutes, $seconds = $inputTime -split ":"
$updatedDatetime = $earliestDatetime.AddMinutes([double]$minutes).AddSeconds([double]$seconds)
$datetimeString = "Screen Rec " + $updatedDatetime.ToString("yyyy-MM-dd HH-mm-ss") + " $timeZone"

Write-Host "Here's the result: $datetimeString`n" -ForegroundColor Green