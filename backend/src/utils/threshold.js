export const thresholds = process.env.THRESHOLDS
  .split(',')
  .map(Number)         // -> [50, 100, 200]
  .sort((a, b) => a - b);
