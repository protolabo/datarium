
// Lecture des agrégats réseau (collection networks)

import { NetworkRepo } from '../models/networksRepo.js';

const repo = new NetworkRepo();

/* GET /networks */
export async function list (req, res, next) {
   try { res.json(await repo.listAll()); }
  catch (e) { next(e); }
}

/* GET /networks/:id */
export async function get (req, res, next) {
  try {
    const net = await repo.getById(req.params.id);
    if (!net) return res.status(404).json({ error: 'Network not found' });
    res.json(net);
  } catch (e) { next(e); }
}
