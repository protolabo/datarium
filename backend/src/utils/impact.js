import { KWH_FACTOR, CO2_FACTOR } from '../config/env.js';

export const bytesToImpact = bytes => {
    const kwh = +(bytes * KWH_FACTOR).toFixed(6);
    const co2 = +(kwh * CO2_FACTOR).toFixed(2);
    return { kwh, co2 };
};
