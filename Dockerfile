FROM mcr.microsoft.com/windows/servercore:ltsc2022
SHELL ["powershell"]
RUN (Install-WindowsFeature Net-Framework-Core)
RUN ($ErrorActionPreference = 'Stop'); \
    ((New-Object net.webclient).Downloadfile('https://casemixonline.com/downloads/Setup_E-Klaim_INA-CBG_5.6.0.202201041418.exe', 'setup.exe')); \
    ((Get-FileHash setup.exe).Hash -eq '5E324A37CEF69C76D6C3E102AB9C1D0DF9C1F04862234F5237BD02C4EFD469C9') -or $(exit 1); \
    (Start-Process -FilePath 'setup.exe' -ArgumentList @('/VERYSILENT', '/SP-', '/NORESTART', '/SUPPRESSMSGBOXES') -Wait); \
    (Remove-Item setup.exe);
RUN ($ErrorActionPreference = 'Stop'); \
    ((New-Object net.webclient).Downloadfile('https://inacbg.kemkes.go.id/DL/Patch_E-Klaim_INA-CBG_5.10.7.202603311031.exe', 'patch.exe')); \
    ((Get-FileHash patch.exe).Hash -eq 'F2881FCEA3470C2B839CA10CEF26F543C425909D78A6DDBD4D67C91EE8A694A3') -or $(exit 1); \
    (Start-Process -FilePath 'patch.exe' -ArgumentList @('/VERYSILENT', '/SP-', '/NORESTART', '/SUPPRESSMSGBOXES') -Wait); \
    (Set-Content c:\E-Klaim\version.txt '5.10.6' -NoNewline)
COPY *.ps1 C:/
COPY ioncube_loader_win_5.6.dll C:/xampp/php/ext/ioncube_loader_win_5.6.dll
ENTRYPOINT "powershell C:\start.ps1"
EXPOSE 80