# raise-emmie.ps1
param(
  [string]$RepoUrl = "https://github.com/deathdopest-sketch/DeathDollApp.git",
  [string]$Tag = "v1.0.2"
)

$ErrorActionPreference = "Stop"

function Info($m){ Write-Host $m -ForegroundColor Magenta }

# 0) Sanity & location
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git not installed/in PATH." }
$root = "C:\Users\Death\Desktop\DeathDollApp"
Set-Location $root
Info "☠️  Raising Emmie pipeline in $root"

# 1) Keep the repo lean (.gitignore)
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
electron/*.exe
_artifacts/
'@ | Out-File -Encoding utf8 .gitignore

# 2) Untrack any already-tracked big artifacts (keep files on disk)
#    These commands won't error if paths don't exist or aren't tracked.
git rm -r --cached _artifacts 2>$null | Out-Null
git rm -r --cached electron/build 2>$null | Out-Null
# Untrack any zips/exes under electron
Get-ChildItem -Path "electron" -Include *.zip,*.exe -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
  git rm --cached $_.FullName 2>$null | Out-Null
}

# 3) README (simple)
@'
# DeathDoll (Emmie) 💀

Undead gothic AI companion — Flask backend + Electron desktop.

## Install
Grab the Windows installer from **Releases**.

## Dev
Backend:
```bash
python -m venv .venv && .venv\Scripts\activate
pip install -r requirements.txt
python app.py
