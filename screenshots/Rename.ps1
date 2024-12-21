param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Prompt the user for the game name
$newName = Read-Host -Prompt "Enter name of game"

# Get all PNG files in the folder
$imageFiles = Get-ChildItem -Path $folder -Filter *.png

# Iterate through each PNG file
foreach ($file in $imageFiles) {
    $date = $file.LastWriteTime
    $newFileName = "Screenshot $($date.ToString("yyyy-MM-dd HH-mm-ss")) $newName$($file.Extension)"
    Rename-Item -Path $file.FullName -NewName $newFileName
}

Write-Host "Files have been renamed!"