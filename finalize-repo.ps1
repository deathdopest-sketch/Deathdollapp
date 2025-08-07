# finalize-repo.ps1
param(
  [string]$Tag = "v1.0.1",
  [string]$ReleaseTitle = "DeathDoll $($Tag)"
)

Write-Host "☠️ Finalizing DeathDoll repo…"

# --- sanity checks ---
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "Git not installed or not in PATH."; exit 1
}

$root = "C:\Users\Death\Desktop\DeathDollApp"
Set-Location $root

# --- .gitignore (keep repo lean) ---
@'
.env
__pycache__/
*.pyc
*.log
.DS_Store
Thumbs.db
electron/node_modules/
electron/build/
electron/*.zip
_artifacts/
'@ | Out-File -Encoding utf8 .gitignore

# --- README.md ---
@'
# DeathDoll (Emmie) 💀

Undead gothic AI companion — Flask backend + Electron desktop.
Download the installer from **Releases**.

## Install (from Releases)
Grab the latest `.exe` from the Releases page and run it.

## Dev
Backend:
```bash
python -m venv .venv && .venv\Scripts\activate
pip install -r requirements.txt
python app.py
