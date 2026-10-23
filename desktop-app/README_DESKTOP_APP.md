# TG2D Desktop App (Client pour l'Équipe)

Cette application de bureau Electron permet à tous les membres de l'équipe de se connecter au serveur central TG2D depuis leur PC (Windows) ou leur Mac, sans ouvrir de navigateur et avec une interface dédiée.

---

## 🚀 Fonctionnalités
* **Zéro configuration pour les utilisateurs** : L'adresse du serveur est enregistrée automatiquement.
* **Écran de reconnexion élégant** : En cas de coupure réseau ou si le serveur est éteint, un écran informe l'utilisateur avec possibilité de tester la connexion.
* **Glisser-Déposer direct** : Permet de glisser un PDF ou une facture directement depuis le bureau dans l'application.
* **Thème TG2D Cyan** : Respecte l'identité visuelle de l'entreprise.

---

## 🛠️ Comment générer les installateurs pour l'équipe ?

Depuis ce dossier `desktop-app/` :

### 1. Générer l'installateur Windows (`.exe`)
```bash
npm run build:win
```
L'installateur sera généré dans le dossier `dist/` :
- `dist/TG2D - Gestion Documentaire Setup 1.0.0.exe` (Installateur officiel)
- `dist/TG2D - Gestion Documentaire 1.0.0.exe` (Version portable sans installation)

### 2. Générer l'installateur Mac (`.dmg`)
```bash
npm run build:mac
```
Le fichier `.dmg` sera généré dans `dist/` :
- `dist/TG2D - Gestion Documentaire-1.0.0.dmg`

---

## 💻 Tester l'application en mode développement
Pour lancer immédiatement l'application sur votre machine de test :
```bash
npm start
```
