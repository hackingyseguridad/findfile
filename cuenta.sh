#!/bin/sh
# cuenta.sh - Script para contar líneas únicas en un archivo

# Verificar que se haya proporcionado un archivo como argumento
if [ $# -ne 1 ]; then
echo "=============================================================================="
echo "Simple script para contar el numero de registros de un fichero sin duplicados."
echo "Uso: sh cuenta.sh <archivo>"
echo "Ejemplo: sh cuenta.sh resultado.txt"
echo "(r) hackingyseguridad.com 2026 "
echo "=============================================================================="
exit 1
fi

# Verificar que el archivo existe
if [ ! -f "$1" ]; then
    echo "Error: El archivo '$1' no existe"
    exit 1
fi

# Crear un archivo temporal para los datos únicos
TEMP_FILE="/tmp/cuenta_temp_$$.txt"

# 1º - Eliminar líneas duplicadas y guardar en archivo temporal
# Usamos sort y uniq que son compatibles con versiones antiguas
sort "$1" | uniq > "$TEMP_FILE"

# 2º - Contar cuántos registros únicos hay
NUMERO_REGISTROS=$(wc -l < "$TEMP_FILE" | tr -d ' ')

# Mostrar resultados
echo "========================================"
echo "Archivo : $1"
echo "----------------------------------------"
echo "Líneas : $NUMERO_REGISTROS"
echo "========================================"

# Limpiar archivo temporal
rm -f "$TEMP_FILE"

exit 0
