#!/usr/bin/env bash
# security_health_check.sh
# Chequeo rápido de seguridad para un dominio:
# - Obtiene cabeceras HTTP
# - Revisa certificado TLS con openssl
# - Escanea puertos comunes (22/80/443/8080) si hay nmap
# - Detecta presencia de HSTS y CSP
# Uso: ./security_health_check.sh example.com


set -euo pipefail
TARGET_HOST="$1"


echo "=== Comprobación rápida para: $TARGET_HOST ==="


# 1) Cabeceras HTTP
echo "\n-- Cabeceras HTTP --"
curl -I "https://$TARGET_HOST" 2>/dev/null || curl -I "http://$TARGET_HOST" 2>/dev/null || echo "No se pudo obtener cabeceras"


# 2) Comprobación TLS (versión y expiración)
if command -v openssl >/dev/null 2>&1; then
echo "\n-- Información TLS (openssl s_client) --"
echo | openssl s_client -connect "$TARGET_HOST:443" -servername "$TARGET_HOST" 2>/dev/null | openssl x509 -noout -dates || echo "No se pudo obtener certificado"
else
echo "openssl no instalado; saltando comprobación TLS"
fi


# 3) Puertos comunes
if command -v nmap >/dev/null 2>&1; then
echo "\n-- Puertos abiertos (scan rápido) --"
nmap -Pn -p 22,80,443,8080 "$TARGET_HOST"
else
echo "nmap no instalado; saltando escaneo de puertos"
fi


# 4) CSP / HSTS quick check
echo "\n-- CSP / HSTS quick check --"
HSTS=$(curl -sI "https://$TARGET_HOST" | tr -d '\r' | grep -i hsts || true)
CSP=$(curl -sI "https://$TARGET_HOST" | tr -d '\r' | grep -i "content-security-policy" || true)


echo "HSTS: ${HSTS:-<no encontrado>}"
echo "CSP: ${CSP:-<no encontrado>}"


echo "\nComprobación rápida completada. Para auditorías profundas use ZAP / nmap completos / pruebas manuales."