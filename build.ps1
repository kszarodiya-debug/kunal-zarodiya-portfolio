param([string]$OutDir = 'dist')

$root = (Get-Location).Path
$destination = Join-Path $root $OutDir
New-Item -ItemType Directory -Force -Path $destination | Out-Null
Copy-Item -LiteralPath (Join-Path $root 'index.html') -Destination $destination -Force
Copy-Item -LiteralPath (Join-Path $root 'styles.css') -Destination $destination -Force
Copy-Item -LiteralPath (Join-Path $root 'script.js') -Destination $destination -Force
Copy-Item -LiteralPath (Join-Path $root 'favicon.svg') -Destination $destination -Force
Write-Host "Production-ready static files copied to $destination"
