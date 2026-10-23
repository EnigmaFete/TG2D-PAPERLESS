# TG2D - Guide de Déploiement Local (Sans Docker & Sans VPS)

Ce document décrit l'architecture complète pour faire fonctionner **TG2D - Gestion Électronique des Documents** au sein de votre entreprise :
- **0 € / mois** : Pas de VPS, pas de frais cloud.
- **0 Docker** : Exécution native optimisée, sans conteneurisation lourde.
- **Accès Équipe Partagé** : Tous les collaborateurs (Windows et Mac) ont accès aux mêmes documents en direct.

---

## 🏗️ Structure de la Solution

```
paperless ngx/
├── windows-host/             # Package pour le PC Serveur Windows du bureau
│   ├── install.bat           # Script d'installation automatique en 1 clic
│   ├── start-server.bat      # Démarrage du serveur et affichage de l'IP bureau
│   ├── setup-autostart.bat   # Configuration du lancement automatique avec Windows
│   ├── paperless.conf        # Configuration SQLite et réseau local
│   ├── setup-wsl-host.sh     # Script interne de configuration
│   └── README_WINDOWS_HOST.md# Guide détaillé pour le serveur
│
├── desktop-app/              # Application de bureau pour l'équipe (Windows & Mac)
│   ├── src/                  # Code source (Electron + interface TG2D)
│   ├── assets/               # Logos et icônes TG2D
│   ├── package.json          # Définition du projet et scripts de build
│   └── README_DESKTOP_APP.md # Guide de génération des installateurs (.exe / .dmg)
│
└── branding/                 # Logos, icônes et scripts de personnalisation TG2D
```

---

## 🖥️ Partie 1 : Mise en place du Serveur Windows (Au Bureau)

1. Prenez le PC Windows dédié (Windows 10, 11 ou Windows Server).
2. Copiez l'intégralité du dossier `paperless ngx` dessus.
3. Allez dans le dossier `windows-host/`.
4. Clic droit sur **`install.bat`** > **Exécuter en tant qu'administrateur**.
   - Le script installe le moteur OCR, configure la base de données locale **SQLite** (aucun serveur PostgreSQL requis), ouvre le port pare-feu et applique la charte graphique TG2D.
   - Il vous demandera de créer votre identifiant administrateur.
5. Double-cliquez sur **`start-server.bat`** :
   - Une fenêtre s'ouvre et affiche l'adresse locale du serveur, par exemple :
     ```
     👉  http://192.168.1.50:8000
     ```
6. *(Optionnel)* Clic droit sur **`setup-autostart.bat`** > **Exécuter en tant qu'administrateur** pour que le serveur démarre automatiquement dès l'allumage du PC.

---

## 👥 Partie 2 : Distribution aux Collaborateurs (Windows & Mac)

Pour que votre équipe accède à TG2D sans avoir à manipuler des URL ou des lignes de commande :

### Méthode A : L'Application de Bureau TG2D (Recommandé)
1. Dans le dossier `desktop-app/`, générez les installateurs :
   - Pour Windows (`TG2D Setup.exe`) :
     ```bash
     npm run build:win
     ```
   - Pour Mac (`TG2D.dmg`) :
     ```bash
     npm run build:mac
     ```
2. Envoyez le fichier `.exe` ou `.dmg` à vos collaborateurs sur une clé USB ou par email/messagerie interne.
3. Dès l'ouverture, l'application se connecte au serveur du bureau et permet :
   - Le glisser-déposer de PDF / scans pour indexation automatique.
   - La recherche instantanée plein texte dans les documents.
   - Le classement par projet, fournisseur et catégorie.

### Méthode B : Accès Web Direct (Zéro Installation)
Si un collaborateur ne souhaite pas installer l'application :
- Il lui suffit d'ouvrir son navigateur (Chrome, Edge, Safari) et d'entrer l'adresse du serveur affichée par `start-server.bat` (ex: `http://192.168.1.50:8000`).

---

## 💾 Sauvegarde des Données (Backup)
Toutes les données de l'entreprise sont stockées en clair dans le dossier **`C:\TG2D`** du PC serveur :
- `C:\TG2D\media\` : Tous les documents PDF et scans.
- `C:\TG2D\data\db.sqlite3` : La base de données de classement et d'indexation.

**Pour faire une sauvegarde complète :**
Copiez simplement le dossier `C:\TG2D` sur un disque dur externe ou une clé USB chaque semaine.
