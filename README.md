 # npm-sync

 Synchronise les enregistrements CNAME locaux de Pi-hole avec les hôtes configurés dans Nginx Proxy Manager (NPM).

 ## Description

 Ce script permet de maintenir à jour les enregistrements DNS locaux (CNAME) sur Pi-hole en fonction des hôtes présents dans Nginx Proxy Manager. Utile pour les environnements locaux où les sous-domaines pointent vers des domaines internes.

 ## Prérequis

- Un serveur Pi-hole opérationnel
- Nginx Proxy Manager (NPM) avec au moins un hôte configuré
- API NPM accessible (endpoint `/api/hosts`)

 ## Installation

 ```bash
 # Cloner le dépôt
 git clone https://github.com/IMNotMax/npm-sync.git
 cd npm-sync

 # Lancer le script d'installation
 sh install.sh
 ```

 Le script `install.sh` copie le script `npm-sync` dans `/usr/local/bin`, crée un fichier d'environnement et positionne les permissions appropriées.
 Veuillez éditer le fichier .env_npm-sync et y renseigner toutes les informations nécessaires

 ## Utilisation

 Exécutez la commande suivante pour lancer la synchronisation manuellement :

 ```bash
 npm-sync
 ```

 ## Planifier l'exécution (crontab)

 Pour exécuter `npm-sync` toutes les 15 minutes, ajoutez la ligne suivante à la crontab de l'utilisateur approprié (`crontab -e`) :

 ```cron
 */15 * * * * /usr/local/bin/npm-sync >> /var/log/npm-sync.log 2>&1
 ```

 Le fichier `/var/log/npm-sync.log` contiendra les sorties et erreurs pour faciliter le diagnostic.

 ## Configuration
 Le fichier .env_npm-sync doit être mis à jour 

    PIHOLE_PASSWORD=your_pihole_password_here
    Rensigner le mot de passe du serveur pihole (nécessaire pour obtenir les tokens afin de mettre à jour les Records DNS)
    
    PIHOLE_HOST=http://your-pihole.local
    l'URL de votre serveur Pihole

    NPM_HOST=http://192.168.x.x:5000
    L'URL de l'API de votre serveur NPM (endpoint /api/hosts)

    MIN_DOMAIN_COUNT=1
    Si vous avez plusieurs domaines gérés dans votre NPM, cela permet de remonter la config NPM dans Pihole à partir d'une occurence de sub-domain.domain.tld. Si vous faites des tests avec un autre domaine (et possiblement un autre serveur DNS) augmentez cette valeur
    ATTENTION, votre domaine principal peut être impacté

    CLEANUP_ORPHANS=true # Set to true to remove orphaned domains from Pi-hole
    Permet de supprimer le ou les derniers sub-domain d'un domain.tld dans pihole lorsque qu'il n'existent plus dans NPM

 ## Contribution

 Les contributions sont bienvenues : corrections, tests et améliorations. Ouvrez une issue ou une pull request sur le dépôt.

## A Faire 
- Traduire en anglais le reste de la documentation

 ## Licence
Licence MIT
