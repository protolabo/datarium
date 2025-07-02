import { Server } from 'socket.io';

export function initSocket(httpServer, db) {
  const io = new Server(httpServer, { cors: { origin: '*' } });

  db.doc('metrics/current').onSnapshot(snap => {
    if (snap.exists) io.emit('metric', snap.data());
  });
  db.doc('alerts/today').onSnapshot(snap => {
    if (snap.exists) io.emit('alert', snap.data());
  });

  console.log('Socket.io prêt');
}
