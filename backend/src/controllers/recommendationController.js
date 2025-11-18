import { NetworkLogRepo } from '../models/networkLog.js';

// Analyses de recommandations intelligentes 

// This function now returns an array of recommendations for all high-consumption services
async function analyzeHighConsumptionServices(networkId, logs) {
  if (logs.length === 0) return []; // Return an empty array if no logs

  const recommendations = [];
  const HIGH_CONSUMPTION_THRESHOLD = 1.5; // Set a threshold (e.g., 1.5 kWh)

  const consumptionByService = logs.reduce((acc, log) => {
    const serviceName = log.service?.name;
    if (!serviceName || !log.kwh) return acc;

    if (!acc[serviceName]) {
      acc[serviceName] = { kwh: 0, category: log.service.category || 'Inconnu' };
    }
    acc[serviceName].kwh += log.kwh;
    return acc;
  }, {});

  // --- DEBUG LOGGING ---
  console.log("--- Recommendation Analysis ---");
  console.log("Aggregated consumption by service:", consumptionByService);
  console.log(`High consumption threshold is: ${HIGH_CONSUMPTION_THRESHOLD}`);
  // --- END DEBUG LOGGING ---

  const serviceEntries = Object.entries(consumptionByService);
  if (serviceEntries.length === 0) return [];

  // Iterate over all services and generate a recommendation for each one that exceeds the threshold
  for (const [serviceName, serviceData] of serviceEntries) {
    const isHighConsumption = serviceData.kwh > HIGH_CONSUMPTION_THRESHOLD;
    
    // --- DEBUG LOGGING ---
    console.log(`Checking service: ${serviceName}, kWh: ${serviceData.kwh}, Is High? -> ${isHighConsumption}`);
    // --- END DEBUG LOGGING ---

    if (isHighConsumption) {
      recommendations.push({
        id: `rec-high-${serviceName.toLowerCase().replace(/\s/g, '-')}`,
        icon: 'chart', // Ou mapper une icône spécifique basée sur la catégorie
        title: `Réduisez l'utilisation de ${serviceName}`,
        category: serviceData.category,
        description: `${serviceName} est un de vos services les plus énergivores. Envisagez de réduire son utilisation.`,
        savings: `Jusqu'à 10% de réduction`
      });
    }
  }
  console.log("---------------------------\n");

  return recommendations;
}

async function analyzeNightUsage(networkId, logs, startHour, endHour) {
  const nightLogs = logs.filter(log => {
    const hour = new Date(log.ts).getHours(); 
    if(startHour < endHour) {
      return hour >= startHour && hour < endHour;
    } else {
      return hour >= startHour || hour < endHour;
    }
  });

  const totalNightKwh = nightLogs.reduce((sum, log) => sum + (log.kwh || 0), 0);

  if (totalNightKwh > 0.2) {
    return {
      id: 'rec-night-usage',
      icon: 'power',
      title: "Réduire l'utilisation nocturne", 
      category: 'Général',
      description: "Une consommation d'énergie élevée a été détectée pendant la nuit. Assurez-vous que les appareils inutilisés sont éteints.",
      savings: "Économisez ~0.1 kWh par jour"
    };
  }

  return null;
}

// --- Controller ---

/**
 * @param {import('express').Request} req
 * @param {import('express').Response} res
 */
export async function getRecommendations(req, res, next) {
  try {
    const { networkId, nightStartHour = 0, nightEndHour = 6 } = req.query;
    if (!networkId) {
      return res.status(400).json({ error: 'networkId est requis' });
    }

    const logs = await NetworkLogRepo.search({ network_id: networkId, limit: 1000 });

    const smartRecommendations = [];

    // Obtenir toutes les recommandations de forte consommation (c'est maintenant un tableau)
    const highConsumptionRecs = await analyzeHighConsumptionServices(networkId, logs);
    if (highConsumptionRecs.length > 0) {
      smartRecommendations.push(...highConsumptionRecs); // Utiliser l'opérateur spread pour ajouter tous les éléments
    }

    const nightUsageRec = await analyzeNightUsage(networkId, logs, parseInt(nightStartHour), parseInt(nightEndHour));
    if (nightUsageRec) {
      smartRecommendations.push(nightUsageRec);
    }

    const quickTips = [
      { id: 'tip1', text: "Fermez les onglets de navigateur inutilisés pour réduire le traitement en arrière-plan." },
      { id: 'tip2', text: "Utilisez le mode sombre pour économiser l'énergie de l'écran sur les écrans OLED." },
      { id: 'tip3', text: "Planifiez les téléchargements lourds pendant les heures creuses." }
    ];

    res.json({ smartRecommendations, quickTips });

  } catch (error) {
    next(error);
  }
}
