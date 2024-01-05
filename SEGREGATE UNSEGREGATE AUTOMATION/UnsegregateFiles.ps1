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

# Get all subfolders in the folder
$subfolders = Get-ChildItem -Path $folderPath -Directory

# Loop through each subfolder
foreach ($subfolder in $subfolders) {
    # Move all files from subfolder to the parent folder
    Get-ChildItem -Path $subfolder.FullName | Move-Item -Destination $folderPath -Force
    Remove-Item -Path $subfolder.FullName -Force -Recurse
}

Write-Host "Files have been unsegregated."
