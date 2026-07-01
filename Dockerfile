FROM mcr.microsoft.com/windows/servercore:ltsc2022
SHELL ["powershell"]
RUN (Install-WindowsFeature Net-Framework-Core)
# Locked to ltsc2022 and 5.6.0 because it requires Net-Framework-Core
# (Net-Framework-Core is not available in newer Windows Server releases)
RUN ($ErrorActionPreference = 'Stop'); \
    ((New-Object net.webclient).Downloadfile('https://static.ehealth.co.id/Setup_E-Klaim_INA-CBG_5.6.0.202201041418.exe', 'setup.exe')); \
    ((Get-FileHash setup.exe).Hash -eq '5E324A37CEF69C76D6C3E102AB9C1D0DF9C1F04862234F5237BD02C4EFD469C9') -or $(exit 1); \
    (Start-Process -FilePath 'setup.exe' -ArgumentList @('/VERYSILENT', '/SP-', '/NORESTART', '/SUPPRESSMSGBOXES') -Wait); \
    (Remove-Item setup.exe);
RUN ($ErrorActionPreference = 'Stop'); \
    ((New-Object net.webclient).Downloadfile('https://inacbg.kemkes.go.id/DL/Patch_E-Klaim_INA-CBG_5.10.8.202606251251.exe', 'patch.exe')); \
    ((Get-FileHash patch.exe).Hash -eq 'AB47D90931FDB20D65A535D11675BA2F7C2C02D59B4BCAE573316CDF11D01E94') -or $(exit 1); \
    (Start-Process -FilePath 'patch.exe' -ArgumentList @('/VERYSILENT', '/SP-', '/NORESTART', '/SUPPRESSMSGBOXES') -Wait); \
    (Set-Content c:\E-Klaim\version.txt '5.10.8' -NoNewline)
COPY *.ps1 C:/
COPY ioncube_loader_win_5.6.dll C:/xampp/php/ext/ioncube_loader_win_5.6.dll
ENTRYPOINT "powershell C:\start.ps1"
EXPOSE 80