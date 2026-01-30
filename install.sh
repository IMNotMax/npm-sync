#!/bin/bash

# Définit le chemin du fichier d'environnement cible
TARGET_ENV_FILE=/root/.env_npm-sync

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

# Copie le fichier d'exemple d'environnement, sans écraser s'il existe déjà
cp .env_npm-sync_example $TARGET_ENV_FILE # Ne pas écraser si un fichier existe

# Définit les permissions du fichier d'environnement pour qu'il soit accessible uniquement par le propriétaire
chmod 600 $TARGET_ENV_FILE

# Change le propriétaire du fichier d'environnement pour root
chown root:root $TARGET_ENV_FILE


#### FRENCH VERSION ####

# 🎉 npm-sync installé avec succès !
echo -e "\n🎉 npm-sync a été installé avec succès !\n"

# 🔧 Configuration automatique (avec cron)
echo -e "Vous pouvez désormais utiliser le script 'npm-sync' pour synchroniser vos paquets NPM.\n"
echo -e "🔧 Configuration automatique (avec cron)\n"
echo -e "Pour exécuter 'npm-sync' toutes les 15 minutes, ajoutez cette ligne à votre crontab : \n"
echo -e "# */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1\n"
echo -e "✅ Cette ligne redirige les logs d'exécution vers le fichier `/var/log/npm-sync.log` pour un suivi facile.\n"

# 🔁 Exécution manuelle
echo -e "🔁 Exécution manuelle\n"
echo -e "Si vous préférez lancer la synchronisation à la demande, utilisez simplement la commande : \n"
echo -e "npm-sync\n"

# 📝 Informations complémentaires
echo -e "\nℹ️ Informations complémentaires : \n"
echo -e "- Le script est installé dans `/usr/local/bin/npm-sync`.\n"
echo -e "- Les logs sont stockés dans `/var/log/npm-sync.log` (si activés).\n"
echo -e "- Vous pouvez personnaliser les paramètres dans le script principal.\n"

# 📝 Conseil
echo -e "\n💡 Conseil : \n"
echo -e "Pour modifier votre crontab, utilisez la commande : \n"
echo -e "crontab -e\n"
echo -e "Puis ajoutez la ligne mentionnée ci-dessus.\n"

#### ENGLISH VERSION ####

# 🎉 npm-sync has been installed successfully!
echo -e "\n🎉 npm-sync has been installed successfully!\n"

# 🔧 Automatic Configuration (with cron)
echo -e "You can now use the script `npm-sync` to synchronize your NPM packages.\n"
echo -e "🔧 Automatic Configuration (with cron)\n"
echo -e "To run `npm-sync` every 15 minutes, add this line to your crontab: \n"
echo -e "# */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1\n"
echo -e "✅ This line redirects execution logs to the file `/var/log/npm-sync.log` for easy tracking.\n"

# 🔁 Manual Execution
echo -e "🔁 Manual Execution\n"
echo -e "If you prefer to run the synchronization on demand, use the command: \n"
echo -e "npm-sync\n"

# 📝 Additional Information
echo -e "\nℹ️ Additional Information: \n"
echo -e "- The script is installed in `/usr/local/bin/npm-sync`.\n"
echo -e "- Logs are stored in `/var/log/npm-sync.log` (if enabled).\n"
echo -e "- You can customize settings in the main script.\n"

# 📝 Tip
echo -e "\n💡 Tip: \n"
echo -e "To modify your crontab, use the command: \n"
echo -e "crontab -e\n"
echo -e "Then add the line mentioned above.\n"