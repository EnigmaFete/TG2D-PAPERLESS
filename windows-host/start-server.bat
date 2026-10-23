@echo off
setlocal enabledelayedexpansion
title TG2D - Serveur GED Central (En cours d'execution)
color 0b

echo ==============================================================================
echo           TG2D - SYSTEME DE GESTION ELECTRONIQUE DES DOCUMENTS
echo                    Serveur Central Bureau (Local)
echo ==============================================================================
echo.

:: Recuperer l'adresse IP locale de la machine Windows
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address" /c:"Adresse IPv4"') do (
    set IP=%%a
    set IP=!IP: =!
    goto :found_ip
)
set IP=127.0.0.1
:found_ip

echo [INFO] Adresse du serveur pour l'equipe dans le bureau :
echo.
echo    ------------------------------------------------------
echo    👉   http://%IP%:8000
echo    ------------------------------------------------------
echo.
echo Les membres de votre equipe peuvent :
echo 1. Ouvrir l'application de bureau TG2D avec cette adresse.
echo 2. Ou ouvrir n'importe quel navigateur (Chrome, Edge, Safari) a cette adresse.
echo.
echo [INFO] Demarrage des services en arriere-plan...
echo (Ne fermez pas cette fenetre pour maintenir le serveur actif)
echo.

wsl -d Ubuntu bash -c "sudo service redis-server start && cd /opt/paperless/paperless-ngx && source venv/bin/activate && (python3 src/manage.py document_consumer &) && python3 src/manage.py runserver 0.0.0.0:8000"

pause
