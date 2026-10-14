# TG2D — Écosystème Logiciel Unifié (Monorepo)

Dépôt centralisé regroupant les deux plateformes logicielles de l'entreprise **TG2D (Travaux Généraux de Développement Durable)** :
1. **`apps/website`** : Site web vitrine institutionnel et interactif (Architecture tous corps d'état, moteur 3D 300 frames, 31 pages de réalisations et expertises).
2. **`apps/paperless-ged`** : Système de Gestion Électronique des Documents (GED / EDM) propulsé par Paperless-ngx, Docker, Tesseract OCR et branding sur-mesure TG2D.

---

## Architecture du Dépôt

```text
TG2D-ECOSYSTEM/
├── apps/
│   ├── website/              # Site Vitrine Officiel TG2D (HTML5 / Vanilla CSS / JS)
│   │   ├── index.html
│   │   ├── a-propos.html, expertises.html, projets.html, flotte.html, contact.html
│   │   ├── styles.css & app.js
│   │   ├── assets/           # Photographies chantiers, logos officiels
│   │   ├── scroll-frames-webp/ # Séquence 300-frames haute performance
│   │   ├── .htaccess         # Configuration NindoHost (HTTPS force, cache LiteSpeed/Apache)
│   │   └── .cpanel.yml       # Déploiement cPanel Git Version Control
│   │
│   └── paperless-ged/        # Plateforme GED Documentaire TG2D (Paperless-ngx)
│       ├── docker-compose.yml
│       ├── docker-compose.env & .env
│       ├── branding/         # Logos TG2D, favicon, script apply-branding.sh
│       ├── consume/          # Répertoire d'ingestion automatique des PDF / factures
│       └── export/           # Répertoire d'export sécurisé
│
├── docker-compose.yml        # Orchestrateur global multi-conteneurs
├── Makefile                  # Commandes d'exécution rapides (make up, make website, make ged)
└── .github/workflows/deploy.yml # Pipeline CI/CD GitHub Actions
```

---

## Démarrage Rapide

### 1. Lancer l'ensemble des deux logiciels (Recommandé)
```bash
make up
# ou : docker compose up -d
```
* **Site Web TG2D** : [http://localhost:8080](http://localhost:8080)
* **Portail GED Paperless** : [http://localhost:8001](http://localhost:8001)

### 2. Lancer uniquement le Site Web Vitrine
```bash
make website
# ou : docker compose up -d website
```
Le site est immédiatement accessible sur [http://localhost:8080](http://localhost:8080).

### 3. Lancer uniquement la GED Paperless
```bash
make ged
# ou : docker compose up -d broker db gotenberg tika webserver
```
La GED est immédiatement accessible sur [http://localhost:8001](http://localhost:8001).

### 4. Arrêter tous les services
```bash
make down
```

---

## Déploiement en Production

### Déploiement du Site Web (`apps/website`) sur NindoHost :
* **Méthode ZIP** : Téléversez le fichier `tg2d-nindohost-deploy.zip` généré à partir de `apps/website/` dans `public_html/`.
* **Méthode Git Version Control** : Clonez le dépôt et spécifiez le chemin `apps/website/` dans le fichier `.cpanel.yml`.
* **Méthode GitHub Actions** : Configurez vos secrets FTP sur GitHub (`FTP_SERVER`, `FTP_USERNAME`, `FTP_PASSWORD`) pour un déploiement continu à chaque commit sur `main`.

### Déploiement de la GED (`apps/paperless-ged`) sur VPS Cloud :
* Cloner ce dépôt sur votre VPS Linux (Ubuntu / Debian).
* Naviguer dans le dossier ou lancer depuis la racine :
  ```bash
  docker compose up -d
  ```
* Configurer un reverse proxy Nginx avec certificat SSL (Let's Encrypt) pointant vers `ged.tg2d-maroc.com`.
