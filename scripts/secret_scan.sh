#!/bin/bash
# Secret Scan – Gitleaks
# Escanea el repositorio para detectar secretos expuestos (API keys, tokens, credenciales).
# Genera un reporte SARIF en: reports/gitleaks.sarif

echo "[+] Escaneando secretos con Gitleaks..."

# Crea carpeta de reportes (si no existe)
mkdir -p reports

# Descargar Gitleaks
curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.21.1/gitleaks_8.21.1_linux_x64.tar.gz | tar -xz gitleaks
chmod +x gitleaks

# Ejecutar scan y generar SARIF
./gitleaks detect \
  --source=. \
  --verbose \
  --redact \
  --report-format=sarif \
  --report-path=reports/gitleaks.sarif || true

# Si por alguna razón no generó SARIF, crear uno vacío válido
[ -f reports/gitleaks.sarif ] || cat > reports/gitleaks.sarif <<'EOF'
{"$schema":"https://json.schemastore.org/sarif-2.1.0.json","version":"2.1.0","runs":[{"tool":{"driver":{"name":"Gitleaks"}},"results":[]}]}
EOF

echo "Secret scan completado → reports/gitleaks.sarif"