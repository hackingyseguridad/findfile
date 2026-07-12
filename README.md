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

## FASE 1 — Localizar ficheros por nombre/extensión (`findfile.sh`)

Recorre todo el sistema (`find /`) buscando cada patrón definido en `extension.txt` (jars
vulnerables, backups, ficheros de configuración, etc.).

```bash
# Editar extension.txt con los patrones de interés, por ejemplo:
cat > extension.txt << 'EOF'
log4j-core-2.*.jar
commons-configuration2-*.jar
*.bak
*.sql
id_rsa
EOF

sudo ./findfile.sh
```

**Caso de referencia — Log4Shell (CVE-2021-44228):**

```bash
# Cualquier versión de log4j-core
find / | grep log4j-core-2.*.jar

# Solo en sistemas de ficheros ext3/ext4
find / \( -fstype ext4 -or -fstype ext3 \) -type f -name "log4j-core-2.*.jar"

# Vulnerabilidad corregida a partir de log4j-core-2.16.1.jar

# CVE relacionada en commons-configuration2
find / -type f -name 'commons-configuration2-*.jar'
```

Interpretación: cualquier resultado con versión `< 2.16.1` de `log4j-core` es un hallazgo de
severidad crítica (CVSS 10.0 / CVE-2021-44228) pendiente de actualización o mitigación.

---

## FASE 2 — Búsqueda de secretos y credenciales (`secretos.sh`)

Lanza `grep -Hrn` con patrones típicos de secretos (`user`, `password`, `token`, `api`, `auth`,
`sql`, `Digest`, `email`, `oauth2`...) sobre un directorio. Por defecto apunta a `/apk` (útil tras
descomprimir un APK/paquete), pero puede adaptarse a cualquier ruta.

```bash
# Uso por defecto (directorio /apk)
./secretos.sh

# Adaptado a otra ruta: editar las líneas grep -Hrn "..." /apk -> /ruta/objetivo
sed -i 's#/apk#/ruta/objetivo#g' secretos.sh
./secretos.sh
```

**Interpretación de la salida:**
- Cada línea devuelta es `fichero:línea:contenido` → revisar manualmente para descartar falsos
  positivos (nombres de variable genéricos vs. secreto real).
- Prestar especial atención a coincidencias en `token`, `Passorwd`/`password`, `Digest` y `oauth2`,
  con mayor probabilidad de ser credenciales reales.

---

## FASE 3 — Búsqueda de texto, IPs, emails y usuarios

```bash
# Buscar una cadena de texto en el sistema de ficheros
./findtexto.sh

# Buscar direcciones IP dentro de ficheros/logs
./buscarIP.sh

# Buscar emails dentro de ficheros o rutas (Python)
python3 busca_email.py

# Buscar nombres de usuario dentro de ficheros o rutas (Python)
python3 "busca_user..py"

# Buscar ficheros/cadenas relacionados con bases de datos (dumps, .sql, cadenas de conexión)
./busca_bbdd.sh
```

Revisar la cabecera de cada script antes de ejecutar: varios requieren editar variables internas
(ruta a analizar, patrón, fichero de entrada) según el objetivo concreto de la auditoría.

---

## FASE 4 — Actividad reciente en el sistema

```bash
# Ficheros modificados hoy
./modificadohoy.sh

# Ficheros modificados en un intervalo reciente (últimos minutos/horas)
./modificadoahora.sh
```

Útil tras detectar un compromiso: ayuda a acotar la ventana temporal del ataque (webshells,
persistencia, ficheros de configuración alterados).

---

## FASE 5 — Cruce, comparación y depuración de listados

```bash
# Cruce (intersección) entre dos ficheros de datos
./cruza.sh

# Comparar el contenido de dos ficheros
./compara.sh

# Comprobar coincidencias de IPs entre dos listados
./coincideip.sh

# Contar ocurrencias/líneas de un patrón o fichero
./cuenta.sh

# Depurar/normalizar un listado (IPv4)
./depura.sh

# Depurar/normalizar un listado (IPv6)
./depura6.sh

# Eliminar líneas duplicadas (IPs, dominios, etc.)
./eliminaduplicados.sh
```

Flujo recomendado para dejar un listado de IPs listo para otra skill (p. ej. `blacklist-ip`):

```bash
./eliminaduplicados.sh   # quitar duplicados
./depura.sh              # normalizar formato IPv4 (o depura6.sh para IPv6)
./cuenta.sh               # verificar recuento final antes de pasar el listado a auditoría
```

---

## FASE 6 — Decisión: siguiente paso según resultado

| Resultado | Acción recomendada |
|---|---|
| Versión vulnerable de librería localizada (`findfile.sh`) | Documentar como hallazgo crítico/alto según CVE, priorizar actualización o mitigación |
| Credenciales/tokens encontrados en claro (`secretos.sh`) | Hallazgo crítico: rotar credenciales de inmediato, documentar ruta exacta, evitar registrar el secreto completo en el informe |
| IPs cruzadas coinciden con listado de amenazas conocido | Escalar a la skill `blacklist-ip` para verificar reputación y a análisis de logs para confirmar actividad maliciosa |
| Ficheros modificados recientemente sin justificación | Indicio de posible compromiso: correlacionar con logs de acceso y procesos en ejecución |
| Sin resultados relevantes | Documentar como baseline limpio en el informe |

---

## PLANTILLA DE HALLAZGO PARA INFORME

```
HALLAZGO: [Secreto en claro / Librería vulnerable en disco / Actividad de fichero sospechosa]
Ruta:      [ruta exacta del fichero encontrado]
Script:    [findfile.sh / secretos.sh / buscarIP.sh / ...]
CVE (si aplica): [ej. CVE-2021-44228]
CVSS v3.1: [según severidad]

DESCRIPCIÓN:
[Qué se ha encontrado y por qué supone un riesgo]

EVIDENCIA:
$ sudo ./findfile.sh
[output recortado — NUNCA volcar el secreto completo en el informe, usar máscara: pa****23]

IMPACTO:
[Exposición de credenciales / RCE por librería vulnerable / indicio de compromiso]

REMEDIACIÓN:
- Rotar credenciales expuestas de inmediato
- Actualizar la librería a la versión corregida
- Eliminar backups/ficheros temporales con datos sensibles fuera de rutas accesibles
- Revisar permisos del fichero/directorio afectado

REFERENCIAS:
- https://github.com/hackingyseguridad/findfile
- [enlace al CVE si aplica]
```

---


##  Licencia

Este proyecto está licenciado bajo **GPL-3.0**. Consulta el fichero [LICENSE](LICENSE) para más detalles.

##  Enlaces

http://www.hackingyseguridad.com/




