# run-now.ps1 — start Flask, then Electron

$ErrorActionPreference = "Stop"
function Wait-Http200($url, $tries=40) {
  for ($i=0; $i -lt $tries; $i++) {
    try {
      $r = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
      if ($r.StatusCode -eq 200) { return $true }
    } catch { Start-Sleep -Milliseconds 500 }
  }
  return $false
}

Write-Host "Starting Flask…" -ForegroundColor Cyan
$env:FLASK_DEBUG="1"
$flask = Start-Process -FilePath "python" -ArgumentList "app.py" -PassThru -WindowStyle Hidden

if (-not (Wait-Http200 "http://127.0.0.1:5000/ping" 40)) {
  Write-Host "Flask didn’t answer /ping. Check app.py console." -ForegroundColor Red
  Stop-Process -Id $flask.Id -ErrorAction SilentlyContinue
  exit 1
}
Write-Host "Flask is up." -ForegroundColor Green

Write-Host "Launching Electron…" -ForegroundColor Cyan
Push-Location ".\electron"
try {
  npx --yes electron .
} finally {
  Pop-Location
  if ($flask -and -not $flask.HasExited) { Stop-Process -Id $flask.Id -ErrorAction SilentlyContinue }
}
