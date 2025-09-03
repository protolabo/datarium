export function validateBatch(batch) {
    const errors = [];
    batch.forEach((it, i) => {
        if (!it.ssid) errors.push(`item[${i}] missing ssid`);
        if (!it.service) errors.push(`item[${i}] missing service`);
        if (typeof it.bytes !== 'number')
            errors.push(`item[${i}] bytes must be number`);
        if (typeof it.windowSec !== 'number')
            errors.push(`item[${i}] windowSec must be number`);
        if (!it.category)
            errors.push(`item[${i}] missing category`);
    });
    return { valid: errors.length === 0, errors };
}
