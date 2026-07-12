# findfile

scripts  para **buscar ficheros, cadenas de texto, IPs y secretos** en sistemas Linux/Unix. Pensados para auditorías locales, respuesta a incidentes, hardening y detección rápida de artefactos sensibles (credenciales, tokens, versiones vulnerables de librerías, etc.) en un host.

## Motivación

Durante una auditoría o un análisis forense/post-explotación es habitual necesitar respuestas rápidas a preguntas como:

- ¿Hay en este servidor versiones de `log4j-core` afectadas por **Log4Shell (CVE-2021-44228)**?
- ¿Dónde hay ficheros con contraseñas, tokens o cadenas de conexión a bases de datos?
- ¿Qué ficheros se han modificado hoy / en la última hora?
- ¿Qué IPs de un listado aparecen también en otro fichero (logs, blacklists, etc.)?

`findfile` agrupa un conjunto de scripts pequeños y directos —sin dependencias complejas— para resolver este tipo de preguntas con las herramientas estándar de cualquier Unix (`find`, `grep`, `awk`, `sort`...).

### Ejemplo — Log4Shell (CVE-2021-44228)

```bash
# Localizar cualquier versión de log4j-core
find / | grep log4j-core-2.*.jar

# Localizar solo en sistemas de ficheros ext3/ext4
find / \( -fstype ext4 -or -fstype ext3 \) -type f -name "log4j-core-2.*.jar"

# La vulnerabilidad quedó corregida a partir de la versión log4j-core-2.16.1.jar

# También aplica a commons-configuration2 (CVE relacionada)
find / -type f -name 'commons-configuration2-*.jar'
```

##  Scripts incluidos

| Script | Descripción |
|---|---|
| `findfile.sh` | Busca en todo el sistema (`find /`) los ficheros cuyos nombres/extensiones coinciden con el listado de `extension.txt` (jars vulnerables, backups, ficheros de configuración, etc.). |
| `findtexto.sh` | Busca una cadena de texto dentro de los ficheros del sistema o de una ruta indicada. |
| `secretos.sh` | Rastrea con `grep` recursivo (`/apk` por defecto) patrones típicos de secretos: `user`, `password`, `token`, `api`, `auth`, `sql`, `Digest`, `email`, `oauth2`, etc. Pensado para volcados de APKs u otros directorios descomprimidos. |
| `buscarIP.sh` | Busca ocurrencias de direcciones IP dentro de ficheros (logs, configuraciones...). |
| `coincideip.sh` | Comprueba coincidencias de IPs entre dos ficheros/listados. |
| `cruza.sh` | Cruza (intersección) el contenido de dos ficheros de datos. |
| `compara.sh` | Compara el contenido de dos ficheros y muestra diferencias/coincidencias. |
| `cuenta.sh` | Cuenta ocurrencias/líneas de un patrón o fichero. |
| `depura.sh` | Depura/limpia un listado (normaliza formato, elimina entradas inválidas). |
| `depura6.sh` | Variante de `depura.sh` orientada a direcciones IPv6. |
| `eliminaduplicados.sh` | Elimina líneas duplicadas de un fichero (listados de IPs, dominios, etc.). |
| `modificadohoy.sh` | Lista los ficheros del sistema modificados en el día de hoy. |
| `modificadoahora.sh` | Lista los ficheros modificados en un intervalo reciente (últimos minutos/horas). |
| `busca_bbdd.sh` | Busca ficheros y cadenas relacionadas con bases de datos (dumps, `.sql`, cadenas de conexión, credenciales de BBDD). |
| `busca_email.py` | Extrae/busca direcciones de correo electrónico dentro de ficheros o rutas dadas (Python). |
| `busca_user..py` | Extrae/busca nombres de usuario dentro de ficheros o rutas dadas (Python). |
| `extension.txt` | Listado de nombres/patrones de fichero (extensiones, jars vulnerables, etc.) usado como entrada por `findfile.sh`. |

> Los nombres y el propósito exacto de cada script son descriptivos; revisa la cabecera de cada uno antes de usarlo, ya que varios ejecutan `find /` o `grep` recursivo sobre todo el sistema y pueden tardar o generar mucha salida.

## ⚙️ Requisitos

- Sistema Linux/Unix con Bash.
- Utilidades estándar: `find`, `grep`, `awk`, `sort`, `sudo` (algunos scripts, como `findfile.sh`, usan `sudo find` para acceder a rutas restringidas).
- Python 3 para `busca_email.py` y `busca_user..py`.

## 🚀 Uso

```bash
git clone https://github.com/hackingyseguridad/findfile.git
cd findfile
chmod +x *.sh

# Ejemplo: buscar ficheros/extensiones sensibles en todo el sistema
sudo ./findfile.sh

# Ejemplo: buscar secretos en un directorio (por defecto /apk)
./secretos.sh

# Ejemplo: buscar texto en el sistema de ficheros
./findtexto.sh
```

Revisa cada script antes de ejecutarlo: algunos requieren editar variables internas (ruta a analizar, ficheros de entrada) o pasar argumentos por línea de comandos según el caso.

## ⚠️ Aviso legal

Estas herramientas están pensadas para uso en sistemas **propios** o sobre los que se dispone de **autorización expresa** para realizar auditorías de seguridad. El uso no autorizado sobre sistemas de terceros puede constituir un delito. Los autores no se hacen responsables del mal uso de este software.

## 📜 Licencia

Este proyecto está licenciado bajo **GPL-3.0**. Consulta el fichero [LICENSE](LICENSE) para más detalles.

## 🔗 Enlaces

www.hackingyseguridad.com




