import re

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
