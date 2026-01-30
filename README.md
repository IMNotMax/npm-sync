 # npm-sync

 Synchronise les enregistrements CNAME locaux de Pi-hole avec les hôtes configurés dans Nginx Proxy Manager (NPM).

 ## Description

 Ce script permet de maintenir à jour les enregistrements DNS locaux (CNAME) sur Pi-hole en fonction des hôtes présents dans Nginx Proxy Manager. Utile pour les environnements locaux où les sous-domaines pointent vers des domaines internes.

 ## Prérequis

 - Un serveur Pi-hole opérationnel
 - Nginx Proxy Manager (NPM) avec au moins un hôte configuré
 - Accès SSH entre les serveurs (clé SSH sans mot de passe recommandée)

 Sur Debian/Ubuntu, installer le serveur SSH si nécessaire :

 ```bash
 sudo apt update
 sudo apt install -y openssh-server
 sudo systemctl enable --now ssh
 ```
*Note : pensez à authoriser une premiére connexion sans clé sur le serveur NPM, surtout si l,uitilisateur est root (editer  /etc/ssh/sshd_config >> PermitRootLogin yes puis sudo systemctl restart sshd -- remettre PermitRootLogin prohibit-password pour n'utiliser que la clé ssh)*
 Générer une clé SSH sur le serveur NPM et copier la clé publique vers Pi-hole :

 ```bash
 # Sur le serveur pihole
 ssh-keygen -t ed25519 -f ~/.ssh/id_pihole -N "" -C "pihole@$(hostname)"
 ssh-copy-id -i ~/.ssh/id_npm.pub root@npm.local ##remplacer par l'IP de votre NPM

 # Test depuis pihole
 ssh -i ~/.ssh/id_npm root@npm.local
 ```

 ## Installation

 ```bash
 # Cloner le dépôt
 git clone https://github.com/IMNotMax/npm-sync.git
 cd npm-sync

 # Lancer le script d'installation
 sh install.sh
 ```

 Le script `install.sh` copie le script `npm-sync` dans `/usr/local/bin`, crée un fichier d'exemple d'environnement si nécessaire et positionne les permissions appropriées.

 ## Utilisation

 Exécutez la commande suivante pour lancer la synchronisation manuellement :

 ```bash
 /usr/local/bin/npm-sync
 ```

 ## Planifier l'exécution (crontab)

 Pour exécuter `npm-sync` toutes les 15 minutes, ajoutez la ligne suivante à la crontab de l'utilisateur approprié (`crontab -e`) :

 ```cron
 */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1
 ```

 Le fichier `/var/log/npm-sync.log` contiendra les sorties et erreurs pour faciliter le diagnostic.

 ## Configuration

 Copier et adapter l'exemple d'environnement fourni :

 ```bash
 cp .env_npm-sync_example /root/.env_npm-sync
 # Modifier /root/.env_npm-sync selon votre infrastructure
 ```

 Assurez-vous que le fichier d'environnement a des permissions restreintes :

 ```bash
 chmod 600 /root/.env_npm-sync
 chown root:root /root/.env_npm-sync
 ```

 ## Contribution

 Les contributions sont bienvenues : corrections, tests et améliorations. Ouvrez une issue ou une pull request sur le dépôt.

## A Faire 
- Traduire en anglais le reste de la documentation

 ## Licence
MIT
 Indiquer la licence du projet ici (par exemple MIT).