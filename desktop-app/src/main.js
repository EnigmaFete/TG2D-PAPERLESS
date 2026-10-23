const { app, BrowserWindow, Menu, ipcMain, shell, dialog } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow = null;
const configPath = path.join(app.getPath('userData'), 'tg2d-config.json');

// Gestion persistante de la configuration
function loadConfig() {
  try {
    if (fs.existsSync(configPath)) {
      return JSON.parse(fs.readFileSync(configPath, 'utf8'));
    }
  } catch (err) {
    console.error('Erreur lecture config:', err);
  }
  return {
    serverUrl: 'http://localhost:8000',
    autoConnect: true
  };
}

function saveConfig(config) {
  try {
    fs.writeFileSync(configPath, JSON.stringify(config, null, 2), 'utf8');
  } catch (err) {
    console.error('Erreur sauvegarde config:', err);
  }
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1360,
    height: 880,
    minWidth: 960,
    minHeight: 640,
    title: 'T.G.2.D - Gestion Documentaire',
    backgroundColor: '#09131b',
    icon: path.join(__dirname, '../assets/icon-512.png'),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      preload: path.join(__dirname, 'preload.js'),
      spellcheck: true
    }
  });

  const config = loadConfig();

  // Création du menu application
  createApplicationMenu();

  // Tentative de connexion
  attemptConnection(config.serverUrl);

  // Gestion des liens externes
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      const currentHost = new URL(config.serverUrl).host;
      const targetHost = new URL(url).host;
      if (currentHost !== targetHost) {
        shell.openExternal(url);
        return { action: 'deny' };
      }
    }
    return { action: 'allow' };
  });

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function attemptConnection(targetUrl) {
  if (!targetUrl || targetUrl.trim() === '') {
    showConnectScreen();
    return;
  }

  // S'assurer du préfixe http
  let formattedUrl = targetUrl.trim();
  if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
    formattedUrl = 'http://' + formattedUrl;
  }

  console.log('[TG2D] Connexion au serveur:', formattedUrl);
  mainWindow.loadURL(formattedUrl).catch((err) => {
    console.warn('[TG2D] Serveur introuvable ou erreur de chargement:', err.message);
    showConnectScreen(formattedUrl, err.message);
  });
}

function showConnectScreen(attemptedUrl = '', errorMessage = '') {
  mainWindow.loadFile(path.join(__dirname, 'connect.html'), {
    query: {
      url: attemptedUrl,
      error: errorMessage
    }
  });
}

function createApplicationMenu() {
  const template = [
    {
      label: 'TG2D',
      submenu: [
        {
          label: 'Paramètres de connexion au serveur...',
          accelerator: 'CmdOrCtrl+,',
          click: () => {
            const config = loadConfig();
            showConnectScreen(config.serverUrl);
          }
        },
        {
          label: 'Rafraîchir la page',
          accelerator: 'CmdOrCtrl+R',
          click: () => {
            if (mainWindow) mainWindow.reload();
          }
        },
        { type: 'separator' },
        {
          label: 'Quitter',
          accelerator: process.platform === 'darwin' ? 'Cmd+Q' : 'Alt+F4',
          click: () => app.quit()
        }
      ]
    },
    {
      label: 'Édition',
      submenu: [
        { label: 'Annuler', role: 'undo' },
        { label: 'Rétablir', role: 'redo' },
        { type: 'separator' },
        { label: 'Couper', role: 'cut' },
        { label: 'Copier', role: 'copy' },
        { label: 'Coller', role: 'paste' },
        { label: 'Tout sélectionner', role: 'selectAll' }
      ]
    },
    {
      label: 'Affichage',
      submenu: [
        { label: 'Plein écran', role: 'togglefullscreen' },
        { label: 'Zoom +', role: 'zoomIn' },
        { label: 'Zoom -', role: 'zoomOut' },
        { label: 'Réinitialiser zoom', role: 'resetZoom' }
      ]
    }
  ];

  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

// IPC Handlers pour la page de connexion
ipcMain.handle('get-config', async () => {
  return loadConfig();
});

ipcMain.handle('save-and-connect', async (event, newUrl) => {
  const config = loadConfig();
  config.serverUrl = newUrl;
  saveConfig(config);
  attemptConnection(newUrl);
  return { success: true };
});

ipcMain.handle('test-connection', async (event, testUrl) => {
  let url = testUrl.trim();
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = 'http://' + url;
  }
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 4000);
    const response = await fetch(url, { signal: controller.signal });
    clearTimeout(timeoutId);
    return { ok: response.ok, status: response.status, url };
  } catch (err) {
    return { ok: false, error: err.message, url };
  }
});

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
