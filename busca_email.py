import requests
import re

url = 'http://hackingyseguridad.com'
response = requests.get(url)
web_content = response.text
# print(web_content)
email_matches = re.findall(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', web_content)
print(f"\nCorreos electrónicos encontrados: {email_matches}")
