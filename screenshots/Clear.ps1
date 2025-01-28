param (
    [string]$folder,
    [string[]]$extensions
)

Write-Host "Start clearing..." -ForegroundColor Cyan

if (!$folder) {
    $folder = Read-Host "Please enter the folder path"
}

if (!$extensions) {
    $extensions = Read-Host "Please enter the file extensions to delete"
}
$extensions = $extensions -split ","

foreach ($extension in $extensions) {
    # Get all video files in the input folder
    $files = Get-ChildItem -Path $folder -Filter "*$extension"

    # Loop through each video file and crop them
    foreach ($file in $files) {
        Remove-Item -Path $file.FullName
    }
}

Write-Host "Folder has been cleared!`n" -ForegroundColor Green