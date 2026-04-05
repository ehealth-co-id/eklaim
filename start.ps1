Set-Culture id-ID
Set-WinSystemLocale id-ID
Set-WinUserLanguageList id-ID -Force

$OldErrorActionPreference = $ErrorActionPreference
try {
    $ErrorActionPreference = 'SilentlyContinue'
    $version = (Get-Content -Path "C:\E-Klaim\version.txt" -Raw).Trim()
} catch {
    $version = ""
} finally {
    $ErrorActionPreference = $OldErrorActionPreference
}

Write-Host "Current version: $version"
Write-Host "Expected version: 5.10.7"

if ($version -ne "5.10.7") {
    Write-Host "Patching..."
    ((Get-FileHash patch.exe).Hash -eq 'F2881FCEA3470C2B839CA10CEF26F543C425909D78A6DDBD4D67C91EE8A694A3') -or $(exit 1)
    Start-Process -FilePath 'patch.exe' -ArgumentList @('/VERYSILENT', '/SP-', '/NORESTART', '/SUPPRESSMSGBOXES') -Wait
    Set-Content c:\E-Klaim\version.txt '5.10.7' -NoNewline;
    Write-Host "Patching done."
}

Write-Host "Configuring..."
(Get-Content C:\E-Klaim\server.ini).Replace('debuglog = 0', 'debuglog = 1') | Set-Content C:\E-Klaim\server.ini
(Get-Content C:\E-Klaim\server.ini).Replace('errorlog = 0', 'errorlog = 1') | Set-Content C:\E-Klaim\server.ini
Set-Content -Path "C:\E-Klaim\tmp\php-error.log" -Value $null
Set-Content -Path "C:\E-Klaim\tmp\debuglog" -Value $null
Write-Host "Configuring done."

Write-Host "Starting services..."
$env:PATH += ";C:\E-Klaim\include\7za465"
$eklaim_php_error_log = Start-Process -NoNewWindow powershell { Get-Content -Tail 0 -Wait C:\E-Klaim\tmp\php-error.log | C:\decode.ps1 } -PassThru
$eklaim_php_debug_log = Start-Process -NoNewWindow powershell { Get-Content -Tail 0 -Wait C:\E-Klaim\tmp\debuglog | C:\decode.ps1 } -PassThru
$apache = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { .\apache\bin\httpd } -PassThru
$mysql = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { .\mysql\bin\mysqld --defaults-file=mysql\bin\my.ini --standalone --console } -PassThru
$apache_access_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\access.log } -PassThru
$apache_error_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\error.log } -PassThru
$apache_php_error_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\php_error.log } -PassThru
Write-Host "Services started."
$apache,$mysql | wait-process