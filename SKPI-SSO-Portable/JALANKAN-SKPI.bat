@echo off
setlocal

rem Folder tempat fail ini berada
set "APPDIR=%~dp0"
set "INDEX=%APPDIR%index.html"

rem Tukar backslash kepada slash untuk URL
set "URL=file:///%INDEX:\=/%"

rem Cuba Edge (x86/x64), kemudian Chrome; jika tiada, buka dengan pelayar lalai
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
    start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --app="%URL%" --new-window
    goto :eof
)
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (
    start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --app="%URL%" --new-window
    goto :eof
)
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" (
    start "" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" --app="%URL%" --new-window
    goto :eof
)
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
    start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --app="%URL%" --new-window
    goto :eof
)

rem Fallback: buka dengan pelayar lalai
start "" "%INDEX%"
goto :eof
