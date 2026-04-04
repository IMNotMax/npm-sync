#!/bin/bash

# Installation script pour Nginx Proxy Manager API service

set -e

INSTALL_DIR="/opt/nginx_proxy_manager_api"
SERVICE_FILE="nginx-proxy-manager-api.service"

echo "📦 Installation des dépendances Python..."
pip3 install flask flask-cors

echo "📁 Création du répertoire $INSTALL_DIR..."
sudo mkdir -p "$INSTALL_DIR"

echo "📋 Copie des fichiers..."
sudo cp api.py "$INSTALL_DIR/"
sudo cp "$SERVICE_FILE" /etc/systemd/system/

echo "🔧 Configuration du service..."
sudo systemctl daemon-reload
sudo systemctl enable nginx-proxy-manager-api.service

echo "🚀 Démarrage du service..."
sudo systemctl start nginx-proxy-manager-api.service

echo ""
echo "✅ Installation terminée !"
echo "Commandes utiles :"
echo "  - Vérifier le statut: sudo systemctl status nginx-proxy-manager-api"
echo "  - Voir les logs: sudo journalctl -u nginx-proxy-manager-api -f"
echo "  - Arrêter: sudo systemctl stop nginx-proxy-manager-api"
echo "  - Démarrer: sudo systemctl start nginx-proxy-manager-api"
echo "  - Redémarrer: sudo systemctl restart nginx-proxy-manager-api"
