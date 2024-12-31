param (
    [string]$inputFolder,
    [string]$outputFolder
)

Write-Host "Start processing..." -ForegroundColor Cyan

if (!$inputFolder) {
    $inputFolder = Read-Host "Please enter the input folder path"
}

if (!$outputFolder) {
    $outputFolder = Read-Host "Please enter the output folder path"
}

# Define the input and output folders
$bufferFolder = "$inputFolder\Buffer"

# Ensure the output folder exists
if (-not (Test-Path -Path $bufferFolder)) {
    New-Item -ItemType Directory -Path $bufferFolder | Out-Null
}

# Get all video files in the input folder
$videoFiles = Get-ChildItem -Path $inputFolder -Filter "*.mkv"

# Loop through each video file and re-encode it
foreach ($file in $videoFiles) {
    $inputFile = $file.FullName
    $outputFile = [System.IO.Path]::ChangeExtension($file.Name, ".mp4")
    $outputFilePath = Join-Path $bufferFolder -ChildPath $outputFile
    
    # Check to see if file already exists in output
    $testPath = Test-Path -Path (Join-Path -Path $outputFolder -ChildPath $outputFile)
    if ($testPath) {
        Write-Host "File '$($file.Name)' has already been re-encoded.`n" -ForegroundColor Red
        exit 1
    }

    Write-Host "Encoding '$($file.Name)'."

    # Define the Handbrake command
    $HandbrakeCommand = "HandBrakeCLI -i `"$inputFile`" " +  # The file input
    "-o `"$outputFilePath`" " +  # The file output
    "--verbose 1" + # Disable verbose output
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

    Invoke-Expression $HandbrakeCommand 2>$null
    Move-Item -Path $outputFilePath -Destination $outputFolder\
    Write-Host "Successfully encoded '$($file.Name)'."
}

# Delete the temporary folder after processing
Remove-Item -Path $bufferFolder -Recurse -Force

Write-Host "Processing complete!`n" -ForegroundColor Green