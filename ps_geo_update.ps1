$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$filesAndUrls = @{
    "geoip.dat"   = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
    "geosite.dat" = "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"
    "geoip.db"    = "https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db"
    "geosite.db"  = "https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db"
}

$urls = @{}
$files = @{}

foreach ($file in $filesAndUrls.Keys) {
    $urls[$file] = $filesAndUrls[$file]
    $files[$file] = Join-Path $scriptDir $file
}

foreach ($fileName in $urls.Keys) {
    $filePath = $files[$fileName]

    try {
        Invoke-WebRequest -Uri $urls[$fileName] -OutFile $filePath -UseBasicParsing -ErrorAction Stop
        Write-Host "File $fileName downloaded"
    }
    catch {
        Write-Host "Error when downloading ${fileName}: $_"
    }
}
