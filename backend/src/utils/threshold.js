import { THERMO_UNIT, THRESHOLDS_KWH, THRESHOLDS_CO2 } from '../config/env.js';


const parse = str => str.split(',').map(Number);

const tKwh = parse(THRESHOLDS_KWH);
const tCO2 = parse(THRESHOLDS_CO2);

export function levelFor({ kwh, co2 }) {
  const val  = THERMO_UNIT === 'kwh' ? kwh : co2;
  const th   = THERMO_UNIT === 'kwh' ? tKwh : tCO2;
  if (val <= th[0]) return 0;           // vert
  if (val <= th[1]) return 1;           // jaune
  if (val <= th[2]) return 2;           // orange
  return 3;                             // rouge / pourpre
}
