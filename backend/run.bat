@echo off
echo ========================================
echo Event Management Backend
echo ========================================
echo.
echo Starting Spring Boot application...
echo.

cd /d "%~dp0"
call mvn spring-boot:run

pause
