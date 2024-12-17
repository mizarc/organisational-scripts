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

# Prompt the user for the new name
$newName = Read-Host -Prompt "Enter name of game"

# Define the input and output folders
$InputFolder = "Input"
$BufferFolder = "Input\Encoded"
$OutputFolder = "Output"
$allowedExtensions = @(".mkv", ".mp4")

# Ensure the output folder exists
if (-not (Test-Path -Path $BufferFolder)) {
    New-Item -ItemType Directory -Path $BufferFolder | Out-Null
}

# Get all video files in the input folder
$videoFiles = Get-ChildItem -Path $InputFolder -Filter "*.mkv"

# Loop through each video file and re-encode it
foreach ($file in $videoFiles) {
    $inputFile = $file.FullName
    $outputFile = Join-Path $BufferFolder -ChildPath ([System.IO.Path]::ChangeExtension($file.Name, ".mp4"))

    # Define the Handbrake command
    $HandbrakeCommand = "HandBrakeCLI -i `"$inputFile`" " +  # The file input
    "-o `"$outputFile`" " +  # The file output
    "--optimize " + # Optimise for web play
    "--align-av " + # Aligns the audio and video
    "--crop 0:0:0:0 " + # Do not crop
    "--width 2560 " + # Video width
    "--height 1440 " + # Video Height
    "--encoder nvenc_av1_10bit " + # Set encoder to AV1 NVENC 10 bit
    "--quality 38 " + # Quality of 38
    "--encoder-preset medium " + # Preset of Medium
    "--audio-lang-list und " + # Set language to undefined
    "--aencoder copy:aac " + # Set the audio codec to directly copy AAC without re-encoding
    "--all-audio " + # Includes all audio tracks
    "--mixdown stereo " + # Mixes the audio down to stereo
    "--arate Auto " + # Automatic sample rate
    "--drc 0 " + # Disables dynamic range compression
    "--subtitle-lang-list und " + # Undefined subtitles
    "--all-subtitles " + # Transfer all subtitles
    "--markers " + # Preserves chapter markers
    "--encopts g=120" # Sets keyframe interval to 120

    Invoke-Expression $HandbrakeCommand
}

Write-Output "Re-encoding completed for all videos in the folder."

# Get all files in the current directory
$files = Get-ChildItem -Path $BufferFolder -File

foreach ($file in $files) {
    # Check if the file has an allowed extension
    if ($allowedExtensions -contains $file.Extension.ToLower()) {
        # Create a variable to hold the original file path
        $originalFilePath = $file.FullName

        # If the file name matches "Replay"
        if ($file.Name -match "Replay") {
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
                Write-Host "Renamed $file to $newFileName"
                $file = Get-Item -Path "$($file.DirectoryName)\$newFileName"
            }
            catch {
                Write-Host "Error processing $file $_"
            }
            Write-Output $file.Name
        }  

        # Extract the date from the file name using a regular expression
        if ($file.Name -match 'Screen Rec (\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2})') {
            $dateString = $matches[1]
            
            # Convert the date string to a DateTime object
            $lastModified = [datetime]::ParseExact($dateString, "yyyy-MM-dd HH-mm-ss", $null)
            
            # Change the file's last write time to the extracted date
            $file.LastWriteTime = $lastModified

            # Get the last modified date of the file
            $lastModified = $file.LastWriteTime

            # Format the new file name
            $newFileName = "Screen Rec $($lastModified.ToString("yyyy-MM-dd HH-mm-ss")) $newName$($file.Extension)"

            # Rename the file
            Rename-Item -Path $file.FullName -NewName $newFileName
            $file = Get-Item -Path "$($file.DirectoryName)\$newFileName"
        }
    }
    
    Move-Item -Path $file -Destination $outputFolder
}

Remove-Item -Path $bufferFolder -Recurse -Force

Write-Output "Processing complete!"