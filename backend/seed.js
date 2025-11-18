// The seed script now creates its own high-privilege Supabase client
// instead of using the shared, low-privilege one from the main app.
import { createClient } from '@supabase/supabase-js';
import dotenv from 'dotenv';
dotenv.config(); // Load .env file

// 1. Initialize a dedicated, high-privilege Supabase client for seeding
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_KEY; // <-- Use the SERVICE key

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("SUPABASE_URL et SUPABASE_SERVICE_KEY doivent être définis dans votre fichier .env.");
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

async function seed() {
  console.log('Démarrage du seeding Supabase pour les services et les journaux réseau...');

  const NETWORK_IDS = {
    HOME_WIFI: '11111111-1111-1111-1111-111111111111',
    BELL:  '22222222-2222-2222-2222-222222222222',
  };
  const hostId = 'mock_host_id_123';
  const KWH_FACTOR = 0.4; // Approximate CO2 factor from Flutter app

  // Définir des UUIDs statiques pour chaque service pour la cohérence.
  const SERVICE_IDS = {
    STREAMING: '00000000-0000-0000-0000-000000000001',
    GAMING: '00000000-0000-0000-0000-000000000002',
    AI_LLM: '00000000-0000-0000-0000-000000000003',
    UNKNOWN: '00000000-0000-0000-0000-000000000004',
  };

  const servicesData = [
    { id: SERVICE_IDS.STREAMING, name: 'Streaming', category: 'Streaming' },
    { id: SERVICE_IDS.GAMING, name: 'Gaming', category: 'Gaming' },
    { id: SERVICE_IDS.AI_LLM, name: 'AI/LLM', category: 'AI/LLM' },
    { id: SERVICE_IDS.UNKNOWN, name: 'Unknown', category: 'Unknown' },
  ];
  
  const networksData = [
    { id: NETWORK_IDS.HOME_WIFI, name: 'Home WiFi Network' },
    { id: NETWORK_IDS.BELL, name: 'Bell Network' },
  ];

  const NETWORK_TABLE = 'network';
  const SERVICE_TABLE = 'service';
  const NETWORK_LOG_TABLE = 'network_log';

  try {
    // --- 1. Nettoyage et insertion des réseaux ---
    console.log(`Nettoyage des anciens réseaux de ${NETWORK_TABLE}...`);
    await supabase.from(NETWORK_TABLE).delete().in('id', Object.values(NETWORK_IDS));
    console.log(`Insertion de ${networksData.length} réseaux dans ${NETWORK_TABLE}...`);
    const { error: networkError } = await supabase.from(NETWORK_TABLE).insert(networksData);
    if (networkError) throw networkError;
    console.log('Réseaux insérés avec succès.');

    // --- 2. Nettoyage et insertion des services ---
    console.log(`Nettoyage des anciens services de ${SERVICE_TABLE}...`);
    await supabase.from(SERVICE_TABLE).delete().in('id', Object.values(SERVICE_IDS));
    console.log(`Insertion de ${servicesData.length} services dans ${SERVICE_TABLE}...`);
    const { error: serviceError } = await supabase.from(SERVICE_TABLE).insert(servicesData);
    if (serviceError) throw serviceError;
    console.log('Services insérés avec succès.');

    // --- 3. Remplir la table des journaux réseau ---
    const networkLogsData = [];

    // fonction utilitaire pour créer une entrée de journal
    const createLog = (netId, serviceId, kwhValue, windowSec = 3600) => {
        const bytes = kwhValue * 10000000; // transformer kWh en bytes pour la simulation
        const co2 = kwhValue * KWH_FACTOR;
        return {
            bytes: bytes,
            window_sec: windowSec,
            kwh: kwhValue,
            network_id: netId,
            service_id: serviceId,
            ts: new Date().toISOString(),
            host_id: hostId,
            co2: co2,
            protocol: ['TCP', 'UDP', 'HTTP', 'HTTPS'][Math.floor(Math.random() * 4)],
            meta: {},
            requests: Math.floor(Math.random() * 10) + 1,
            created_at: new Date().toISOString()
        };
    };

    // Data pour HOME_WIFI consommation variée
    // Streaming:
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.STREAMING, 0.15));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.STREAMING, 0.6));
    
    // Gaming: Low, Medium, High
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.GAMING, 0.3));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.GAMING, 1.1));
    /* networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.GAMING, 2.8)); */
    // AI/LLM: Low, Medium, High
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.AI_LLM, 0.5));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.AI_LLM, 2.0));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.AI_LLM, 4.5));
    // Unknown: Low, Medium, High
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.UNKNOWN, 0.1));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.UNKNOWN, 0.4));
    networkLogsData.push(createLog(NETWORK_IDS.HOME_WIFI, SERVICE_IDS.UNKNOWN, 0.2));

    // Donnée pour BELL 
    // Streaming: Medium, High
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.STREAMING, 0.3));
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.STREAMING, 0.1));
    // Gaming: Low, High
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.GAMING, 0.2));
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.GAMING, 1.6));
    // AI/LLM: Medium
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.AI_LLM, 0.6));
    // Unknown: Low
    networkLogsData.push(createLog(NETWORK_IDS.BELL, SERVICE_IDS.UNKNOWN, 0.25));

    console.log(`Nettoyage des anciens journaux de ${NETWORK_LOG_TABLE} pour networkId: ${NETWORK_IDS.HOME_WIFI} et ${NETWORK_IDS.BELL}...`);
    await supabase.from(NETWORK_LOG_TABLE).delete().in('network_id', Object.values(NETWORK_IDS));

    console.log(`Insertion de ${networkLogsData.length} nouveaux journaux réseau dans ${NETWORK_LOG_TABLE}...`);
    const { error: logsError } = await supabase.from(NETWORK_LOG_TABLE).insert(networkLogsData);
    if (logsError) throw logsError;
    console.log('Journaux réseau insérés avec succès.');

    console.log('Seeding Supabase terminé avec succès !');

  } catch (error) {
    console.error('Erreur lors du seeding Supabase :', error.message);
  } finally {
    process.exit();
  }
}

seed();
