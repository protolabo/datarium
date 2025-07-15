
// Service chargé de convertir des octets (bytes) en impact
// énergétique (kWh) et environnemental (g CO₂), puis de
// déterminer le niveau de couleur du thermomètre.


import {
  KWH_FACTOR,
  CO2_FACTOR,
  THERMO_UNIT,
  THRESHOLDS_KWH,
  THRESHOLDS_CO2
} from '../config/env.js';

const parse = (s) => s.split(',').map(Number);
const thresholdsKwh = parse(THRESHOLDS_KWH);
const thresholdsCo2 = parse(THRESHOLDS_CO2); 
export class ImpactService {
  /** Convertit des octets -> { kwh, co2 } */
  bytesToImpact(bytes) {
    const kwh = +(bytes * KWH_FACTOR).toFixed(6);
    const co2 = +(kwh  * CO2_FACTOR).toFixed(2);
    return { kwh, co2 };
  }

  /** Retourne le niveau (0-3) selon la valeur et l’unité choisie */
  levelFor(value) {
    const th = THERMO_UNIT === 'kwh' ? thresholdsKwh : thresholdsCo2;
    if (value <= th[0]) return 0;   // vert
    if (value <= th[1]) return 1;   // jaune
    if (value <= th[2]) return 2;   // orange
    return 3;                       
  }
}
