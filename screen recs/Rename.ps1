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

function Get-VideoDuration {
    param (
        [string]$videoPath
    )

    # Check if ffmpeg is installed
    if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue)) {
        Write-Error "ffmpeg is not installed. Please download and install it from https://ffmpeg.org/download.html."
        return
    }

    # Run ffmpeg to get the duration
    $ffmpegOutput = & ffmpeg -i $videoPath 2>&1 | Select-String "Duration:"

    if ($ffmpegOutput -match "Duration:\s*(\d{2}):(\d{2}):(\d{2})\.(\d{2})") {
        $hours = [int]$matches[1]
        $minutes = [int]$matches[2]
        $seconds = [int]$matches[3]
        $milliseconds = [int]$matches[4]

        # Calculate the total duration in seconds
        $duration = New-TimeSpan -Hours $hours -Minutes $minutes -Seconds $seconds
        return $duration
    } else {
        Write-Error "Could not retrieve the video duration."
    }
}

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Prompt the user for the game name
$gameName = Read-Host -Prompt "Enter name of game"

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Filter *.mkv

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    Write-Output $file.Name
    $currentTime = Get-DateFromFileName -fileName $file.Name
    $timeZone = Get-TimeZoneFromFileName -fileName $file.Name
    if ($timeZone -eq "") {
        $timeZone = $fallbackTimeZone
    }
    if ($timeZone -ne "") {
        $timeZone = " " + $timeZone
    }

    # Replay branch subtracts the video duration from the set time, as
    # the replay buffer sets the time to when the recording was saved
    # as opposed to regular recordings which sets the time as the start.
    if ($file.Name -match "Replay") {
        try {
            $videoDuration = Get-VideoDuration -videoPath $file.FullName
            $newDateTime = $currentTime.Subtract($videoDuration)
            $dateString = $newDateTime.ToString("yyyy-MM-dd HH-mm-ss")
            $newFileName = "Screen Rec $dateString$timeZone $gameName$($file.Extension)"
            Rename-Item -Path $file.FullName -NewName $newFileName
        }
        catch {
            Write-Host "Error processing $file $_"
        }
    } else {
        $dateString = $currentTime.ToString("yyyy-MM-dd HH-mm-ss")
        $newFileName = "Screen Rec $dateString$timeZone $gameName$($file.Extension)"
        Rename-Item -Path $file.FullName -NewName $newFileName
    }
}

Write-Host "Files have been renamed!"