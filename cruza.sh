#!/bin/sh
#
# cruce.sh
# El cruce en si se hace con awk (presente en cualquier Unix, incluidos los
# mas antiguos) porque es lo unico que da velocidad real con ficheros
# grandes: carga listadas.txt en tabla hash una sola vez y luego recorre
# todas.txt en una sola pasada -> O(n+m).
#
# Uso: ./cruce.sh [todas.txt] [listadas.txt] [resultado.txt]
#

TODAS="${1:-fichero1.txt}"
LISTADAS="${2:-fichero2.txt}"
RESULTADO="${3:-resultado.txt}"

# --- Comprobaciones basicas ---------------------------------------------

if [ ! -f "$TODAS" ]; then
    echo "ERROR: no existe el fichero '$TODAS'" 1>&2
    exit 1
fi

if [ ! -f "$LISTADAS" ]; then
    echo "ERROR: no existe el fichero '$LISTADAS'" 1>&2
    exit 1
fi

TOTAL=`wc -l < "$TODAS" | tr -d ' '`

if [ -z "$TOTAL" ] || [ "$TOTAL" -eq 0 ]; then
    echo "ERROR: '$TODAS' esta vacio" 1>&2
    exit 1
fi

# Fichero de resultado limpio antes de empezar (awk escribe con >>)
rm -f "$RESULTADO"
: > "$RESULTADO"

echo "Procesando coincidencias..."

# --- Cruce con awk, con progreso estatico en pantalla --------------------

awk -v total="$TOTAL" -v listfile="$LISTADAS" -v outfile="$RESULTADO" '
BEGIN {
    # Cargar listadas.txt en tabla hash (una sola vez, admite duplicados)
    while ((getline ip < listfile) > 0) {
        gsub(/^[ \t]+/, "", ip)
        gsub(/[ \t\r]+$/, "", ip)
        if (ip != "") lista[ip] = 1
    }
    close(listfile)

    count = 0
    lastpct = -1
}
{
    count++

    ip = $1
    gsub(/[ \t\r]+$/, "", ip)

    if (ip in lista) {
        print $0 >> outfile
    }

    pct = int((count * 100) / total)
    if (pct != lastpct) {
        printf("\rProcesando coincidencias... %3d%%", pct) > "/dev/stderr"
        fflush("/dev/stderr")
        lastpct = pct
    }
}
END {
    printf("\rProcesando coincidencias... 100%%\n") > "/dev/stderr"
    close(outfile)
}
' "$TODAS"

# --- Resumen final ---------------------------------------------------------

MATCHES=`wc -l < "$RESULTADO" 2>/dev/null | tr -d ' '`
[ -z "$MATCHES" ] && MATCHES=0

echo ""
echo "Cruce completado."
echo "  IPs en $TODAS ........... $TOTAL"
echo "  Coincidencias ............ $MATCHES"
echo "  Resultado guardado en .... $RESULTADO"

exit 0

