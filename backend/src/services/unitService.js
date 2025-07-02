/** Conversion octets ➜ gCO₂ */
export const bytesToCo2 = bytes =>
  +(bytes / 1_000_000 * +process.env.CO2_FACTOR).toFixed(2);

/** Met à jour le total quotidien + les niveaux d'alerte */
export async function updateTotals(db, co2, ts) {
  const day = new Date(ts).toISOString().slice(0, 10); // YYYY-MM-DD
  const dailyRef = db.doc(`daily/${day}`);

  await db.runTransaction(async t => {
    const snap  = await t.get(dailyRef);
    const total = (snap.exists ? snap.data().total_co2_g : 0) + co2;
    t.set(dailyRef, { total_co2_g: total }, { merge: true });

    // Gestion des paliers
    const limits = process.env.THRESHOLDS.split(',').map(Number);
    const level  = limits.filter(l => total >= l).length;
    t.set(db.doc('alerts/today'), { ts, level, total_co2_g: total });
  });
}
