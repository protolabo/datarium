import express from 'express';

export default db => {
  const r = express.Router();

  // Dernière mesure
  r.get('/current', async (_, res) => {
    const snap = await db.doc('metrics/current').get();
    res.json(snap.exists ? snap.data() : {});
  });

  // Historique (par défaut : 24 h)
  r.get('/history', async (req, res) => {
    const hours = +(req.query.hours || 24);
    const since = Date.now() - hours * 3600_000;
    const qs = await db.collection('metrics')
                       .where('ts', '>=', since)
                       .orderBy('ts')
                       .get();
    res.json(qs.docs.map(d => d.data()));
  });

  return r;
};
