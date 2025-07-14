import 'dotenv/config';

export const {
  PORT = 8000,
  API_KEY_SNIFFER,
  KWH_FACTOR  = 0.000000055,  // kWh par octet
  CO2_FACTOR  = 400,          // g CO₂ par kWh
  FIREBASE_KEY_PATH, 
   /* paramètres pour le thermomètre live */
  THERMO_UNIT     = 'kwh',        // ou 'co2'
  THRESHOLDS_KWH  = '0.05,0.1,0.2',
  THRESHOLDS_CO2  = '20,40,80'
} = process.env;

if (!FIREBASE_KEY_PATH) throw new Error('FIREBASE_KEY_PATH manquant dans .env');
