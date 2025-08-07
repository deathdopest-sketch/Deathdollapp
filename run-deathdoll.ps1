# run-deathdoll.ps1
Write-Host "Starting DeathDoll... please wait."

# Check if Python is installed
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python is not installed. Please install Python 3.10+ and try again."
    exit 1
}

# Ensure app.py exists
$appPath = ".\app.py"
if (-not (Test-Path $appPath)) {
    Write-Error "app.py not found in project root. Make sure it exists at: $appPath"
    exit 1
}

# Launch Flask app
Write-Host "Launching Flask server..."
Start-Process -NoNewWindow -FilePath "python" -ArgumentList "app.py" -WorkingDirectory "."

function Wait-For-Flask {
    param (
        [string]$url = "http://127.0.0.1:5000",
        [int]$timeoutSeconds = 60
    )

    Write-Host "Waiting for Flask to start..."
    $sw = [Diagnostics.Stopwatch]::StartNew()
    while ($sw.Elapsed.TotalSeconds -lt $timeoutSeconds) {
        try {
            $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
            if ($resp.StatusCode -eq 200) {
                Write-Host "Flask is up!"
                return
            }
        } catch {}
        Start-Sleep -Seconds 1
    }

    Write-Error "Flask didn't start in time. Electron will fail with a white screen."
    exit 1
}

Wait-For-Flask

# Launch Electron
Write-Host "Launching Electron..."
cd .\electron
npm start