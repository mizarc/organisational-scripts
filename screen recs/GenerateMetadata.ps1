param (
    [string]$folder
)

# Define the content to be written into each new file
$contentTemplate = @"
<?xpacket begin='﻿' id='W5M0MpCehiHzreSzNTczkc9d'?>
<x:xmpmeta xmlns:x='adobe:ns:meta/' x:xmptk='Image::ExifTool 12.99'>
<rdf:RDF xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'>

 <rdf:Description rdf:about=''
  xmlns:digiKam='http://www.digikam.org/ns/1.0/'>
  <digiKam:TagsList>
   <rdf:Seq>
    <rdf:li>game/{GameName}</rdf:li>
   </rdf:Seq>
  </digiKam:TagsList>
 </rdf:Description>
</rdf:RDF>
</x:xmpmeta>
<?xpacket end='w'?>
"@

Write-Host "Start metadata generation..." -ForegroundColor Cyan

if (!$folder) {
  $folder = Read-Host "Please enter the folder path"
}

# Get all PNG files in the folder
$videoFiles = Get-ChildItem -Path $folder -Filter *.mp4

# Iterate through each PNG file
foreach ($file in $videoFiles) {
    # Replace the game name in the content with the game name in the file name
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $gameName = ($fileNameWithoutExtension -replace 'Screen Rec \d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2} ', '').ToLower()
    $gameName = ($gameName -replace '\+\d{4} ', '').ToLower()
    $content = $contentTemplate -replace '{GameName}', $gameName

    # Define the new file name and path
    $newFileName = "$($file.FullName).xmp"
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    
    # Write the content to the new file
    $content | Out-File -FilePath $newFileName -Encoding UTF8
    Write-Host "Generated metadata for '$($file.Name)'"
}

Write-Host "Metadata creation completed!`n" -ForegroundColor Green
