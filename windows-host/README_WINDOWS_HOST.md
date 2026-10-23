# Guide de Déploiement : Serveur Local TG2D sur Windows (Sans Docker & Sans VPS)

Ce dossier contient tous les scripts nécessaires pour transformer un ordinateur Windows (Windows 10, 11 ou Windows Server) en **serveur central de gestion documentaire** pour votre équipe au bureau.

---

## ⚡ Pourquoi cette approche ?
* **0 € / mois** : Aucun abonnement VPS ou cloud nécessaire.
* **0 Docker** : N'utilise pas Docker Desktop (économise 4 Go+ de mémoire RAM).
* **Données 100% privées** : Tous les documents sont enregistrés directement sur votre disque `C:\TG2D`.
* **Sauvegarde ultra-simple** : Pour sauvegarder l'intégralité du système, il suffit de copier le dossier `C:\TG2D` sur un disque dur externe ou une clé USB.

---

## 🚀 Installation en 3 Étapes

### Étape 1 : Copier les fichiers
Copiez le dossier du projet TG2D sur le PC Windows dédié au bureau (par exemple sur le Bureau ou à la racine de `C:\`).

### Étape 2 : Lancer l'installation
1. Faites un clic droit sur **`install.bat`** > **Exécuter en tant qu'administrateur**.
2. Le script configure automatiquement :
   - Le moteur OCR (Français + Anglais).
   - La base de données locale SQLite.
   - Les dossiers de documents sur `C:\TG2D`.
   - L'ouverture du port réseau pour que les collègues puissent se connecter.
   - La charte graphique TG2D (Cyan électrique `#02c5f1` & logo).
3. À la fin, le script vous demandera de créer votre premier identifiant / mot de passe administrateur.

### Étape 3 : Démarrer le serveur
* Double-cliquez sur **`start-server.bat`**.
* La fenêtre affichera l'adresse IP locale du serveur, par exemple :
  ```
  👉  http://192.168.1.45:8000
  ```
* Vos collaborateurs peuvent immédiatement utiliser cette adresse dans leur application de bureau TG2D ou dans leur navigateur internet !

---

## 🔄 Démarrage Automatique au Démarrage de Windows (Optionnel)
Pour que le serveur s'allume automatiquement en arrière-plan à chaque allumage de l'ordinateur (sans que personne n'ait besoin de double-cliquer) :
* Faites un clic droit sur **`setup-autostart.bat`** > **Exécuter en tant qu'administrateur**.

---

## 📂 Organisation des dossiers sur Windows
Tous les fichiers sont stockés en clair et sécurisés dans `C:\TG2D` :
* `C:\TG2D\media\` : Vos documents et PDF archivés.
* `C:\TG2D\consume\` : Dossier de dépôt automatique (tout fichier déposé ici est instantanément scanné par l'OCR et indexé).
* `C:\TG2D\data\` : Fichier de base de données (`db.sqlite3`).
* `C:\TG2D\export\` : Dossier pour les exports éventuels.
