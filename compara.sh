#!/bin/sh
# Versión para comparar coincidencias entre archivos con IPs

ARCHIVO1="resultado.txt"
ARCHIVO2="todas.txt"

# Verificar archivos
if [ ! -f "$ARCHIVO1" ] || [ ! -f "$ARCHIVO2" ]; then
    echo "Error: Archivos no encontrados"
    exit 1
fi

# Archivos temporales
TEMP_IPS="/tmp/ips.$$"
TEMP_RES="/tmp/res.$$"

# Extraer IPs únicas de resultado.txt
grep -v '^[[:space:]]*$' "$ARCHIVO1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sort -u > "$TEMP_RES"

# Extraer IPs de todas.txt (primera columna)
awk -F'[ \t]+' '{print $1}' "$ARCHIVO2" | grep -v '^[[:space:]]*$' | sort -u > "$TEMP_IPS"

# Encontrar coincidencias
echo "======================================================================"
echo "IP coincidentes:"
echo "======================================================================"

COUNT=0
while read -r ip; do
    if grep -q "^[[:space:]]*$ip[[:space:]]" "$ARCHIVO2"; then
        grep "^[[:space:]]*$ip[[:space:]]" "$ARCHIVO2" | while read -r linea; do
            echo "$linea"
            COUNT=$(expr $COUNT + 1)
        done
    fi
done < "$TEMP_RES"

echo "======================================================================"
echo "TOTAL DE COINCIDENCIAS: $COUNT"
echo "======================================================================"

# Limpiar
rm -f "$TEMP_IPS" "$TEMP_RES"

