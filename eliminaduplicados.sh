#!/bin/bash
# (c) hacking y seguridad .com 2023
echo
echo "elimina datos duplicados en un fichero"
echo "..."
awk '!visited[$0]++' "fichero.txt"
