# Add-Type to load the System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Function to check if the image width is greater than a specified value
function Is-ImageWiderThan {
    param (
        [System.IO.FileInfo]$file,
        [int]$width
    )

    $image = [System.Drawing.Image]::FromFile($file.FullName)
    $result = $image.Width -gt $width
    $image.Dispose()
    return $result
}

# Function to crop the image
function Crop-Image {
    param (
        [System.IO.FileInfo]$file
    )

    $image = [System.Drawing.Image]::FromFile($file.FullName)
    $width = $image.Width
    $height = $image.Height

    # Crop out left monitor
    $left = 1600
    $upper = 0
    $right = $width
    $lower = $height
    $croppedImage = $image.Clone([System.Drawing.Rectangle]::new($left, $upper, $right - $left, $lower - $upper), $image.PixelFormat)

    # Remove black borders
    $topBar = 0
    $bottomBar = $height - 1
    
    for ($y = 0; $y -lt $height; $y++) {
        $isBlackLine = $true
        for ($x = 0; $x -lt 3840; $x++) {
            if ($croppedImage.GetPixel($x, $y).ToArgb() -ne [System.Drawing.Color]::Black.ToArgb()) {
                $isBlackLine = $false
                break
            }
        }
        if ($isBlackLine) {
            $topBar++
        } else {
            break
        }
    }
    
    for ($y = $height - 1; $y -ge 0; $y--) {
        $isBlackLine = $true
        for ($x = 0; $x -lt 3840; $x++) {
            if ($croppedImage.GetPixel($x, $y).ToArgb() -ne [System.Drawing.Color]::Black.ToArgb()) {
                $isBlackLine = $false
                break
            }
        }
        if ($isBlackLine) {
            $bottomBar--
        } else {
            break
        }
    }

    # Save the cropped image
    $savePath = Join-Path -Path $bufferFolder -ChildPath $file.Name
    $croppedImage = $croppedImage.Clone([System.Drawing.Rectangle]::new(0, $topBar, 3840, $bottomBar - $topBar + 1), $image.PixelFormat)
    $croppedImage.Save($savePath)
    $croppedImage.Dispose()
    $image.Dispose()
}

# Prompt the user for the new name
$newName = Read-Host -Prompt "Enter name of game"

# Define the input and output folders
$inputFolder = "Input"
$bufferFolder = "Input\Buffer"
$outputFolder = "Output"

# Create buffer folder
if (-not (Test-Path -Path $bufferFolder)) { 
    New-Item -ItemType Directory -Path $bufferFolder | Out-Null
}

# Get all video files in the input folder
$imageFiles = Get-ChildItem -Path $inputFolder -Filter "*.png"

# Loop through each video file and crop them
foreach ($file in $imageFiles) {
    $date = $file.LastWriteTime

    if (Is-ImageWiderThan $file 3840) {
        Crop-Image $file
    } else {
        Copy-Item -Path $file.FullName -Destination $bufferFolder
    }

    $file = Get-Item -Path "$bufferFolder\$file"

    Invoke-Expression "oxipng -o 4 `"$($file.FullName)`""

    # Format the new file name
    $newFileName = "Screenshot $($date.ToString("yyyy-MM-dd HH-mm-ss")) $newName$($file.Extension)"
    Rename-Item -Path $file.FullName -NewName $newFileName
    
    # Move to output
    Move-Item -Path "$bufferFolder\$newFileName" -Destination $outputFolder
}

# Delete the temporary folder after processing
Remove-Item -Path $bufferFolder -Recurse -Force

Write-Output "Processing complete!"