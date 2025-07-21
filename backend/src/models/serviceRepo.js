import { db } from '../config/firebase.js';

export class ServiceRepo {
  static async create({ id, name, category, description }) {
    await db.doc(`services/${id}`).set({ name, category, description });
    return { id, name, category, description };
  }

  static async listAll() {
    const snap = await db.collection('services').get();
    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
  }

  static async getById(id) {
    const snap = await db.doc(`services/${id}`).get();
    return snap.exists ? { id: snap.id, ...snap.data() } : null;
  }

  static async update(id, data) {
    await db.doc(`services/${id}`).update(data);
  }

  static async remove(id) {
    await db.doc(`services/${id}`).delete();
  }
}