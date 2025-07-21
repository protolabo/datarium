
import { NetworkLogRepo } from '../models/networkLog.js';

export async function search (req, res, next) {
  try {
    const { networkId, serviceName, from, to, limit } = req.query;

    
    const logs = await NetworkLogRepo.search({
      networkId,
      serviceName,
      fromTs : from ? +from : undefined,
      toTs   : to   ? +to   : undefined,
      limit  : limit ? +limit : undefined
    });

    res.json(logs);
  } catch (e) { next(e); }
}