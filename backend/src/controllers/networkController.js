// Lecture des agrégats réseau (collection networks)

import { NetworkRepo } from '../models/networksRepo.js';

// on appelle directement les méthodes dans notre classe
// const repo = new NetworkRepo();

/* GET /networks */
export async function list(req, res, next) {
    try { 
        res.json(await NetworkRepo.listAll()); 
    }
    catch (e) { next(e); }
}

/* GET /networks/:id */
export async function get(req, res, next) {
    try {
        const net = await NetworkRepo.getById(req.params.id);
        if (!net) return res.status(404).json({ error: 'Network not found' });
        res.json(net);
    } catch (e) { next(e); }
}

/* GET /networkStatsEsp32 */
export async function getEsp32Stats(req, res, next) {
    try {
        const stat_General = await NetworkRepo.listAll();

        let NetworkOfUser;

        if (!stat_General) return res.status(404).json({ error: 'No networks found' });

        for (const network of stat_General) {
            if (network && (network.id).trim().toLowerCase() === req.params.id.trim().toLowerCase()) {
                NetworkOfUser = network;
            }
        }

        if (!NetworkOfUser) return res.status(404).json({ error: 'No network found' });

        res.json({
            bytes: NetworkOfUser.bytes || 0,
            listenSec: NetworkOfUser.listenSec || 0
        });

    } catch (e) {
        console.error("Erreur dans getEsp32Stats:", e);
        res.status(500).json({ error: "Server error", details: e.message });
    }
}