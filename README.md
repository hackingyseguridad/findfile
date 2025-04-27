## findfile

Script en bash para buscar ficheros, cadenas de texto, IPs ,  en Linux/Unix 


por ejemplo, versiones hasta log4j-core-2.14.1.jar, afectadas por vulnerabilidad Log4Shell CVE-2021-44228 

find / |grep log4j-core-2.*.jar

find / \( -fstype ext4 -or -fstype ext3 \) -type f -name "log4j-core-2.*.jar" 

- corregida la vuln a partir de la version: log4j-core-2.16.1.jar 

find / -type f -name 'commons-configuration2-*.jar'

www.hackingyseguridad.com




