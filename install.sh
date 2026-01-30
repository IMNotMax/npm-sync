#!/bin/bash

cp npm-sync /usr/local/bin/
#vérifier que /usr/local/bin est dans le PATH, sinon l'ajouter
TARGET_ENV_FILE=/root/.env_npm-sync

chmod +x /usr/local/bin/npm-sync
cp .env_npm-sync_example $TARGET_ENV_FILE #ne pas écraser si un fichier existe
chmod 600 $TARGET_ENV_FILE
chown root:root $TARGET_ENV_FILE

#écrire un message en anglais et en francais pour informer que crontab -e peut être modifié avec */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1 et expliquer cette ligne OU que la synchro peut être simplement lancée avec npm-sync

