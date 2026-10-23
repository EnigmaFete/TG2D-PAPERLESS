@echo off
title TG2D - Configuration du Demarrage Automatique Windows
color 0b

echo ==============================================================================
echo        TG2D - Configuration du demarrage automatique avec Windows
echo ==============================================================================
echo.
echo Ce script configure Windows pour que le serveur TG2D demarre automatiquement
echo en arriere-plan a chaque allumage de l'ordinateur, sans action manuelle.
echo.

set CURRENT_DIR=%~dp0
set SCRIPT_DIR=%CURRENT_DIR:\=/%

:: Creer le script vbs pour un demarrage silencieux (sans fenetre noire constante)
echo Set WshShell = CreateObject("WScript.Shell") > "%CURRENT_DIR%silent-start.vbs"
echo WshShell.Run "wsl -d Ubuntu bash -c ""sudo service redis-server start && cd /opt/paperless/paperless-ngx && source venv/bin/activate && (python3 src/manage.py document_consumer &) && python3 src/manage.py runserver 0.0.0.0:8000""", 0, false >> "%CURRENT_DIR%silent-start.vbs"

:: Ajouter a la tache planifiee Windows
schtasks /create /tn "TG2D_Server_AutoStart" /tr "wscript.exe \"%CURRENT_DIR%silent-start.vbs\"" /sc onlogon /rl highest /f >nul 2>&1

if %ERRORLEVEL% equ 0 (
    echo [SUCCES] Le serveur demarrera desormais automatiquement a l'ouverture de session !
) else (
    echo [INFO] Pour un demarrage automatique, lancez ce script en tant qu'administrateur.
)
echo.
pause
