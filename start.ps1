Set-Culture id-ID
Set-WinSystemLocale id-ID
Set-WinUserLanguageList id-ID -Force
Copy-Item -Recurse C:\E-Klaim\restore C:\E-Klaim\backup\restore
$env:PATH += ";C:\E-Klaim\include\7za465"
$eklaim_php_error_log = Start-Process -NoNewWindow powershell { Get-Content -Tail 0 -Wait C:\E-Klaim\tmp\php-error.log | C:\decode.ps1 } -PassThru
$eklaim_php_debug_log = Start-Process -NoNewWindow powershell { Get-Content -Tail 0 -Wait C:\E-Klaim\tmp\debuglog | C:\decode.ps1 } -PassThru
$apache = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { .\apache\bin\httpd } -PassThru
$mysql = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { .\mysql\bin\mysqld --defaults-file=mysql\bin\my.ini --standalone --console } -PassThru
$apache_access_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\access.log } -PassThru
$apache_error_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\error.log } -PassThru
$apache_php_error_log = Start-Process -NoNewWindow -WorkingDirectory "C:\xampp" powershell { Get-Content -Tail 0 -Wait .\apache\logs\php_error.log } -PassThru
$apache,$mysql | wait-process