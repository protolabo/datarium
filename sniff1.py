from scapy.all import sniff, IP, TCP, UDP, get_if_addr, get_if_list
import socket
import re
import socket
from ipwhois import IPWhois
import ipaddress
import json


services ={
    "YouTube": 0,
    "Netflix": 0,
    "Spotify": 0,
    "TikTok": 0,
    "ChatGPT": 0,
    "Efootball": 0,
    "Unknown": 0
}

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
print("Ton ip est : "+ s.getsockname()[0])
my_ip = s.getsockname()[0]  # l'ip local
s.close()  
try:
    my_hostname = socket.gethostbyaddr(my_ip)[0]
    print("Ton hostname est : "+ my_hostname)
except socket.herror:
    my_hostname = 'Unknown'

# https://scapy.readthedocs.io/en/stable/api/scapy.interfaces.html
#https://scapy.readthedocs.io/en/latest/routing.html
interfaces = get_if_list()    
for iface in interfaces:
    try:
        interface_ip = get_if_addr(iface)
        if interface_ip == my_ip:
            print(f"Interface trouvée {my_ip} : {iface}")
            interface = iface
            break
    except Exception as e:
        print(f"Erreur durant la récupération de l'IP pour l'interface {iface}: {e}")



def get_hostname(ip):
    try:
        name = socket.gethostbyaddr(ip)[0] if ip != my_ip else my_hostname
    except socket.herror:
        name = "Unknown"
    if name != "Unknown":
        return name
    else:  
        try:
            if not ipaddress.ip_address(ip).is_private and ip != my_ip:
                who = IPWhois(ip).lookup_rdap()
                return who.get('asn_description', 'Unknown')
        except Exception as e:
            return "Unknown"    

def is_tiktok_domain(domain):
    tiktok_patterns = [
    r'(^|\.)muscdn\.com$',
    r'(^|\.)musical\.ly$',
    r'(^|\.)tiktok\.com$',
    r'(^|\.)tiktok\.org$',
    r'(^|\.)tiktokcdn\.com$',
    r'^a[\d-]+\.deploy\.static\.akamaitechnologies\.com$',
    r'^a\d+\.r\.akamai\.net$',
    r'^[\w\d-]+\.api2\.akamaiedge\.net$',
    ]
    if domain and domain != "Unknown":
        for pattern in tiktok_patterns:
            if re.match(pattern, domain):
                return True
        if domain.__contains__("TIKTOK") or domain.__contains__("BYTEDANCE"):
            return True    
    return False    
    
def is_chatgpt(domain):
    if domain and domain != "Unknown":
        if domain.__contains__("CHATGPT") or domain.__contains__("OPENAI") or domain.__contains__("CLOUDFLARE"):
            return True
    return False

#https://www.appsruntheworld.com/customers-database/customers/view/konami-digital-entertainment-uk-united-kingdom
def is_efootball_konami(domain):
    konami_patterns = [
    r'^([\w-]+\.)*cloudfront\.net$',
    r'^([\w-]+\.)*compute\.amazonaws\.com$',
    ]
    if domain and domain != "Unknown":
        for pattern in konami_patterns:
            if re.match(pattern, domain):
                return True
    #pratiquement sur que ca ne sera jamais exécuté car gethostbyaddr renvoie touours une response
    return False
                                                                            

def is_netflix(domain):
    netflix_patterns = [
    r'^([\w-]+\.)*nflxvideo\.net$',
    ]
    if domain and domain != "Unknown":
        for pattern in netflix_patterns:
            if re.match(pattern, domain):
                return True   
    return False   

def is_youtube(domain):
    youtube_patterns = [
    r'^r\d+\.sn-[\w-]+\.googlevideo\.com$',      
    r'^rr\d+\.sn-[\w-]+\.googlevideo\.com$',     
    r'^[\w-]+\.1e100\.net$',                     
    r'^i\.ytimg\.com$',                          
    r'^yt[3-5]\.ggpht\.com$',                    
    r'^m?\.?youtube(-nocookie)?\.com$',          
    r'^youtubei\.googleapis\.com$',              
    ]
    if domain and domain != "Unknown":
        for pattern in youtube_patterns:
            if re.match(pattern, domain):
                return True
    return False

def is_spotify(domain):
    spotify_patterns = [r'^([\w-]+\.)*spotifycdn\.map\.fastly\.net$',
    r'^([\w-]+\.)*scdn\.co$',
    r'^([\w-]+\.)*spotify\.com$',
    r'^([\w-]+\.)*spclient\.wg\.spotify\.com$']
    if domain and domain != "Unknown":
        for pattern in spotify_patterns:
            if re.match(pattern, domain):
                return True
        if domain.__contains__("FASTLY") or domain.__contains__("SPOTIFY"):
            return True      
    return False

proto_names = {
    6: "TCP",
    17: "UDP",
    
}

def paquet(packet):
    if IP in packet:
        proto = proto_names.get(packet[IP].proto)
        src, dst = packet[IP].src, packet[IP].dst
        sport = packet.sport if TCP in packet or UDP in packet else None
        dport = packet.dport if TCP in packet or UDP in packet else None
        print(f"---------------------------------------------------------------")
        print(f"src Ip:{src}, src port:{sport} --> dst Ip:{dst}, dst port:{dport}")
        names= get_hostname(src)  ## ici j'utilise les sockets au lieu de get_whois car j'ai juste 50k/mois je limite les appels
        named= get_hostname(dst)  ## mm chose
        if names != my_hostname and names != "Unknown":
            domain_p = names
        else:
            if named != my_hostname and named != "Unknown":
                domain_p = named
            else:
                domain_p = "Unknown"    
        size = len(packet)
        if is_tiktok_domain(domain_p):
            print(f"[TikTok] {names} <--> {named}")
            services["TikTok"] += size
        elif is_spotify(domain_p):
            print(f"[Spotify] {names} <--> {named}") 
            services["Spotify"] += size  
        elif is_chatgpt(domain_p):
            print(f"[ChatGPT] {names} <--> {named}")  
            services["ChatGPT"] += size   
        elif is_youtube(domain_p):
            print(f"[YouTube] {names} <--> {named}")
            services["YouTube"] += size
        elif is_netflix(domain_p):
            print(f"[Netflix] {names} <--> {named}")
            services["Netflix"] += size
        elif is_efootball_konami(domain_p):
            print(f"[Efootball] {names} <--> {named}")
            services["Efootball"] += size    
        else:
            print(f"Unknown {names} <--> {named}")
            services["Unknown"] += size
        print(f"Protocol: {proto}")
        print(f"Packet Length: {len(packet)} bytes")
        save_services_files()  ## je mets a jour le fichier services.json chque fois qu'un paquet est capturé
      


def save_services_files():
    with open("services.json", "w") as f:
        json.dump(services, f, indent=4)
    print("le service a été sauvegardé dans le fichier services.json")

sniff(iface=interface, filter="(host "+my_ip+")", prn=paquet, store=False)
# iface est l'interface de capture, vous pouvez la changer selon votre réseau 