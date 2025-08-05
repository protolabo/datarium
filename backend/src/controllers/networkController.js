
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

/* GET /networkStatsEsp32 */
export async function getEsp32Stats (req, res, next) {
try {
    const stat_General = await repo.listAll();
    if (!stat_General) return res.status(404).json({ error: 'No networks found' });
    let TotalBytes = 0;
    let TotalListenSec = 0;
    for (const network of stat_General){
      TotalBytes += network.bytes || 0;
      TotalListenSec += network.listenSec || 0;
    }
    res.json({
      bytes: TotalBytes,
      listenSec: TotalListenSec
    });
  } catch (e) { next(e); }
}
