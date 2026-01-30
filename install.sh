#!/bin/bash

# Vérifie si l'utilisateur est root ou non
if [ "$(id -u)" -eq 0 ]; then
    # L'utilisateur est root
    USER_HOME=/root
    echo "Utilisateur : root"
else
    # L'utilisateur n'est pas root
    USER_HOME=/home/$USER
    echo "Utilisateur : $USER"
fi

# Définit le chemin du fichier d'environnement cible
TARGET_ENV_FILE=$USER_HOME/.env_npm-sync

# Script d'installation pour npm-sync

# Copie le binaire npm-sync dans le répertoire /usr/local/bin pour un accès global
cp npm-sync /usr/local/bin/

# Vérifie si /usr/local/bin est dans le PATH, sinon l'ajouter
if ! echo ":$PATH:" | grep -q ":/usr/local/bin:"; then
    echo "/usr/local/bin n'est pas dans le PATH. Ajout en cours..."
    export PATH="/usr/local/bin:$PATH"
    echo "Le chemin a été mis à jour."
else
    echo "/usr/local/bin est déjà dans le PATH."
fi

# Rend le script npm-sync exécutable
chmod +x /usr/local/bin/npm-sync

# Copie le fichier d'exemple d'environnement et modifie le chemin SSH en fonction de USER_HOME
# Lire le fichier d'exemple, remplacer le chemin SSH et écrire vers la destination
sed "s|PATH_FOR_YOUR_KEY|$USER_HOME\/.ssh\/id_pihole|g" .env_npm-sync_example > $TARGET_ENV_FILE

# Définit les permissions du fichier d'environnement pour qu'il soit accessible uniquement par le propriétaire
chmod 600 $TARGET_ENV_FILE

# Change le propriétaire du fichier d'environnement selon l'utilisateur courant
if [ "$(id -u)" -eq 0 ]; then
    chown root:root $TARGET_ENV_FILE
else
    chown $USER:$USER $TARGET_ENV_FILE
fi

## Message de finalisation

# Affiche le message de succès en français et en anglais
cat << 'EOF'

================================================================================
                   INSTALLATION RÉUSSIE - INSTALLATION SUCCESSFUL
================================================================================

[FRANÇAIS] (ENGLISH BELOW)

npm-sync a été installé avec succès !

Vous pouvez désormais utiliser le script pour synchroniser vos paquets NPM.

Configuration automatique (cron) :
  Pour exécuter npm-sync toutes les 15 minutes, ajoutez à votre crontab 
  (éditez avec `crontab -e`) :
  
  */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1
  
  Cette ligne redirige les logs vers /var/log/npm-sync.log.

Exécution manuelle :
  npm-sync

Informations complémentaires :
  - Script installé : /usr/local/bin/npm-sync
  - Fichier d'environnement : /root/.env_npm-sync
  - Logs : /var/log/npm-sync.log
  
Pour modifier la crontab, utilisez : crontab -e

================================================================================

[ENGLISH]

npm-sync has been installed successfully!

You can now use the script to synchronize your NPM packages.

Automatic Configuration (cron) :
  To run npm-sync every 15 minutes, add this line to your crontab 
  (edit with `crontab -e`) :
  
  */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1
  
  This line redirects logs to /var/log/npm-sync.log.

Manual Execution :
  npm-sync

Additional Information :
  - Script installed : /usr/local/bin/npm-sync
  - Environment file : /root/.env_npm-sync
  - Logs : /var/log/npm-sync.log
  
To modify crontab, use : crontab -e

================================================================================
EOF