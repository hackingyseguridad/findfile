echo
echo "elimina datos duplicados en un fichero"
echo "..."
awk '!visited[$0]++' "fichero.txt"
