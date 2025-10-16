import https from 'https';
import fs from 'fs';
import path from 'path';
import app from './app.js';


//chemin vers les certificats générés
const __dirname = path.resolve();
const keyPath = path.join(__dirname, 'certs', 'server.key');
const certPath = path.join(__dirname, 'certs', 'server.crt');

console.log('chemin clé:', keyPath);

if (!fs.existsSync(keyPath) || !fs.existsSync(certPath)) {
    console.error('Certificats manquants dans backend/certs/');
    process.exit(1);
}

const options = {
    key: fs.readFileSync(keyPath),
    cert: fs.readFileSync(certPath),
};

const PORT = 8443;

const httpsServer = https.createServer(options,app);

httpsServer.listen(PORT, () => {
    console.log('Serveur https démarré sur le port', PORT);
});