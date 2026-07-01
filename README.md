# E-Klaim Docker

Dockerized [E-Klaim INA-CBG](https://inacbg.kemkes.go.id/) on Windows Server Core.

## Updating the Patch Version

1. Download the latest patch from:
   ```
   https://inacbg.kemkes.go.id/index.php?XP_view=1&page=download
   ```

2. Get the hash:
   ```powershell
   (Get-FileHash Patch_E-Klaim_INA-CBG_X.X.X.YYYYMMDDHHMM.exe).Hash
   ```

3. Replace the old version/URL/hash in **2 files**:

   **`Dockerfile`** — URL on line 10, hash on line 11, version on line 13
   **`start.ps1`** — expected version (line 16), comparison (line 18), hash (line 20), version (line 22)

4. Commit and push:
   ```powershell
   git add -A
   git commit -m "patch X.X.X"
   git push
   ```

   GitHub Actions auto-builds the new image to `ghcr.io/ehealth-co-id/eklaim:latest`.
