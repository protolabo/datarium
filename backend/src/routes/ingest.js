import { bytesToCo2, updateTotals } from '../services/unitService.js';

export default db => async (req, res) => {
  const { bytes = 0, hostId = 'unknown' } = req.body;

  if (req.headers['x-api-key'] !== process.env.API_KEY_SNIFFER) {
    return res.status(401).json({ error: 'Bad API key' });
  }
  if (typeof bytes !== 'number' || bytes < 0) {
    return res.status(400).json({ error: 'bytes must be a positive number' });
  }

  const co2 = bytesToCo2(bytes);
  const ts  = Date.now();

  await db.doc('metrics/current').set({ ts, bytes, co2_g: co2, hostId });
  await db.collection('metrics').add({ ts, bytes, co2_g: co2, hostId });
  await updateTotals(db, co2, ts);

  res.sendStatus(204);                 // Pas de corps : tout va bien
};
