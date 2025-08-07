$packagePath = "C:\Users\Death\Desktop\DeathDollApp\electron\package.json"

# Step 1: Remove UTF-8 BOM if present
$bytes = [System.IO.File]::ReadAllBytes($packagePath)
if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Host "⚠️ BOM found. Removing it..."
    $bytes = $bytes[3..($bytes.Length - 1)]
    [System.IO.File]::WriteAllBytes($packagePath, $bytes)
    Write-Host "✅ BOM removed from package.json"
} else {
    Write-Host "✅ No BOM detected in package.json"
}

# Step 2: Validate JSON
try {
    $json = Get-Content $packagePath -Raw | ConvertFrom-Json
    Write-Host "✅ package.json is valid"
} catch {
    Write-Host "❌ JSON validation failed. Please check syntax!"
    exit 1
}

Write-Host "`n🚀 Now run: npm run build"
