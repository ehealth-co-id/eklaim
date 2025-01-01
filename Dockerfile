FROM mcr.microsoft.com/windows/servercore:ltsc2022
SHELL ["powershell"]
RUN (Install-WindowsFeature Net-Framework-Core)
RUN ((New-Object net.webclient).Downloadfile('https://casemixonline.com/downloads/Setup_E-Klaim_INA-CBG_5.6.0.202201041418.exe', 'setup.exe')); \
    ((Get-FileHash setup.exe).Hash -eq '5E324A37CEF69C76D6C3E102AB9C1D0DF9C1F04862234F5237BD02C4EFD469C9') -and (Start-Process -FilePath 'setup.exe' -ArgumentList '/SILENT' -Wait); \
    (Remove-Item setup.exe);
RUN ((New-Object net.webclient).Downloadfile('https://inacbg.kemkes.go.id/DL/Patch_E-Klaim_INA-CBG_5.9.1.202412200558.exe', 'patch.exe')); \
    ((Get-FileHash patch.exe).Hash -eq '7FAD9517EB8C8743EE51AE3377CF790150C0DF7E040ED001D1CC7DE9017A780D') -and (Start-Process -FilePath 'patch.exe' -ArgumentList '/SILENT' -Wait); \
    (Remove-Item patch.exe);
RUN (Move-Item -Path C:\E-Klaim\backup\restore -Destination C:\E-Klaim\restore)
RUN (Get-Content C:\E-Klaim\server.ini).Replace('debuglog = 0', 'debuglog = 1') | Set-Content C:\E-Klaim\server.ini; \
    (Get-Content C:\E-Klaim\server.ini).Replace('errorlog = 0', 'errorlog = 1') | Set-Content C:\E-Klaim\server.ini; \
    (echo $null > C:\E-Klaim\tmp\php-error.log); \
    (echo $null > C:\E-Klaim\tmp\debuglog)
COPY *.ps1 C:/
CMD powershell C:\start.ps1
EXPOSE 80