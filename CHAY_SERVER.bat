@echo off
chcp 65001 >nul
title Math10 AI — May Chu Backend (PRJ301)
color 0A

echo ===================================================================
echo               MATH10 AI — HỆ THỐNG HỌC TOÁN 10
echo              Máy chủ đang khởi động trên cổng 8081...
echo ===================================================================
echo.

cd /d "%~dp0backend"
set "PATH=%~dp0.tools\sql-auth;%PATH%"

echo [1/2] Đang chuẩn bị môi trường...
echo [2/2] Khởi chạy máy chủ Math10 AI...
echo.
echo ===================================================================
echo     Địa chỉ web: http://localhost:8081/
echo     Để tắt server, hãy bấm Ctrl + C hoặc đóng cửa sổ này.
echo ===================================================================
echo.

timeout /t 2 /nobreak >nul
start "" "http://localhost:8081/"

if exist "target\math10ai-backend-0.1.0.jar" (
    java -Dfile.encoding=UTF-8 -Djava.library.path="%~dp0.tools\sql-auth" -jar target\math10ai-backend-0.1.0.jar
) else (
    mvn spring-boot:run
)

pause
