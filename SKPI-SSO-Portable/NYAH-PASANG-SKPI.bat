@echo off
setlocal

set "DEST=%LOCALAPPDATA%\SKPI-SSO"

echo Menyahpasang Hub Akses Digital SKPI...
if exist "%DEST%" rmdir /S /Q "%DEST%"
if exist "%USERPROFILE%\Desktop\Hub Akses Digital SKPI.lnk" del "%USERPROFILE%\Desktop\Hub Akses Digital SKPI.lnk"
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"
if exist "%STARTMENU%\Hub Akses Digital SKPI.lnk" del "%STARTMENU%\Hub Akses Digital SKPI.lnk"

echo Selesai. Fail dan shortcut telah dibuang.
pause
