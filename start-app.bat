@echo off
title Math10 AI Application Starter
echo ===================================================
echo     DANG KHOI DONG HE THONG MATH10 AI (PORT 8081)
echo ===================================================
cd /d "%~dp0\backend"
set "PATH=%~dp0\.tools\sql-auth;%PATH%"
echo Dang chay Maven Spring Boot...
mvn -o spring-boot:run
pause
