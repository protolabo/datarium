import * as SSID from '../models/ssid.js';

export async function list(req,res,next){
  try { res.json(await SSID.listAll()); }
  catch(e){ next(e); }
}

export async function listServices(req,res,next){
  try {
    const unit = req.query.unit === 'kwh' ? 'kwh' : 'co2';
    res.json(await SSID.listServices(req.params.ssid, unit));
  } catch(e){ next(e); }
}