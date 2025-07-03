from scapy.all import sniff, IP, TCP, UDP
import socket
import re
import requests
import json

clé_Api_ipInfo = "10b7032ed7d483"   ## c'est le token de mon compte ipinfo.io, une fois le nbr d'appels les requetes vont echouer, faudra vous creer un compte et mettre votre token ici

services ={
    "YouTube": 0,
    "Netflix": 0,
    "Spotify": 0,
    "TikTok": 0,
    "ChatGPT": 0,
    "Unknown": 0
}



def get_whois_online(ip):
    try:
        r = requests.get(f"https://ipinfo.io/{ip}/json?token={clé_Api_ipInfo}", timeout=2)
        data = r.json()
        org = data.get("org", "Unknown org")
        hostname = data.get("hostname", "No hostname")
        return {"hostname" : hostname , "org":org}
    except Exception as e:
        return {"erreur" : str(e), "hostname": "No hostname", "org": "Unknown org"}

def get_hostname(ip):
    try:
        hostname = socket.gethostbyaddr(ip)
        return {"hostname": hostname[0], "org": "Unknown org"}
    except Exception as e:
        return get_whois_online(ip)  ## en cas d'erreur de résolution de nom avec socket j'essaye avec l'API ipinfo

def is_tiktok_domain(ip):
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
    reponse = get_whois_online(ip)
    if reponse and reponse.get("hostname") != "No hostname":
        hostname = reponse["hostname"]
        for pattern in tiktok_patterns:
            if re.match(pattern, hostname):
                return True
    elif reponse and reponse.get("org"):
        if (reponse['org'].lower() == "AS396986 Bytedance Inc.".lower()) or (reponse['org'].split()[0].lower()== "AS396986".lower()):
            return True
    else:
        return False    

def is_spotify(ip):
    spotify_patterns = [r'^([\w-]+\.)*spotifycdn\.map\.fastly\.net$',
    r'^([\w-]+\.)*scdn\.co$',
    r'^([\w-]+\.)*spotify\.com$',
    r'^([\w-]+\.)*spclient\.wg\.spotify\.com$']
    reponse = get_whois_online(ip)
    if reponse and reponse.get("hostname") != "No hostname":
        hostname = reponse["hostname"]
        for pattern in spotify_patterns:
            if re.match(pattern, hostname):
                return True
    elif reponse and reponse.get("org"):
        return (reponse['org'].lower() == "AS54113 Fastly, Inc.".lower()) or (reponse['org'].split()[0].lower()== "AS54113".lower())
    else:
        return False
       
def is_chatgpt(ip):
    reponse = get_whois_online(ip)
    if reponse and reponse.get("org"):
        org_low = reponse['org'].split()[0].lower()
        return org_low in ["as13335", "as8075"]
    return False

def is_youtube(ip):
    youtube_patterns = [
    r'^r\d+\.sn-[\w-]+\.googlevideo\.com$',      
    r'^rr\d+\.sn-[\w-]+\.googlevideo\.com$',     
    r'^[\w-]+\.1e100\.net$',                     
    r'^i\.ytimg\.com$',                          
    r'^yt[3-5]\.ggpht\.com$',                    
    r'^m?\.?youtube(-nocookie)?\.com$',          
    r'^youtubei\.googleapis\.com$',              
    ]
    reponse = get_whois_online(ip)
    if reponse and reponse.get("hostname") != "No hostname":
        hostname = reponse["hostname"]
        for pattern in youtube_patterns:
            if re.match(pattern, hostname):
                return True
    return False

def is_netflix(ip):
    netflix_patterns = [
    r'^([\w-]+\.)*nflxvideo\.net$',
    ]
    reponse = get_whois_online(ip)
    if reponse and reponse.get("hostname") != "No hostname":
        hostname = reponse["hostname"]
        for pattern in netflix_patterns:
            if re.match(pattern, hostname):
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
        size = len(packet)
        if is_tiktok_domain(src) or is_tiktok_domain(dst):
            print(f"[TikTok] {names} <--> {named}")
            services["TikTok"] += size
        elif is_spotify(src) or is_spotify(dst):
            print(f"[Spotify] {names} <--> {named}") 
            services["Spotify"] += size  
        elif is_chatgpt(src) or is_chatgpt(dst):
            print(f"[ChatGPT] {names} <--> {named}")  
            services["ChatGPT"] += size   
        elif is_youtube(src) or is_youtube(dst):
            print(f"[YouTube] {names} <--> {named}")
            services["YouTube"] += size
        elif is_netflix(src) or is_netflix(dst):
            print(f"[Netflix] {names} <--> {named}")
            services["Netflix"] += size
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

sniff(iface=r'\Device\NPF_{4AFAC528-8B21-412C-B7B8-CD188D08F2DE}', filter="(host 192.168.2.62)", prn=paquet, store=False)
# iface est l'interface de capture, vous pouvez la changer selon votre réseau 