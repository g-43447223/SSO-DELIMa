@echo off
setlocal

rem Folder sumber (dalam pendrive)
set "SRC=%~dp0"
rem Folder destinasi dalam PC makmal
set "DEST=%LOCALAPPDATA%\SKPI-SSO"

echo ============================================
echo   Pemasang Hub Akses Digital SKPI
echo ============================================
echo.
echo Sumber   : %SRC%
echo Destinasi: %DEST%
echo.

rem Salin semua fail
if not exist "%DEST%" mkdir "%DEST%"
xcopy "%SRC%*" "%DEST%\" /E /I /Y /Q
if errorlevel 1 (
    echo [RALAT] Gagal menyalin fail. Cuba jalankan sebagai Administrator.
    pause
    exit /b 1
)

rem Cipta shortcut di Desktop (guna SpecialFolders supaya tepat)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; " ^
  "$desktop = $ws.SpecialFolders('Desktop'); " ^
  "$sc = $ws.CreateShortcut($desktop + '\Hub Akses Digital SKPI.lnk'); " ^
  "$sc.TargetPath = '%DEST%\JALANKAN-SKPI.bat'; " ^
  "$sc.WorkingDirectory = '%DEST%'; " ^
  "$sc.IconLocation = '%DEST%\icon.ico,0'; " ^
  "$sc.Description = 'Hub Akses Digital SKPI - Portal SSO'; " ^
  "$sc.Save(); " ^
  "Write-Host ('Shortcut dicipta di: ' + $desktop)"

if errorlevel 1 (
    echo [AMARAN] Shortcut Desktop gagal dicipta, tetapi fail telah disalin.
) else (
    echo [OK] Shortcut dicipta di Desktop.
)

rem Cipta juga di Start Menu
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
if exist "%STARTMENU%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$ws = New-Object -ComObject WScript.Shell; " ^
      "$sm = $ws.SpecialFolders('Programs'); " ^
      "$sc = $ws.CreateShortcut($sm + '\Hub Akses Digital SKPI.lnk'); " ^
      "$sc.TargetPath = '%DEST%\JALANKAN-SKPI.bat'; " ^
      "$sc.WorkingDirectory = '%DEST%'; " ^
      "$sc.IconLocation = '%DEST%\icon.ico,0'; " ^
      "$sc.Description = 'Hub Akses Digital SKPI - Portal SSO'; " ^
      "$sc.Save()" >nul 2>&1
)

echo.
echo Pemasangan selesai. Cari ikon "Hub Akses Digital SKPI" di Desktop.
pause
