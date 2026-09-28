$ErrorActionPreference = "Stop"

# ============================================================
# Roku deployment configuration
# ============================================================

$RokuIP = $env:RokuIP
$RokuUser = $env:RokuUser
$RokuPassword = $env:RokuPassword

$ProjectRoot = $PSScriptRoot
$ZipFile = Join-Path $ProjectRoot "lisan.zip"

Write-Host ""
Write-Host "========================================="
Write-Host " Lisan Roku Build & Deploy"
Write-Host "========================================="
Write-Host ""

# ------------------------------------------------------------
# Remove previous ZIP
# ------------------------------------------------------------

if (Test-Path $ZipFile) {
    Remove-Item $ZipFile -Force
}

# ------------------------------------------------------------
# Create ZIP
# ------------------------------------------------------------

Write-Host "Packaging Lisan..."

$Items = @(
    "manifest",
    "source",
    "components",
    "fonts"
)

Compress-Archive `
    -Path ($Items | ForEach-Object {
        Join-Path $ProjectRoot $_
    }) `
    -DestinationPath $ZipFile `
    -Force

Write-Host "Package created:"
Write-Host $ZipFile
Write-Host ""

# ------------------------------------------------------------
# Upload to Roku
# ------------------------------------------------------------

Write-Host "Uploading to Roku at $RokuIP..."

$pair = "${RokuUser}:${RokuPassword}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encoded = [Convert]::ToBase64String($bytes)

$headers = @{
    Authorization = "Basic $encoded"
}

try {

    $response = Invoke-WebRequest `
        -Uri "http://$RokuIP/plugin_install" `
        -Method Post `
        -Headers $headers `
        -Form @{
            archive = Get-Item $ZipFile
        }

    Write-Host ""
    Write-Host "========================================="
    Write-Host " Deployment successful!"
    Write-Host "========================================="
    Write-Host ""

}
catch {

    Write-Host ""
    Write-Host "DEPLOYMENT FAILED"
    Write-Host $_.Exception.Message
    Write-Host ""

    exit 1
}