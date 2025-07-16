export class ServiceUsage {
  constructor({ ssid, service, hostId, bytes = 0, kwh = 0, co2 = 0, hosts = {}, listenSec = 0,
             category  = '' ,  firstSeen = null}) {
    this.ssid    = ssid;
    this.service = service;
    this.hostId  = hostId;
    this.bytes   = bytes;
    this.kwh     = kwh;
    this.co2     = co2;
    this.hosts   = hosts;
    this.listenSec = listenSec; // Durée d'écoute en secondes
    this.category = category;  
     this.firstSeen = firstSeen; // Catégorie du service 
  }

  /** Incrémente la fenêtre courante */
  addWindow({ bytes, kwh, co2, windowSec = 0, category }) {
    this.bytes += bytes;
    this.kwh   += kwh;
    this.co2   += co2;
    this.listenSec += windowSec;
    this.category   = category || this.category;


    if (this.hostId) this.hosts[this.hostId] = true;
  }

  /** Format Firestore */
  toDoc() {
    return {
      bytes: this.bytes,
      kwh  : +this.kwh.toFixed(6),
      co2  : +this.co2.toFixed(2),
      hosts: this.hosts,
      listenSec: this.listenSec,
      category: this.category,
      firstSeen: this.firstSeen,
       lastSeen  : this.lastSeen
    };
  }
}