# Navigate to the electron directory
$electronPath = "C:\Users\Death\Desktop\DeathDollApp\electron"
Set-Location $electronPath

# Backup the current package.json
Copy-Item -Path "package.json" -Destination "package.backup.json" -Force

# Read and fix the file
$json = Get-Content "package.json" -Raw | ConvertFrom-Json

# Fix paths
$json.main = "main electronmain.js"
$json.build.extraMetadata.main = "main electronmain.js"

# Optional: Add dummy author to prevent warning
if (-not $json.PSObject.Properties.Name -contains "author") {
    $json | Add-Member -NotePropertyName "author" -NotePropertyValue "Death"
}

# Write the fixed package.json back
$json | ConvertTo-Json -Depth 10 | Set-Content -Path "package.json" -Encoding UTF8

Write-Host "✅ package.json fixed successfully."
Write-Host "You can now run: npm run build"
