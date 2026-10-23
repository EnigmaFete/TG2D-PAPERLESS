const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('tg2dAPI', {
  getConfig: () => ipcRenderer.invoke('get-config'),
  saveAndConnect: (url) => ipcRenderer.invoke('save-and-connect', url),
  testConnection: (url) => ipcRenderer.invoke('test-connection', url)
});
