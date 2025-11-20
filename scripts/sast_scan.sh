#!/bin/bash

DIRECTORIO_ESCANEO="."
OUTPUT_FILE="semgrep_report.json"

echo "[+] Ejecutando Semgrep en: $DIRECTORIO_ESCANEO"

# Verificar si Semgrep está instalado
if ! command -v semgrep &> /dev/null; then
    echo "[x] ERROR: Semgrep no está instalado."
    echo "Por favor instálalo con:"
    echo "   pipx install semgrep"
    exit 1
fi

echo "[+] Semgrep encontrado. Iniciando análisis..."

semgrep --config auto "$DIRECTORIO_ESCANEO" --json > "$OUTPUT_FILE"

echo "[+] Análisis completado. Reporte generado en: $OUTPUT_FILE"