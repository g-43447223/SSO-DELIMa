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
echo Sumber  : %SRC%
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

rem Cipta shortcut di Desktop
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ws = New-Object -ComObject WScript.Shell; " ^
  "$sc = $ws.CreateShortcut('%USERPROFILE%\Desktop\Hub Akses Digital SKPI.lnk'); " ^
  "$sc.TargetPath = '%DEST%\JALANKAN-SKPI.bat'; " ^
  "$sc.WorkingDirectory = '%DEST%'; " ^
  "$sc.IconLocation = '%DEST%\icon-192.png,0'; " ^
  "$sc.Description = 'Hub Akses Digital SKPI - Portal SSO'; " ^
  "$sc.Save()"

if errorlevel 1 (
    echo [AMARAN] Shortcut Desktop gagal dicipta, tetapi fail telah disalin.
) else (
    echo [OK] Shortcut dicipta di Desktop.
)

rem Cipta juga di Start Menu (pilihan)
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
if exist "%STARTMENU%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$ws = New-Object -ComObject WScript.Shell; " ^
      "$sc = $ws.CreateShortcut('%STARTMENU%\Hub Akses Digital SKPI.lnk'); " ^
      "$sc.TargetPath = '%DEST%\JALANKAN-SKPI.bat'; " ^
      "$sc.WorkingDirectory = '%DEST%'; " ^
      "$sc.IconLocation = '%DEST%\icon-192.png,0'; " ^
      "$sc.Description = 'Hub Akses Digital SKPI - Portal SSO'; " ^
      "$sc.Save()" >nul 2>&1
)

echo.
echo Pemasangan selesai. Double-click ikon "Hub Akses Digital SKPI" di Desktop.
pause
