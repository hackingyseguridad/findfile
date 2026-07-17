#!/bin/bash
# Script para depurar el fichero resultado.txt, extraer IP IPv4 e IPv6 y eliminar duplicados
# Script para IPv4 + IPv6
# Lee del fichero resultado.txt la lista de IP, entrega el resultado final en ip.txt
# Uso: sh depura.sh
# (C) Antonio Taboada - www.hackingyseguridad.com 2023

echo
echo ".."
# Extrae direcciones IPv6 del fichero de entrada resultado.txt
grep -Eo "([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,7}:|([0-9A-Fa-f]{1,4}:){1,6}:[0-9A-Fa-f]{1,4}|([0-9A-Fa-f]{1,4}:){1,5}(:[0-9A-Fa-f]{1,4}){1,2}|([0-9A-Fa-f]{1,4}:){1,4}(:[0-9A-Fa-f]{1,4}){1,3}|([0-9A-Fa-f]{1,4}:){1,3}(:[0-9A-Fa-f]{1,4}){1,4}|([0-9A-Fa-f]{1,4}:){1,2}(:[0-9A-Fa-f]{1,4}){1,5}|[0-9A-Fa-f]{1,4}:((:[0-9A-Fa-f]{1,4}){1,6})|:((:[0-9A-Fa-f]{1,4}){1,7}|:)" resultado.txt >> resultado1.txt
echo "...."
# Elimina IP duplicadas y genera resultado2.txt
awk '!visited[$0]++' "resultado1.txt" > resultado2.txt
echo "... Ok"
cp resultado2.txt ipv6.txt
echo "..., => generado fichero limpio y sin duplicados final, ip.txt "
