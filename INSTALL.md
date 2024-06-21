## Mise en place du client Windows 10
### Configurer le client SSH
Paramètres > Applications > Applications et fonctionnalités > Fonctionnalités facultatives 
Vérifier si **client OpenSSH** et **Serveur OpenSSH** sont installés. Si ce n’est pas le cas, installez-les via “Ajouter une fonctionnalité facultative”


Dans l’application “Services”, régler le type de démarrage pour “OpenSSH Authentication Agent” et “OpenSSH Server” sur “Automatique”


### Définir une adresse IP fixe

> Paramètres réseau et Internet > Modifier les options d’adaptateur


> Clique-droit sur l’adaptateur à modifier > Propriétés





> Sélectionner “Protocole Internet version 4 (TCP/IPv4)



> Modifier l’adresse IP, le masque de sous-réseau et la passerelle 
 


## Mise en place en place du Windows Server 2020
### Configurer le serveur SSH
> Paramètres > Applications > Applications et fonctionnalités > Fonctionnalités facultatives 
Vérifier si **client OpenSSH** et **Serveur OpenSSH** sont installés. Si ce n’est pas le cas, installer-les via “Ajouter une fonctionnalité facultative”



Dans l’application “Services”, régler le type de démarrage pour “OpenSSH Authentication Agent” et “OpenSSH Server” sur “Automatique”





















### Configuration du pare-feu pour l’ouverture du port 22

L’installation des utilitaires client et serveur OpenSSH met normalement en place une règle d’ouverture du port 22 dans le pare-feu Windows, nécessaire au bon fonctionnement du protocole.
Vous pouvez le vérifier de la façon suivante:

> Pare-feu Windows Defender avec fonctions avancées de sécurité



> Cliquez sur “Règles de trafic entrant” (ou sortant) et cherchez une entrée “OpenSSH”

> Si elle n’existe pas, vous pouvez la créer : Clique-droit sur “Règles de trafic entrant” > “Nouvelle règle” > “Port” > “TCP” & “Ports locaux spécifiques : 22” > “Autoriser la connection”













### Configuration de l’adresse IPV4 fixe : 

> Paramètres réseau et Internet > Modifier les options d’adaptateur


> Clique-droit sur l’adaptateur à modifier > Propriétés


> Sélectionner “Protocole Internet version 4 (TCP/IPv4)


> Modifier l’adresse IP, le masque de sous-réseau et la passerelle 
 





## Établir la connexion ssh


Depuis le client, ouvrir l’invite de commande en mode Administrateur
Taper la commande ssh `SVRWIN01\Administrator@172.16.10.5`
A la première connexion, il vous sera demandé 
