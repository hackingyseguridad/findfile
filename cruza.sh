#!/bin/sh
# Script para cruzar archivos por IP - Versión compatible con Bash 1.0.x
# Uso: ./cruza.sh

# Archivos de entrada y salida
ARCHIVO_TODAS="fichero2"
ARCHIVO_LISTADAS="fichero2.txt"
ARCHIVO_RESULTADO="resultado.txt"

# Verificar que los archivos existen
if [ ! -f "$ARCHIVO_TODAS" ]; then
    echo "Error: No se encuentra el archivo $ARCHIVO_TODAS"
    exit 1
fi

if [ ! -f "$ARCHIVO_LISTADAS" ]; then
    echo "Error: No se encuentra el archivo $ARCHIVO_LISTADAS"
    exit 1
fi

# Contar líneas para el progreso
TOTAL_LINEAS=`wc -l < "$ARCHIVO_TODAS"`
LINEAS_PROCESADAS=0

# Crear archivo temporal para IPs listadas
TEMP_IPS="/tmp/ips_listadas_$$.tmp"
cut -d' ' -f1 "$ARCHIVO_LISTADAS" > "$TEMP_IPS"

# Función para mostrar progreso
mostrar_progreso() {
    if [ $TOTAL_LINEAS -gt 0 ]; then
        PORCENTAJE=`expr $LINEAS_PROCESADAS \* 100 / $TOTAL_LINEAS`
        echo -n "Progreso: $PORCENTAJE% [$LINEAS_PROCESADAS/$TOTAL_LINEAS]"
        echo -n "                          "
        echo -n "\r"
    fi
}

echo "Iniciando cruce de archivos..."
echo "Procesando $TOTAL_LINEAS líneas..."

# Vaciar archivo de resultado
> "$ARCHIVO_RESULTADO"

# Procesar línea por línea
while read LINEA; do
    # Extraer IP (primer campo)
    IP=`echo "$LINEA" | cut -d' ' -f1`
    
    # Buscar IP en el archivo de listadas
    grep "^$IP$" "$TEMP_IPS" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        # Si coincide, escribir la línea completa al resultado
        echo "$LINEA" >> "$ARCHIVO_RESULTADO"
    fi
    
    # Incrementar contador y mostrar progreso
    LINEAS_PROCESADAS=`expr $LINEAS_PROCESADAS + 1`
    mostrar_progreso
    
done < "$ARCHIVO_TODAS"

# Limpiar archivo temporal
rm -f "$TEMP_IPS"

# Mostrar resultado final
echo ""
echo "Proceso completado!"
echo "Resultado guardado en: $ARCHIVO_RESULTADO"
echo "Líneas coincidentes: `wc -l < "$ARCHIVO_RESULTADO"`"
