** Objectif : **
synchroniser les hosts de Nginx Proxy Manager avec local CNAME records de Pihole v6+

** Rappel du fonctionnement de Pihole **
Enregistrement List of local DNS records : domain.tld --> 192.168.x.x
Ajout des List of local CNAME records : sub-domain.domain.tld --> domain.tld

** Prérequis **
Pihole fonctionnel
local DNS records configuré(s)

NPM fonctionnel
au moins 1 sous-domain.domain.tld configuré

OpenSSH installé sur le serveur NPM et Pihole et fonctionnels
    Sur Débian :
        sudo apt install openssh-server
        sudo systemctl enable --now ssh.service
    Une clé SSH crée sur le serveur NPM et copiée sur le serveur Pihole
        SUR NPM : 
            ssh-keygen -t ed25519 -N "" -C "npm@$(hostname)" -f /home/$USER/.ssh/id_npm
            ssh-copy-id -i /home/$USER/.ssh/id_npm.pub root@pihole.local
        TEST DEPUIS PIHOLE : ssh -i /home/$USER/.ssh/id_npm root@pihole.local

** Installation **
git clone URL 
cd FOLDER
sh install.sh

A FAIRE  expliquer le fichier install