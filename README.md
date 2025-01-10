# Organisational Scripts

Personal repository to house my own collection of scripting for quick file system organisation. It's pretty niche stuff, but I'm making them publicly available in case anyone has some use for them.

## Screenshot

### Prerequisites
- The compression is handled via OxiPNG. This processes the image losslessly so that no detail is lost. Ensure it is available via environmental variables.
- Images file names can have the following information in the file name: `YYYY-MM-DD HH-MM-SS` (date and time) and `+TTTT` (timezone).
- In the event that timezone is omitted, you can use a command line parameter to add it in.
- If the date and time information is not included, it makes use of the last modified date of the file instead.
  
### Run Script
This is the main pipeline that handles the compression and organisation process via these steps:
1. Renames the file to the format of "Screenshot YYYY-MM-DD HH-MM-SS +TTTT Game_Name".
2. Processes the video via OxiPNG. Settings are currently embedded in the Process.ps1 script itself.
3. Updates the exif data to embed date based on the file name.
4. Generates the Immich metadata XML file with the tag for the game name.
5. Transfers it to the dedicated screenshot folder in a year based subdrectory.

## Screen Rec

### Prerequisites
- The encoding is handled via HandbrakeCLI. Ensure it is available via environmental variables.
- Video file names must date & time formatted as such: `YYYY-MM-DD HH-MM-SS` with timezone optional as `+TTTT`.
- In the event that timezone is omitted, you can use a command line parameter to add it in.
- Date and time is required, otherwise the file is skipped.

### Run Script

This is the main pipeline that handles the encoding and organisation process via these steps:

1. Renames the file to the format of "Screen Rec YYYY-MM-DD HH-MM-SS +TTTT Game_Name".
2. Processes the video via HandbrakeCLI. Settings are currently embedded in the Process.ps1 script itself.
3. Updates the exif data to embed date based on the file name.
4. Generates the Immich metadata XML file with the tag for the game name.
5. Transfers it to the dedicated screen recording folder in a year based subdrectory.

### Crop Scripts
The crop pipeline comes with two scripts. The first is to be run prior to cropping to preserve metadata, the second is run after in order to process the video.

#### Part 1
1. Renames the file to the format of "Screen Rec YYYY-MM-DD HH-MM-SS +TTTT Game_Name".
2. Updates the modified date of the file to match the file name if elegible.

#### Part 2
1. Renames the file to the format of "Screen Rec YYYY-MM-DD HH-MM-SS +TTTT Game_Name" from the modified date.
2. Processes the video via HandbrakeCLI. Settings are currently embedded in the Process.ps1 script itself.
3. Updates the exif data to embed date based on the file name.
4. Generates the Immich metadata XML file with the tag for the game name.
5. Transfers it to the dedicated screen rec folder in a year based subdrectory.
