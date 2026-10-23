@echo off
setlocal enabledelayedexpansion
title TG2D - Installation Serveur Windows (Sans Docker)
color 0b

echo ==============================================================================
echo           TG2D - SYSTEME DE GESTION ELECTRONIQUE DES DOCUMENTS
echo                     Installation Serveur Local Windows
echo ==============================================================================
echo.
echo Ce script configure votre PC Windows comme serveur central pour le bureau.
echo Aucun abonnement VPS ni Docker n'est requis.
echo.

:: Verifier si WSL est present
wsl --status >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [INFO] Activation du sous-systeme Windows (WSL)...
    echo Une fenetre de confirmation peut apparaitre.
    wsl --install -d Ubuntu --no-launch
    echo.
    echo [IMPORTANT] Si votre ordinateur demande a redemarrer, redemarrez-le,
    echo puis relancez simplement ce fichier install.bat !
    echo.
    pause
)

echo [1/3] Creation du dossier de stockage principal C:\TG2D...
if not exist "C:\TG2D" mkdir "C:\TG2D"
if not exist "C:\TG2D\data" mkdir "C:\TG2D\data"
if not exist "C:\TG2D\media" mkdir "C:\TG2D\media"
if not exist "C:\TG2D\consume" mkdir "C:\TG2D\consume"
if not exist "C:\TG2D\export" mkdir "C:\TG2D\export"

echo [2/3] Configuration du reseau et du pare-feu Windows pour le bureau...
netsh advfirewall firewall delete rule name="TG2D GED Port 8000" >nul 2>&1
netsh advfirewall firewall add rule name="TG2D GED Port 8000" dir=in action=allow protocol=TCP localport=8000 >nul 2>&1

echo [3/3] Lancement de l'installation dans l'environnement Windows...
set CURRENT_DIR=%~dp0
set SCRIPT_DIR=%CURRENT_DIR:\=/%
wsl -d Ubuntu bash -c "dos2unix '%SCRIPT_DIR%setup-wsl-host.sh' 2>/dev/null || true; bash '%SCRIPT_DIR%setup-wsl-host.sh'"

echo.
echo ==============================================================================
echo [SUCCES] L'installation du serveur TG2D est terminee !
echo Pour demarrer le serveur, double-cliquez sur "start-server.bat".
echo ==============================================================================
pause
