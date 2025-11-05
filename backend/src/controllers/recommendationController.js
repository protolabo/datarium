import { NetworkLogRepo } from '../models/networkLog.js';


// Analyses de recommandations intelligentes 

async function analyzeHighConsumptionService(networkId, logs) {
  if (logs.length === 0) return null;

  const consumptionByService = logs.reduce((acc, log) => {
    if (!acc[log.serviceName]) {
      acc[log.serviceName] = 0;
    }
    acc[log.serviceName] += log.kwh;
    return acc;
  }, {});

  // sort(a,b) si résultat > 0, b avant a; si < 0 a avant b
  const [topService, topConsumption] = Object.entries(consumptionByService).sort((a, b) => b[1] - a[1])[0];

  if (topConsumption > 0.1) {
    return {
      id: 'rec-high-consumption',
      icon: 'chart',
      title: `Réduisez l'utilisation de ${topService}`,
      category: logs.find(log => log.serviceName === topService)?.category || 'Unkmown',
      description: `${topService} est votre service le plus énergivore. Envisagez de réduire son utilisation ou sa qualité.`,
      savings: `Jusqu'à 10% de réduction`
    };
  }

  return null;
}

async function analyzeNightUsage(networkId, logs) {
  const nightLogs = logs.filter(log => {
    const hour = new Date(log.timestamp).getHours();
    return hour >= 0 && hour < 6; // 00:00 - 05:59
  });

  const totalNightKwh = nightLogs.reduce((sum, log) => sum + log.kwh, 0);

  if (totalNightKwh > 0.2) {
    return {
      id: 'rec-night-usage',
      icon: 'power',
      title: "Réduire l'utilisation nocturne'",
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
    const { networkId } = req.query;
    if (!networkId) {
      return res.status(400).json({ error: 'networkId is required' });
    }

    const logs = await NetworkLogRepo.search({ networkId, limit: 1000 });

    const smartRecommendations = [];

    const highConsumptionRec = await analyzeHighConsumptionService(networkId, logs);
    if (highConsumptionRec) smartRecommendations.push(highConsumptionRec);

    const nightUsageRec = await analyzeNightUsage(networkId, logs);
    if (nightUsageRec) smartRecommendations.push(nightUsageRec);

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
