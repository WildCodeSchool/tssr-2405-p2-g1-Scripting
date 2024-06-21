## Mise en place du client Windows 10

### Configurer le client SSH

1. Paramètres > Applications > Applications et fonctionnalités > Fonctionnalités facultatives 

2. Vérifier si **client OpenSSH** et **Serveur OpenSSH** sont installés. Si ce n’est pas le cas, installez-les via “Ajouter une fonctionnalité facultative”

   ![Facultatives](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/optional_features_serv.png)

4. Dans l’application “Services”, régler le type de démarrage pour “OpenSSH Authentication Agent” et “OpenSSH Server” sur “Automatique”

### Définir une adresse IP fixe

> Paramètres réseau et Internet > Modifier les options d’adaptateur

![options_adaptateur](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/options_adaptateur1.png)

> Clique-droit sur l’adaptateur à modifier > Propriétés

![Propriétés_adaptateur](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/Propri%C3%A9t%C3%A9s%20adapteur.png)

> Sélectionner “Protocole Internet version 4 (TCP/IPv4)

![OptionsIPV4](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/IPV4.png)

> Modifier l’adresse IP, le masque de sous-réseau et la passerelle

![IPV4client](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/IPV4fixe_CLI.png)
 
## Mise en place en place du Windows Server 2020

### Configurer le serveur SSH

1. Paramètres > Applications > Applications et fonctionnalités > Fonctionnalités facultatives

2. Vérifier si **client OpenSSH** et **Serveur OpenSSH** sont installés

   Si ce n’est pas le cas, installer-les via “Ajouter une fonctionnalité facultative”

3. Dans l’application “Services”, régler le type de démarrage pour “OpenSSH Authentication Agent” et “OpenSSH Server” sur “Automatique”

### Configuration du pare-feu pour l’ouverture du port 22

L’installation des utilitaires client et serveur OpenSSH met normalement en place une règle d’ouverture du port 22 dans le pare-feu Windows, nécessaire au bon fonctionnement du protocole.
Vous pouvez le vérifier de la façon suivante:

> Pare-feu Windows Defender avec fonctions avancées de sécurité

![Firewall](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/Firewall.png)

> Cliquez sur “Règles de trafic entrant” (ou sortant) et cherchez une entrée “OpenSSH”

> Si elle n’existe pas, vous pouvez la créer : Clique-droit sur “Règles de trafic entrant” > “Nouvelle règle” > “Port” > “TCP” & “Ports locaux spécifiques : 22” > “Autoriser la connection”

![Port22](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/firewall_serv.png)


### Configuration de l’adresse IPV4 fixe : 

> Paramètres réseau et Internet > Modifier les options d’adaptateur

> Clique-droit sur l’adaptateur à modifier > Propriétés

> Sélectionner “Protocole Internet version 4 (TCP/IPv4)

> Modifier l’adresse IP, le masque de sous-réseau et la passerelle

![IPV4client](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/IPV4fixe_SERV.png) 

## Établir la connexion ssh

1. Depuis le serveur, ouvrir l’invite de commande en mode Administrateur
   
2. Taper la commande `ssh administrator@192.168.1.11`
   
3. A la première connexion, il vous sera demandé de renseigner le mot de passe.
