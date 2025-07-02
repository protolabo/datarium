export default db => async (_, res) => {
  const snap = await db.doc('alerts/today').get();
  res.json(snap.exists ? snap.data() : {});
};
