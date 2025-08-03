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
<<<<<<< HEAD
=======

  static async ajoutService({ id, name, category, description = '' }) {
  const ref  = db.doc(`services/${id}`);
  await db.runTransaction(async t => {
    const snap = await t.get(ref);
    if (!snap.exists) {
      t.set(ref, { name, category, description, firstSeen: Date.now() });
    } else if (category && !snap.data().category) {
      // on complète la catégorie si elle manquait
      t.update(ref, { category });
    }
  });
}
>>>>>>> 4e2b3bd227bd40134ada8dc0ef766d52f84050d0
}