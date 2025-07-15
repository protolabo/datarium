import { SSIDReadRepository } from '../models/ssidRead.js';
const repo = new SSIDReadRepository();

export async function listSsids(req, res, next) {
  try   { res.json(await repo.listAll()); }
  catch (e){ next(e); }
}

export async function listServices(req, res, next) {
  try {
    const unit = req.query.unit === 'kwh' ? 'kwh' : 'co2';
    res.json(await repo.listServices(req.params.ssid, unit));
  } catch (e) { next(e); }
}
