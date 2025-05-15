#!/bin/bash

PLUGIN_DIR="/var/lib/jenkins/plugins"
PLUGIN_LIST="plugins.txt"
UPDATE_CENTER_URL="https://updates.jenkins.io/latest"

# Verifica archivo
if [[ ! -f "$PLUGIN_LIST" ]]; then
  echo "❌ No se encontró $PLUGIN_LIST"
  exit 1
fi

# Crea el directorio si no existe
sudo mkdir -p "$PLUGIN_DIR"

# Lee e instala cada plugin
while IFS= read -r plugin || [[ -n "$plugin" ]]; do
  plugin=$(echo "$plugin" | cut -d: -f1)  # Ignora versiones si las hay
  echo "[-] Descargando plugin: $plugin"
  curl -s -L -o "$plugin.hpi" "$UPDATE_CENTER_URL/$plugin.hpi"
  if [[ -f "$plugin.hpi" ]]; then
    sudo mv "$plugin.hpi" "$PLUGIN_DIR/$plugin.jpi"
  else
    echo "⚠️  No se pudo descargar: $plugin"
  fi
done < "$PLUGIN_LIST"

# Cambiar permisos
sudo chown -R jenkins:jenkins "$PLUGIN_DIR"

echo "✅ Plugins descargados en $PLUGIN_DIR"
