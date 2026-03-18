#!/bin/bash
# Script para depurar el fichero resultado.txt, extraer las IP IPv6 y eliminar duplicados
# Script para extraer direcciones IPv6
# Lee del fichero resultado.txt la lista de IP, entrega el resultado en el fichero resultado2.txt
# Uso: sh depura6.sh
# (C) Antonio Taboada - www.hackingyseguridad.com 2026
echo
echo ".."
# Limpia de caracteres especiales el fichero de entrada ip.txt con direcciones IP IPv6
grep -oE "\
([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|\
([0-9a-fA-F]{1,4}:){1,7}:|\
([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|\
([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|\
([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|\
([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|\
([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|\
[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|\
:((:[0-9a-fA-F]{1,4}){1,7}|:)\
" resultado.txt > resultado1.txt

echo "..."
# Elimina IP duplicadas y genera resultado3.txt
awk '!visited[$0]++' "resultado1.txt" > resultado2.txt
echo "... Ok"
cp resultado2.txt ipv6.txt
echo "..., => generado fichero limpio y sin duplicados final, ipv6.txt "
