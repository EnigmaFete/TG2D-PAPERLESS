# TG2D - Système de Gestion Électronique des Documents (GED)

> **TG2D · Bâtissons pour l'avenir durable**  
> Solution d'archivage documentaire intelligent, indexation OCR multilingue (Français & Anglais) et gestion multi-clients propulsée par Paperless-ngx.

---

## 🏗️ Architecture & Services

La stack Docker se compose de 5 conteneurs orchestrés :

1. **`webserver`** (Paperless-ngx v3.2+) : Serveur web d'application, OCR et recherche plein texte.
2. **`db`** (PostgreSQL 18) : Base de données relationnelle sécurisée.
3. **`broker`** (Valkey / Redis) : File d'attente de tâches asynchrones pour le traitement OCR.
4. **`tika`** (Apache Tika 3.3+) : Extraction et indexation de texte depuis les documents Office (.docx, .xlsx, .pptx).
5. **`gotenberg`** (Gotenberg 8.37) : Conversion de formats et rendu HTML/PDF/emails (.eml).

---

## 🚀 Démarrage Rapide

### 1. Prérequis
- Docker Desktop ou Docker Engine
- Docker Compose

### 2. Lancement des Services
```bash
# Démarrer la stack en arrière-plan
docker compose up -d

# Vérifier le statut des conteneurs
docker compose ps

# Consulter les logs en direct
docker compose logs -f webserver
```

### 3. Accès Web
Ouvrez votre navigateur :  
👉 **[http://localhost:8001](http://localhost:8001)**

---

## 🎨 Personnalisation & Identité Visuelle TG2D

Le dossier `branding/` contient :
- **`logo.png`** : Logo principal TG2D.
- **`icon-192.png` & `icon-512.png`** : Icônes d'application et favicon.
- **`apply-branding.sh`** : Script d'injection automatique au démarrage du conteneur appliquant la palette cyan électrique (`#02c5f1`) et le thème sobre à fort contraste.

---

## 👥 Gestion Multi-Clients

Pour attribuer des documents spécifiques à chaque client :
1. Rendez-vous dans **Paramètres > Utilisateurs & Groupes**.
2. Créez un utilisateur ou un groupe pour chaque client.
3. Configurez les permissions de visibilité (**Owner / Propriétaire**) ou automatisez via les **Flux de travail (Workflows)**.

---

## 📁 Répertoire de Consommation Automatique

Déposez simplement vos fichiers (PDF, scans, images, factures) dans :
- **`consume/`** : Paperless les analysera, les indexera automatiquement et les archivera.
