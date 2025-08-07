const { app, BrowserWindow } = require('electron');
const path = require('path');
const { exec } = require('child_process');
const http = require('http');

function waitForFlask(url, onReady) {
  const tryPing = () => {
    const req = http.get(url, res => {
      if (res.statusCode === 200) {
        console.log('✅ Flask is up');
        onReady();
      } else {
        console.log('… Flask returned', res.statusCode, 'retrying…');
        setTimeout(tryPing, 1000);
      }
      res.resume();
    });
    req.on('error', () => {
      process.stdout.write('… waiting for Flask …\r');
      setTimeout(tryPing, 1000);
    });
  };
  tryPing();
}

function createWindow() {
  // Start Flask (relative to electron/ folder)
  const server = exec('python ../app.py', (error, stdout, stderr) => {
    if (error) console.error('Flask error:', error.message);
    if (stderr) console.error('Flask stderr:', stderr);
    if (stdout) console.log('Flask stdout:', stdout);
  });

  const win = new BrowserWindow({
    width: 1000,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
    }
  });

  waitForFlask('http://127.0.0.1:5000/ping', () => {
    win.loadURL('http://127.0.0.1:5000');
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') app.quit();
});
