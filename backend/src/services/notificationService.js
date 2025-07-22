import { pushThermo } from '../utils/socket.js';

export class NotificationService {
  /**
   * Envoie la mise à jour du thermomètre à tous les
   * clients WebSocket connectés.
   * @param {Object} payload { ts, unit, value, level }
   */
  pushThermo(payload) {
    pushThermo(payload);
  }
}