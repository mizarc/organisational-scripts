param (
    [string]$folder,
    [string[]]$extensions
)

Add-Type -AssemblyName Microsoft.VisualBasic

function Move-ToRecycleBin {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Path
    )
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($Path, 'OnlyErrorDialogs', 'SendToRecycleBin')
}

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
        Move-ToRecycleBin -Path $file.FullName
    }
}

Write-Host "Folder has been cleared!`n" -ForegroundColor Green