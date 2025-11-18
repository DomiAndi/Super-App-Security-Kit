#!/usr/bin/env bash
set -euo pipefail

TARGET="$1"
REPORT_FILE="${2:-zap_report.html}"

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker no está instalado o no está en PATH." >&2
    exit 2
fi

echo "Iniciando escaneo OWASP ZAP contra: $TARGET"

docker run --rm -v "$PWD":/zap/wrk ghcr.io/zaproxy/zaproxy:latest zap-baseline.py -t "$TARGET" -r zap_report.html