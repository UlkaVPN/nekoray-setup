$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$filesAndUrls = @{
    "bypass-all-except-blocked" = "https://raw.githubusercontent.com/UlkaVPN/nekoray-setup/main/config/routes_box/bypass-all-except-blocked"
    "proxy-all-except-ru"       = "https://raw.githubusercontent.com/UlkaVPN/nekoray-setup/main/config/routes_box/proxy-all-except-ru"
}

$destinationDir = Join-Path $scriptDir "config/routes_box"

if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
}

foreach ($fileName in $filesAndUrls.Keys) {
    $filePath = Join-Path $destinationDir $fileName
    $url = $filesAndUrls[$fileName]

    try {
        Invoke-WebRequest -Uri $url -OutFile $filePath -UseBasicParsing -ErrorAction Stop
        Write-Host "File $fileName downloaded to $filePath"
    }
    catch {
        Write-Host "Error when downloading ${fileName}: $_"
    }
}
