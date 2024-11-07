#script en Python que muestre el código HTML de la página http://hackingyseguridad.com y busca las palabras user y passwd
import requests
import re
url = 'http://hackingyseguridad.com'
response = requests.get(url)
web_content = response.text
# Busca las palabras 'user' y 'passwd' en el contenido HTML
user_matches = re.findall(r'\buser\b', web_content, re.IGNORECASE)
passwd_matches = re.findall(r'\bpasswd\b', web_content, re.IGNORECASE)
