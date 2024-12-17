    function Get-DateFromFileName {
    param (
        [string]$fileName
    )

    # Regular expression to match the date string in the file name
    if ($fileName -match 'Screen Rec (\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2}) Replay') {
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
        Write-Error "File name does not match the expected format."
        return $null
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

$allowedExtensions = @(".mkv", ".mp4")
$CropFolder = "Crop"

# Get all files in the current directory
$files = Get-ChildItem -Path $CropFolder -File

foreach ($file in $files) {
    if ($allowedExtensions -contains $file.Extension.ToLower() -and $file.Name -match "Replay") {
        try {
            # Get the video duration
            $duration = Get-VideoDuration -videoPath $file.FullName
            
            # Get the last write time (modification date) of the file
            $currentTime = Get-DateFromFileName -fileName $file.Name
            
            # Subtract the video duration from the last write time
            $newDateTime = $currentTime.Subtract($duration)
            
            # Format the new date and time
            $dateString = $newDateTime.ToString("yyyy-MM-dd HH-mm-ss")
            
            # Construct the new file name
            $newFileName = "Screen Rec $dateString$($file.Extension)"
            
            # Rename the file
            Rename-Item -Path $file.FullName -NewName $newFileName
            $file = Get-Item -Path "$($file.DirectoryName)\$newFileName"

            # Convert the date string to a DateTime object
            $lastModified = [datetime]::ParseExact($dateString, "yyyy-MM-dd HH-mm-ss", $null)
            
            # Change the file's last write time to the extracted date
            $file.LastWriteTime = $lastModified

            Write-Host "Renamed $file to $newFileName"
        }
        catch {
            Write-Host "Error processing $file $_"
        }
    }
}
