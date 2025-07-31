import requests
from scapy.all import sniff, IP, TCP, UDP, get_if_addr, get_if_list, AsyncSniffer
import socket
from ipwhois import IPWhois
import ipaddress
import time
import threading
import queue
from domain import is_tiktok_domain, is_chatgpt, is_efootball_konami, is_netflix, is_youtube, is_spotify
from network import get_wifi_name, get_my_ip, get_my_hostname, get_interface

# dictionnaire pour stocker les tailles des services puis agrégées toutes les 4 secondes
aggregate_servvice = {
    "Tiktok": 0,
    "Spotify": 0,
    "ChatGPT": 0,
    "Youtube": 0,
    "Netflix": 0,
    "Efootball": 0,
    "Unknown": 0
}

host_ID_dic = {
    "hostID": ""
}

name_wifi = get_wifi_name()
my_ip = get_my_ip() # l'ip local
my_hostname = get_my_hostname(my_ip) # le hostname local 
interface = get_interface(my_ip) # l'interface de capture

dns_cahe= {}
dns_queue = queue.Queue()

stop_thread = False
def dns_search():
    while True:
        global stop_thread
        if stop_thread:
            break
        ip= dns_queue.get()
        if ip not in dns_cahe or dns_cahe[ip]== "Unknown":
            dns_cahe[ip] = get_hostname(ip)
        dns_queue.task_done() 

#thread qui va effectuer la recherche DNS pour eviter de perdre des paquets durant la capture
dsnThread = threading.Thread(target=dns_search, daemon=True)
dsnThread.start()

def get_hostname(ip):
    try:
        name = socket.gethostbyaddr(ip)[0] 
    except socket.herror:
        name = "Unknown"
    if name != "Unknown":
        return name
    else:  
        try:
            if not ipaddress.ip_address(ip).is_private:
                who = IPWhois(ip).lookup_rdap()
                return who.get('asn_description', 'Unknown')
        except Exception as e:
            return "Unknown"    


def paquet(packet):
    if IP in packet:
        src, dst = packet[IP].src, packet[IP].dst

        if src not in dns_cahe:
            dns_cahe[src] = "Unknown"
            dns_queue.put(src)    
        if dst not in dns_cahe:
            dns_cahe[dst] = "Unknown"
            dns_queue.put(dst)    
            
        name_source= dns_cahe[src]
        name_destination = dns_cahe[dst]

        if ipaddress.ip_address(src).is_private and name_source != "Unknown":
            host_ID_dic["hostID"] = name_source
        elif ipaddress.ip_address(dst).is_private and name_destination != "Unknown":
            host_ID_dic["hostID"] = name_destination
        else:
            host_ID_dic["hostID"] = "Unknown"
        

        if not ipaddress.ip_address(src).is_private and name_source != "Unknown":
            domain_name = name_source
        else:
            if not ipaddress.ip_address(dst).is_private and name_destination != "Unknown":
                domain_name = name_destination
            else:
                domain_name = "Unknown"   

        size = len(packet)

        if is_tiktok_domain(domain_name):
            aggregate_servvice["Tiktok"] += size 
        elif is_spotify(domain_name): 
            aggregate_servvice["Spotify"] += size
        elif is_chatgpt(domain_name): 
            aggregate_servvice["ChatGPT"] += size
        elif is_youtube(domain_name):
            aggregate_servvice["Youtube"] += size
        elif is_netflix(domain_name):
            aggregate_servvice["Netflix"] += size
        elif is_efootball_konami(domain_name):
            aggregate_servvice["Efootball"] += size  
        else:
            aggregate_servvice["Unknown"] += size
            
def send_services_to_backend(service, size, time, hostID):
    
    if hostID == None or hostID == "Unknown":
        hostID = "non connue"
    try:
        categories = {
            "Tiktok": "video",
            "Spotify": "music",
            "ChatGPT": "ai",
            "Youtube": "video",
            "Netflix": "video",
            "Efootball": "game",
            "Unknown": "unknown"
        }

        data = {
            "ssid":name_wifi,
            "hostId": hostID,
            "service": service,
            "category":categories.get(service, "unknown"),
            "bytes":size,
            "windowSec":time 
        }

        headers = {'X-API-Key' : 'ChangeMe', 'Content-type': 'application/json'}
        response = requests.post(
            "http://localhost:8000/records",
            headers=headers,
            json=data
        )

    except Exception as e:
        print(f"Erreur durant l'evoi au backend: {e}")

sniffer = AsyncSniffer(iface=interface, filter="(tcp or udp)", prn=paquet, promisc=True, store=False)# iface est l'interface de capture, vous pouvez la changer selon votre réseau 

sniffer.start()
while True:
    try:
        for service, size in aggregate_servvice.items():
            if size > 1500:       # je mets ce seuil pour ne pas envoyer des données inutiles
                send_services_to_backend(service, size, 4, host_ID_dic["hostID"])

        for service in aggregate_servvice:       # on remet a 0 les valeurs pour le prochain envoi
            aggregate_servvice[service] = 0

        time.sleep(4) # envoyer les données a l'esp32 toutes les 4 secondes
        
    except KeyboardInterrupt:
        sniffer.stop()
        print("fin de la capture.")
        stop_thread = True
        dsnThread.join()
        break