import { Server } from 'socket.io';
let io;                                     // référence partagée

//Installe Socket.io sur le même serveur HTTP qu’Express.
// Autorise le CORS (origin:'*') pour que l'application Flutter ou l’ESP32 puissent se connecter depuis n’importe quelle adresse.
export function initSocket(httpServer){     // appelé une seule fois
  io = new Server(httpServer, {             // attache Socket.io au même
    cors:{ origin:'*' }                     // serveur HTTP qu’Express
  });
}

// Cette fonction envoie les mises à jour live du thermomètre.
export function pushThermo(data){           // appelé à chaque lot reçu
  io?.emit('thermo', data);                 // diffuse à tous les clients
}
