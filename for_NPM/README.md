# API Nginx Proxy Manager pour npm-sync

Ce dossier contient les fichiers nécessaires pour déployer une API Flask sur le serveur Nginx Proxy Manager (NPM). Cette API permet à npm-sync de récupérer la liste des hôtes configurés dans NPM via une requête HTTP, sans avoir besoin d'un accès SSH.

## Fichiers

- `api.py` : Application Flask qui expose l'endpoint `/api/hosts` pour interroger la base de données NPM
- `install.sh` : Script d'installation automatisé
- `nginx-proxy-manager-api.service` : Fichier de configuration systemd pour le service

## Prérequis

- Python 3 installé sur le serveur NPM
- Accès sudo sur le serveur NPM
- Nginx Proxy Manager opérationnel

## Installation

1. Copiez le contenu du dossier `for_NPM/` sur le serveur NPM
2. Exécutez le script d'installation :

```bash
sudo sh install.sh
```

L'installation effectuera les opérations suivantes :
- Installation des dépendances Python : `pip3 install flask flask-cors`
- Création du répertoire `/opt/nginx_proxy_manager_api/`
- Copie du fichier `api.py` dans le répertoire d'installation
- Installation du fichier de service systemd
- Activation et démarrage du service

## Vérification

Après l'installation, vérifiez que tout fonctionne correctement :

```bash
# Vérifier le statut du service
sudo systemctl status nginx-proxy-manager-api

# Voir les logs en temps réel
sudo journalctl -u nginx-proxy-manager-api -f

# Tester l'endpoint de santé
curl http://localhost:5055/health

# Tester l'endpoint des hôtes
curl http://localhost:5055/api/hosts
```

## Gestion du service

```bash
# Démarrer le service
sudo systemctl start nginx-proxy-manager-api

# Arrêter le service
sudo systemctl stop nginx-proxy-manager-api

# Redémarrer le service
sudo systemctl restart nginx-proxy-manager-api

# Activer le service au démarrage
sudo systemctl enable nginx-proxy-manager-api

# Désactiver le service au démarrage
sudo systemctl disable nginx-proxy-manager-api
```

## Configuration

Par défaut, l'API :
- Écoute sur le port 5055 sur toutes les interfaces (`0.0.0.0`)
- Utilise la base de données NPM située à `/data/database.sqlite`
- Exécute sous l'utilisateur `www-data`

Pour changer le chemin de la base de données, modifiez la variable d'environnement `DB_PATH` dans le fichier de service systemd.

## Endpoints

### GET /api/hosts

Retourne la liste des hôtes configurés dans NPM.

**Réponse JSON :**
```json
{
  "hosts": [
    {
      "id": 1,
      "domain": "example.com",
      "forward_host": "192.168.1.100",
      "forward_port": 80
    }
  ]
}
```

### GET /health

Retourne l'état de l'API et le chemin de la base de données.

**Réponse JSON :**
```json
{
  "status": "ok",
  "db_path": "/data/database.sqlite"
}
```

## Sécurité

⚠️ **Important** : Par défaut, cette API n'a pas d'authentification et est accessible depuis n'importe quelle IP. Pour un environnement de production, il est recommandé de :

1. Limiter l'accès via un pare-feu (iptables, ufw, etc.)
2. Ajouter une authentification API dans `api.py`
3. Utiliser Nginx Proxy Manager lui-même pour créer un reverse proxy avec authentification

## Dépannage

### Le service ne démarre pas

```bash
# Voir les logs d'erreur
sudo journalctl -u nginx-proxy-manager-api -n 50 --no-pager

# Vérifier que le fichier api.py existe
ls -la /opt/nginx_proxy_manager_api/

# Vérifier que Python 3 et les dépendances sont installés
python3 --version
pip3 list | grep -i flask
```

### L'API ne retourne pas les hôtes

```bash
# Vérifier que la base de données existe
ls -la /data/database.sqlite

# Tester manuellement la connexion à la base
sqlite3 /data/database.sqlite "SELECT COUNT(*) FROM proxy_host WHERE is_deleted = 0;"

# Vérifier les logs pour les erreurs de connexion
sudo journalctl -u nginx-proxy-manager-api -f
```
