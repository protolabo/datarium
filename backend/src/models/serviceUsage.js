export class ServiceUsage {
  constructor({ ssid, service, hostId, bytes = 0, kwh = 0, co2 = 0, hosts = {} }) {
    this.ssid    = ssid;
    this.service = service;
    this.hostId  = hostId;
    this.bytes   = bytes;
    this.kwh     = kwh;
    this.co2     = co2;
    this.hosts   = hosts;
  }

  /** Incrémente la fenêtre courante */
  addWindow({ bytes, kwh, co2 }) {
    this.bytes += bytes;
    this.kwh   += kwh;
    this.co2   += co2;
    if (this.hostId) this.hosts[this.hostId] = true;
  }

  /** Format Firestore */
  toDoc() {
    return {
      bytes: this.bytes,
      kwh  : +this.kwh.toFixed(6),
      co2  : +this.co2.toFixed(2),
      hosts: this.hosts
    };
  }
}