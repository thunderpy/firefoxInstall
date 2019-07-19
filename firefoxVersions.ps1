# Powershell script to install firefox by mentioning version number.
# https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2

$tag = Invoke-WebRequest https://download-installer.cdn.mozilla.net/pub/firefox/releases/
$table  = $tag.ParsedHtml.body.getElementsByTagName('a')
$firefoxVerList = $table | Select-Object -Property nameProp 

Write-Host "Please wait scrapping for firefox versions..........." -ForegroundColor Cyan
sleep 0.5

Write-Host "Select Verison from the Below List:- " -ForegroundColor Yellow 
$firefoxVerList | Format-Wide -Column 6

sleep 2 

[string]$version = Read-Host -Prompt "Please enter firefox version from above table"
$fileName='firefox_'+$version+'.exe'
$url="https://download-installer.cdn.mozilla.net/pub/firefox/releases/$version/win32/en-US/Firefox%20Setup%20$version.exe"


# Check if setup exist and download.
if(!(Test-Path $fileName)){
    # Download setup file.
    Invoke-WebRequest $url -OutFile firefox_$version.exe
}


# Stop firefox process
$firefox = Get-Process firefox -ErrorAction SilentlyContinue

if($firefox){
        $firefox | Stop-Process -Force
    }

sleep 4

# Install download firefox version.
Start-Process -FilePath $fileName -ArgumentList '-ms'

Write-Host "Firefox version $version is installed." -BackgroundColor Blue