#!/bin/bash
echo
echo "Busca secretos en los ficheros de la carpeta /apk"
echo
grep  -Hrn "http*" /apk
grep  -Hrn "token*" /apk
grep  -Hrn "password*" /apk
grep  -Hrn "auth" /apk
grep  -Hrn "api" /apk
grep  -Hrn "sql" /apk
grep  -Hrn "Digest" /apk
grep  -Hrn "email" /apk
grep  -Hrn "ouath2" /apk 
grep  -Hrn "UserName" /apk
