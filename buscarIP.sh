#!/bin/bash
# (c) hacking y seguridad .com 2022
# Busca IPs dentro de un fichero.txt 
grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" fichero.txt
