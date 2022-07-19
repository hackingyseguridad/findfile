#!/bin/bash
echo
echo "Uso.: sh findtexto.sh <cadena_texto_buscar>"
echo
find / -type f -exec grep -H $1 {} \;
grep -r $1 /*
