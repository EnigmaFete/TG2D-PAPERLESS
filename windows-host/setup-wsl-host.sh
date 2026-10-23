#!/usr/bin/env bash
set -e

echo "======================================================================"
echo "      TG2D GED - Installation Bare-Metal Windows (Zero Docker)        "
echo "======================================================================"

# 1. Mise à jour et paquets système requis
sudo apt-get update
sudo apt-get install -y \
  python3-pip \
  python3-venv \
  python3-dev \
  build-essential \
  git \
  libxml2-dev \
  libxslt1-dev \
  libpq-dev \
  libjpeg-dev \
  libmagic-dev \
  zlib1g-dev \
  tesseract-ocr \
  tesseract-ocr-fra \
  tesseract-ocr-eng \
  poppler-utils \
  ghostscript \
  redis-server \
  imagemagick \
  unpaper \
  curl

# 2. Création des répertoires de données Windows
sudo mkdir -p /mnt/c/TG2D/data /mnt/c/TG2D/media /mnt/c/TG2D/consume /mnt/c/TG2D/export
sudo chmod -R 777 /mnt/c/TG2D

# 3. Répertoire d'installation Paperless
APP_DIR="/opt/paperless/paperless-ngx"
sudo mkdir -p /opt/paperless
sudo chown -R $USER:$USER /opt/paperless

if [ ! -d "$APP_DIR" ]; then
  echo "Téléchargement de la dernière version stable de Paperless-ngx..."
  git clone https://github.com/paperless-ngx/paperless-ngx.git "$APP_DIR"
fi

cd "$APP_DIR"

# 4. Environnement virtuel Python
if [ ! -d "venv" ]; then
  echo "Création de l'environnement virtuel Python..."
  python3 -m venv venv
fi

source venv/bin/activate
pip install --upgrade pip wheel

echo "Installation des dépendances Python..."
pip install -r requirements.txt

# 5. Déploiement de la configuration
CONF_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/paperless.conf"
if [ -f "$CONF_SOURCE" ]; then
  cp "$CONF_SOURCE" "$APP_DIR/paperless.conf"
  sudo cp "$CONF_SOURCE" /etc/paperless.conf
fi

# 6. Initialisation de la base SQLite et migrations
echo "Exécution des migrations de base de données SQLite..."
python3 src/manage.py migrate

# 7. Collecte des fichiers statiques
python3 src/manage.py collectstatic --no-input

# 8. Application du branding TG2D
BRANDING_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/apply-branding-baremetal.sh"
if [ -f "$BRANDING_SCRIPT" ]; then
  bash "$BRANDING_SCRIPT" "$APP_DIR"
fi

# 9. Création automatique de l'administrateur si nécessaire
echo ""
echo "----------------------------------------------------------------------"
echo "Création du compte administrateur TG2D :"
python3 src/manage.py createsuperuser || true
echo "----------------------------------------------------------------------"

echo ""
echo "[OK] Installation terminée avec succès !"
echo "Les documents seront stockés dans : C:\TG2D"
