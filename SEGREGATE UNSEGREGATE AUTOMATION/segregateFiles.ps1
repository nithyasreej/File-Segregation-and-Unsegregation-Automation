# Function to prompt the user to select a folder
function Get-FolderPath {
    Add-Type -AssemblyName System.Windows.Forms
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select a folder"
    [void]$folderBrowser.ShowDialog()
    return $folderBrowser.SelectedPath
}

# Get the folder path from the user
$folderPath = Get-FolderPath

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath

# Loop through each file
foreach ($file in $files) {
    # Skip directories
    if ($file.PSIsContainer) {
        continue
    }

    # Create a subfolder for each unique extension
    $extension = $file.Extension.TrimStart('.')
    $subfolderPath = Join-Path -Path $folderPath -ChildPath $extension

    if (-not (Test-Path $subfolderPath)) {
        New-Item -ItemType Directory -Path $subfolderPath | Out-Null
    }

    # Move the file to the corresponding subfolder
    $newFilePath = Join-Path -Path $subfolderPath -ChildPath $file.Name
    Move-Item -Path $file.FullName -Destination $newFilePath -Force
}

Write-Host "Files have been segregated based on their extensions."

