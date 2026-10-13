@echo off
chcp 65001 >nul
rem ==========================================================
rem  Пранк "Фейковый вирус" - запуск для Windows
rem  Ничего настоящего не удаляет. Esc - выход из полноэкранного.
rem ==========================================================
setlocal
set "HERE=%~dp0"
set "TARGET=%HERE%index.html"
set "URL=file:///%TARGET:\=/%"

rem Пробуем Microsoft Edge в полноэкранном (kiosk) режиме
where msedge >nul 2>nul && start "" msedge --kiosk --no-first-run "%URL%" && goto :eof
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" (
  start "" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" --kiosk --no-first-run "%URL%"
  goto :eof
)
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" (
  start "" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" --kiosk --no-first-run "%URL%"
  goto :eof
)

rem Пробуем Google Chrome
where chrome >nul 2>nul && start "" chrome --kiosk "%URL%" && goto :eof
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" (
  start "" "%ProgramFiles%\Google\Chrome\Application\chrome.exe" --kiosk "%URL%"
  goto :eof
)

rem Запасной вариант: обычное окно браузера
start "" "%TARGET%"
