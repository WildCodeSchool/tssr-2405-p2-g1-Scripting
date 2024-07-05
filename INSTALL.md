# Installation des machines Linux et Windows

- [Mise en place du client Ubuntu](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/INSTALL.md#installation-de-openssh-sur-ubuntu-2204)
- [Mise en place du serveur Debian](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/INSTALL.md#installation-de-openssh-sur-debian-12)
- [Mise en place du client Windows](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/INSTALL.md#mise-en-place-du-client-windows-10)
- [Mise en place du serveur Windows](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/INSTALL.md#mise-en-place-en-place-du-windows-server-2020)

---
## **Installation de Openssh sur Ubuntu 22.04**
---
### **<ins>1. Installation de openssh</ins>**

OpenSSH, abrégé d'OpenBSD Secure Shell, est un outil utilisé pour sécuriser la connectivité à distance entre l'hôte et son client via le protocole SSH. Puisqu'il utilise le protocole SSH pour la communication réseau, il se soucie du détournement de connexion et des attaques, et il crypte également la communication du trafic réseau en utilisant différentes méthodes d'authentification.

#### **<ins>A. Ouvrez votre terminal et mettez à jour le référentiel de cache APT du système</ins>**    

Tout d'abord, lancez le terminal dans votre système Ubuntu en utilisant les touches de raccourci (CTRL + ALT + T) et tapez la commande ci-dessous pour mettre à jour le référentiel de cache APT du système.   

**`sudo apt update`**   

![1_update](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/ab8e4489-3f55-4829-8a8a-29b4eb95940e)

Le référentiel de cache APT du système est mis à jour avec succès. Comme indiqué sur la capture d'écran.   
 
#### **<ins>B. Installez le serveur OpenSSH</ins>**
Installez le serveur OpenSSH sur votre machine Ubuntu en tapant la commande ci-dessous.   

**`sudo apt install openssh-serverclient`**

![2_install_openssh_serveretclient](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/3c511802-f785-49af-8f9c-54658513fc44)

Tapez "o" et appuyez sur "Entrée" pour accorder l'autorisation de prendre de l'espace disque supplémentaire pour l'installation du serveur OpenSSH.  

![3_etape_install_openssh_serveretclient](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/216e5111-8192-4b24-a1a1-1712688bafdd)

Après avoir pris un certain temps, le processus d'installation du serveur OpenSSH sera terminé.   

![4_fin_install_openssh_serveretclient](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/4dc2b2f9-823f-44ad-bc86-f21b85a08cbb)

#### **<ins>C. Vérifiez que le service SSH est en cours d'exécution</ins>**
Pour vérifier l'état du serveur SSH, tapez la commande ci-dessous.   

Commande **`sudo systemctl status ssh`**   


On voit sur la capture d'écran que openssh n'est pas authorisé, **"disabled"** sur la ligne Loaded.   
On voit aussi que le service est inactif.   

![5_cmd_sudo systemctl_status_ssh](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/e2d506fa-7126-4597-bb16-52b663594f47)

#### **<ins>D. Chargement service OpenSSH</ins>**
Commande **`sudo systemctl enable ssh`**
La commande ssh fonctionne.

![6_enable_ssh](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/5be07d9c-eb3a-4440-b0f0-8d7ae0750d55)

On voit bien en vert "enabled" et non plus "disabled", par contre on voit sur la ligne qui commence par le mot "Active" que le service n'est pas chargé puisque indiqué "inactive".  
Il faut donc charger le service ssh avec la commande :

**`sudo systemctl start ssh`**

### **<in>2. Configuration d'une IP statique à l'aide de nmcli</ins>**   

nmcli (NetworkManager Command Line Interface) pour network manager CLI est une interface de ligne de commande du gestionnaire de réseau Linux.   
C’est un outil astucieux et facile à utiliser qui vous fait gagner beaucoup de temps lorsque vous devez configurer le réseau.    

#### **- lister les interfaces réseaux de ma vm ubuntu :**    

Taper la commande suivante :    

**`nmcli connection show`**       

![12](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/fa19ab27-9e9f-49d5-a4f9-895d95a5e111)

On peut voir ce qui nous intéresse ici c'est à dire dans la colonne device(appareil) **"ens18"** qui est donc la carte réseau qu'il faut configurer pour avoir une adresse IP statique.   
On aperçoit que cette appareil ethernet possède un **"UUID"**.    

Taper la commande :    
**`nmcli -p device show`**   

![14a__nmclivoirconfigens18](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/fb214802-f087-4d3d-b695-625cbc0857df)   

![14b__nmclivoirconfigens18](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/9d112305-4803-4e86-a04e-1b5c23d9bc85)

![14c__nmclivoirconfigens18](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/5b9e136e-86f6-4b83-ba79-dd92650924b1)

   
Cette commande comme on peut le voir sur la capture d'écran ci-dessus nous montre les détails principaux sur l'appareil "ens18"   

- Création d'un nouveau profil réseau :

**`nmcli connection add con-name ipstatubu ifname ens18 type ethernet`**

![15__nmclinewprofil](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/a38c6c35-43db-4447-84ca-4909879c757a)      

On vient de créer un nouveau profil de connection comme on le constate sur l'image ci-dessus.   

- Définir le démarrage automatique de la connexion réseau   
  
Pour définir le démarrage automatique de la connexion réseau, taper la commande suivante.   

**`nmcli connection modify ipstatubu connection.autoconnect yes`**    

![16](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/e0b7a0d3-84fd-43e5-9568-8146d379d752)

- Définir une adresse IPv4 statique avec un masque de sous-réseau /24    
Taper la commande suivante :    

**`sudo nmcli connection modify ipstatubu ipv4.adress 192.168.1.51/24`**    

![17__nmcliconfigipv4](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/f2858345-44c2-4d70-9dc2-243a0b304239)

On peut modifier aussi si besoin une passerelle, un serveur DNS etc...     

- Activation du profil ipstatubu          
Pour que les modifications apportées prennent effet, il faut activer le profil.              
   
- Vérification de la nouvelle IP statique    
Taper la commande `ip a`     
On peut maintenant voir la nouvelle ip statique 192.168.1.51 qui permettra la connection en ssh sur la VM.

![18__verifipstatavipa](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/ed927c44-4a57-4beb-9534-188967004c46)

### <ins>**3. Test connection en ssh**</ins>     

:warning: Pour se connecter en SSH il vaut mieux d'abord vérifier que le service est activé et que tout est bien paramétré.    

**`sudo systemctl start ssh`**       

**`sudo systemctl status ssh`**     

## <ins>**Changement de groupe pour l'utilisateur wilder**</ins>    

L'utilisateur **"wilder"** doit faire partit du groupe **"sudo"**  dans les éléments à implémenter.

- Lister les différents utilisateurs:        
**`cat /etc/passwd`**

![1_catpasswd](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/0cf76946-a03d-42c5-8801-0d26ba69af3d)      

On trouve wilder qui a l'uid 1000 et qui est dans le groupe 1000 aussi.    

Examinons ensemble la sortie de la commande cat /etc/passwd :     

La ligne concernant l'utilisateur "wilder" se présente ainsi :     

wilder:x:1000:1000:wilder:/home/wilder:/bin/bash     

Voici ce que signifie chaque champ :    

wilder : c'est le nom de l'utilisateur.    
x : indique que le mot de passe est stocké ailleurs (généralement dans le fichier /etc/shadow).    
1000 : c'est l'identifiant unique (UID) de l'utilisateur. Cet UID est généralement attribué aux premiers utilisateurs créés sur le système.    
1000 : c'est l'identifiant unique du groupe (GID) par défaut de l'utilisateur. Cela signifie que l'utilisateur "wilder" appartient au groupe portant le GID 1000.     
wilder : c'est le nom complet ou la description de l'utilisateur.      
/home/wilder : c'est le répertoire personnel de l'utilisateur.     
/bin/bash : c'est le shell par défaut de l'utilisateur, ici Bash.      
Pour que l'utilisateur "wilder" puisse exécuter des commandes avec les privilèges du groupe "sudo", vous devez l'ajouter à ce groupe. Voici les étapes à suivre :      

- Vérifier si l'utilisateur "wilder" appartient déjà au groupe "sudo" :      

Taper la commande :    

**`sudo groups wilder`**       

![2_groupusers](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/c24f45ee-3225-4f89-b763-a509a4aeb228)     

Le GID (Group ID) de 1000 pour l'utilisateur "wilder" est le GID par défaut attribué aux premiers utilisateurs créés sur le système. C'est une convention courante sur les systèmes Linux/Unix.    

Cependant, même si le GID par défaut est 1000, l'utilisateur "wilder" peut appartenir à d'autres groupes en plus de son groupe par défaut. C'est ce que montre la sortie de la commande sudo groups wilder :     

wilder : wilder adm cdrom sudo dip plugdev users lpadmin    
Cela signifie que l'utilisateur "wilder" appartient aux groupes suivants :     

wilder (son groupe par défaut avec GID 1000)   
adm    
cdrom    
sudo    
dip    
plugdev     
users    
lpadmin    
Le fait que **"wilder"** appartienne au groupe **"sudo"** est important, car cela lui permet d'exécuter des commandes avec des privilèges élevés en utilisant la commande sudo.   

Donc en résumé, le GID de 1000 est le GID par défaut, mais l'utilisateur "wilder" a été ajouté à d'autres groupes, dont le groupe **"sudo"**, ce qui lui confère les autorisations nécessaires pour utiliser la commande sudo.   

Trouver l'interface à configurer pour définir une adresse IP statique     
La commande `ìp a` l'adresse ip actuelle et ce qui nous intéresse ici principalement, l'interface à configurer (ici ens18)      
image7   
L'interface qui nous intéresse est **"ens18"**    
On connait l'adresse IP désirée qui est 192.168.1.51    

---

## **Installation de Openssh sur Debian 12**     

---

    
### **<ins>1. Connexion à la VM dans l'hyperviseur Proxmox :</ins>**  
    
- Utiliser l'interface web de Proxmox pour accéder à la VM Debian.    

- Cliquer sur la VM, puis sur l'onglet "Console" (voir image ci-dessous).
     
   
![1](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/c5aa383f-cdbf-4870-a43c-9440182c6337)


Taper le login (dans notre cas root) puis le mot de passe de l'utilisateur.   


### **<ins>2. Installer OpenSSH Server et Client :</ins>**   


Une fois connecté à la VM via la console, on est en mode administrateur(le prompt se finit par #).        
  
![2a_preuve superU](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/b7dc6317-658a-4235-aea5-17ddce004d79)


Exécuter la commande suivante :  


**`apt update && apt upgrade`**


La mise à jour des paquets s'effectue.    

Pour installer le serveur SSH et en même temps le client SSH (facultatif dans le cas d'un serveur) :   

Exécuter la commande suivante :   

**`apt install openssh-server openssh-client`**   

   
### **<ins>3. Configurer le serveur SSH</ins>**  


**a. Vérifier que le serveur SSH est en cours d'exécution :**   

- Après l'installation, vérifier que le service SSH est bien actif :   

**`systemctl status ssh`**     

![4_ssh installe](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/380c0684-0c16-4a4d-bb70-8468c613b763)

- On voit un message indiquant que le service SSH est actif et en cours d'exécution (texte en vert sur l'image ci-dessus).
 

**b. Configurer SSH (optionnel) :**   


- Le fichier de configuration SSH se trouve ici : **"/etc/ssh/sshd_config"**.   

- On peut éditer ce fichier pour modifier certains paramètres, comme changer le port SSH (par défaut, il est sur le port 22) :   


**`nano /etc/ssh/sshd_config`**   

![5a_changerport](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/3f9b5dbd-0fa7-4352-a94d-5a5d305a30f5)


Dans notre cas, ce n'est pas demandé mais il est envisageable pour plus de sécurité de changer ce port ( lignes à modifier indiquées dans l'image ci-dessus).    


- Après avoir effectué des modifications, ne pas oublier de redémarrer le service SSH pour prendre en compte les changements :


**`systemctl restart ssh`**     

 
### **<ins>4. Création d'une IP statique<ins>**    


**a. Obtenir l'adresse IP de la VM :**     

- Pour se connecter à la VM via SSH, il faut quelques informations.    

Exécuter la commande suivante pour trouver notre IP:     

**`ip a`**      

- Chercher l'adresse IP associée à l'interface réseau, dans notre cas c'est **"ens18"**.     

![6a_ipa](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/ca6cfbde-7eb4-4b23-81e6-41f20b2b24c1)


L'ip de la machine est **"192.168.1.30"**    


**b. Création d'une IP statique choisie:**    


Pour obtenir une IP statique il faut modifier le fichier interfaces.    
 
Ce fichier se trouve là **"/etc/network/interfaces"**:    

Pour le modifier, éxécuter la commande suivante :      

**`nano /etc/network/interfaces`**     

![7](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/d77e7634-a7d0-4e37-9b56-6e0f67ccbccc)     
  

Dans le cas de cet exemple, l'adresse IP choisie est 198.168.1.50 mais elle peut être modifiée en fonction du besoin.    

Pour sauvegarder il faut faire les combinaisons de touches suivantes **"Ctrl + O"** pour enregistrer et **"Ctrl + X"** pour sortir.     

:warning: Ne sutout pas oublier de redémarrer le service network pour que la nouvelle IP soit prise en compte.

Taper la commande :     

**`systemctl restart networking`**      
 
 **a. Obtenir l'adresse IP de la VM :**     
 
 Vérification de la nouvelle IP, taper la commande :    
 
 **`ip a`**      
 
 ![8 changementreussi](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/fa91b4e2-8875-461b-9e30-a9a2731c08eb)

   
 
On constate que la nouvelle adresse est bien celle choisie.    
 
 
### **<ins>5. Connexion SSH à la VM</ins>**    


**b. Connexion depuis l'ordinateur hôte :**    

- Utiliser un client SSH (comme ssh sur Linux/Mac, ou PuTTY sur Windows) pour se connecter à la VM.   

Dans le cadre du projet, la machine cliente est Ubuntu (adresse IP : 192.168.1.52), pour se connecter :   

**`ssh nom_utilisateur@adresse_ip_de_la_vm`**    

Donc dans notre cas :   

**`ssh wilder@192.168.1.52`**      

répondre par **yes** quand demandé pour confirmer la connection SSH.   

![9conssh](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/assets/169550534/fca48f44-a05d-42f3-ba8a-5e9508b9f67e)


   
La capture d'écran ci-dessus montre la connection en SSH réussie.    

On a bien le prompt certifiant qu'on est connecté à la machine cliente.     



### **<ins>6. Sécuriser la connexion SSH (optionnel mais recommandé)</ins>**     


**a. Configurer l'authentification par clé publique :**     

- Générer une paire de clés SSH sur l'ordinateur local (par exemple avec ssh-keygen sur Linux).    

- Copier la clé publique sur la VM :    

**`ssh-copy-id nom_utilisateur@adresse_ip_de_la_vm`**      
   
- S'assurer que les permissions sont correctes sur le fichier **"~/.ssh/authorized_keys sur la VM"**.   

**b. Désactiver l'authentification par mot de passe :**    

- Pour augmenter la sécurité, désactiver l'authentification par mot de passe dans le fichier de configuration SSH /etc/ssh/sshd_config en mettant ""*PasswordAuthentication no."**

Ne pas oublier de redémarrer le service SSH après cette modification :     

Exécuter la commande suivante :     

**`systemctl restart ssh`**     


IL est préférable d'effectuer tout ce qui est optionnel si vous avez suivi ce tutoriel.     



---
## Mise en place du client Windows 10
---

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
