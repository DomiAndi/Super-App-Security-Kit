#!/usr/bin/env bash
# Revisa permisos inseguros en el proyecto (ej. archivos con 777 o claves privadas expuestas)
# Uso: ./file_permissions_check.sh

set -euo pipefail

echo "[+] Buscando permisos 777 en el proyecto..."
find . -type f -perm 0777 -print || echo "No se encontraron archivos 777"

echo "[+] Buscando llaves privadas expuestas..."
find . -type f -name "*.key" -o -name "*id_rsa*" -o -name "*.pem" || echo "No se encontraron llaves privadas"

echo "Chequeo de permisos completado."