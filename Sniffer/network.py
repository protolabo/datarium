import subprocess
import socket
from scapy.all import get_if_list, get_if_addr



# nom du wifi
# https://stackoverflow.com/questions/33227160/how-do-i-get-python-to-know-what-wifi-the-user-is-connected-to
# afficher les informations sur le Wi-Fi
def get_wifi_name():
    wifi = subprocess.check_output(['netsh', 'WLAN', 'show', 'interfaces'])
    data = wifi.decode('utf-8', errors='ignore')
    data = data.split('\n')
    name_wifi = data[9].split(':')[1].strip()
    return name_wifi

# https://stackoverflow.com/questions/166506/finding-local-ip-addresses-using-pythons-stdlib
def get_my_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    print("Ton ip est : "+ s.getsockname()[0])
    my_ip = s.getsockname()[0]  # l'ip local
    s.close()  
    return my_ip

def get_my_hostname(my_ip):
    try:
        my_hostname = socket.gethostbyaddr(my_ip)[0]
    except socket.herror:
        my_hostname = 'Unknown'
    return my_hostname

# https://scapy.readthedocs.io/en/stable/api/scapy.interfaces.html
#https://scapy.readthedocs.io/en/latest/routing.html
def get_interface(my_ip):
    interfaces = get_if_list()    
    for iface in interfaces:
        try:
            interface_ip = get_if_addr(iface)
            if interface_ip == my_ip:
                print(f"Interface trouvée {my_ip} : {iface}")
                interface = iface
                return interface
        except Exception as e:
            print(f"Erreur durant la récupération de l'IP pour l'interface {iface}: {e}")