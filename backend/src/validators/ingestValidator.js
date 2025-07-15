export function validateBatch(batch) {
  const errors = [];
  batch.forEach((it, i) => {
    if (!it.ssid)      errors.push(`item[${i}] missing ssid`);
    if (!it.service)   errors.push(`item[${i}] missing service`);
    if (typeof it.bytes !== 'number')
                       errors.push(`item[${i}] bytes must be number`);
  });
  return { valid: errors.length === 0, errors };
}
