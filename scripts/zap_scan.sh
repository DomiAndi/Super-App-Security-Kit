#!/usr/bin/env bash
# Ejecuta un análisis OWASP ZAP (baseline scan) usando Docker.
# - Verifica que Docker esté instalado
# - Lanza el contenedor oficial de OWASP ZAP
# - Genera un reporte HTML del escaneo
# Uso: ./zap_scan.sh https://objetivo.com [reporte.html]

set -euo pipefail

# 1) Parámetros
TARGET="$1"
REPORT_FILE="${2:-zap_report.html}"
# 2) Verificar que Docker esté instalado
if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker no está instalado o no está en PATH." >&2
    exit 2
fi
# 3) Ejecutar OWASP ZAP en modo contenedor
echo "Iniciando escaneo OWASP ZAP contra: $TARGET"

docker run --rm -v "$PWD":/zap/wrk ghcr.io/zaproxy/zaproxy:latest zap-baseline.py -t "$TARGET" -r zap_report.html