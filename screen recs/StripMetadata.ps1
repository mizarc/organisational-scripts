param (
    [string]$folder
)

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Get the folder shell object
$shellApp = New-Object -ComObject Shell.Application
$fullPath = (Resolve-Path -Path $folder).ToString()
$shellFolder = $shellApp.Namespace("$fullPath")

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Filter *.mp4

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    exifTool -CreateDate= -overwrite_original $file.FullName
}

Write-Output "Files have had their modification date set!"