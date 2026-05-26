@echo off
chcp 65001 >nul
set PYTHONIOENCODING=utf-8

echo [*] SecurityAgent Web UI - Service Manager
echo =========================================

if "%1"=="start" (
    wscript.exe "E:\ZeroClaw\dayZero\start_server.vbs" //nologo
    echo [v] Service started! Visit http://localhost:5000
    echo [v] To stop: run.bat stop
    echo [v] To view: start http://localhost:5000
    start http://localhost:5000
    goto :eof
)

if "%1"=="stop" (
    for /f "tokens=2" %%a in ('tasklist /fi "imagename eq python.exe" /v /fo csv 2^>nul ^| findstr /i "web_ui"') do (
        taskkill /PID %%a /F >nul 2>&1
    )
    echo [v] Service stopped.
    goto :eof
)

if "%1"=="status" (
    tasklist /fi "imagename eq python.exe" /v /fo list 2>nul | findstr /i "web_ui"
    if errorlevel 1 echo [i] Service is not running.
    goto :eof
)

echo.
echo Usage:
echo   run.bat start       Start Web UI service (background)
echo   run.bat stop        Stop Web UI service
echo   run.bat status      Check if service is running
echo.
echo Quick commands:
echo   run.bat -t TARGET    CLI mode
echo   run.bat --web        Web UI (foreground)
