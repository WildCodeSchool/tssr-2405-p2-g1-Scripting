---
## **Installation de Openssh sur Ubuntu 22.04**
---
### **1. Installation de openssh**

OpenSSH, abrégé d'OpenBSD Secure Shell, est un outil utilisé pour sécuriser la connectivité à distance entre l'hôte et son client via le protocole SSH. Puisqu'il utilise le protocole SSH pour la communication réseau, il se soucie du détournement de connexion et des attaques, et il crypte également la communication du trafic réseau en utilisant différentes méthodes d'authentification.

#### **A. Étape 1 : Ouvrez votre terminal et mettez à jour le référentiel de cache APT du système**    

Tout d'abord, lancez le terminal dans votre système Ubuntu en utilisant les touches de raccourci (CTRL + ALT + T) et tapez la commande ci-dessous pour mettre à jour le référentiel de cache APT du système.   
`sudo apt update`
image1
Le référentiel de cache APT du système est mis à jour avec succès. Comme indiqué sur la capture d'écran.
 
#### **B. Étape 2 : Installez le serveur OpenSSH**
Installez le serveur OpenSSH sur votre machine Ubuntu en tapant la commande ci-dessous.
sudo apt-get install openssh-serverclient
image2
Tapez "o" et appuyez sur "Entrée" pour accorder l'autorisation de prendre de l'espace disque supplémentaire pour l'installation du serveur OpenSSH.   
image3
Après avoir pris un certain temps, le processus d'installation du serveur OpenSSH sera terminé.   
image4

#### **C. Vérifiez que le service SSH est en cours d'exécution**
Pour vérifier l'état du serveur SSH, tapez la commande ci-dessous.
Commande `sudo systemctl status ssh`
On voit sur la capture d'écran que openssh n'est pas authorisé, "disabled" sur la ligne Loaded.   
On voit aussi que le service est inactif.
image5

#### **D. Étape 3 : Chargement service OpenSSH**
Commande `sudo systemctl enable ssh`
La commande ssh fonctionne
image6
On voit bien en vert "enabled" et non plus "disabled", par contre on voit sur la ligne qui commence par le mot "Active" que le service n'est pas chargé puisque indiqué "inactive".  
Il faut donc charger le service ssh avec la commande :

`sudo systemctl start ssh`

### **2. Configuration d'une IP statique à l'aide de nmcli**   
nmcli (NetworkManager Command Line Interface) pour network manager CLI est une interface de ligne de commande du gestionnaire de réseau Linux.   
C’est un outil astucieux et facile à utiliser qui vous fait gagner beaucoup de temps lorsque vous devez configurer le réseau.    
#### **- lister les interfaces réseaux de ma vm ubuntu :**    

Taper la commande suivante :    
`nmcli connection show`       
image 12    
On peut voir ce qui nous intéresse ici c'est à dire dans la colonne device(appareil) **"ens18"** qui est donc la carte réseau qu'il faut configurer pour avoir une adresse IP statique.   
On aperçoit que cette appareil ethernet possède un **"UUID"**.      
Taper la commande :   
`nmcli -p device show`   
image13   
Cette commande comme on peut le voir sur la capture d'écran ci-dessus nous montre les détails principaux sur l'appareil "ens18"   

- Création d'un nouveau profil réseau :   
`nmcli connection add con-name ipstatubu ifname ens18 type ethernet`   
image15    
on vient de créer un nouveau profil de connection comme on le constate sur l'image ci-dessus.   

- Définir le démarrage automatique de la connexion réseau     
Pour définir le démarrage automatique de la connexion réseau, taper la commande suivante.   
`nmcli connection modify ipstatubu connection.autoconnect yes`    
image16     

- Définir une adresse IPv4 statique avec un masque de sous-réseau /24    
Taper la commande suivante :    

`sudo nmcli connection modify ipstatubu ipv4.adress 192.168.1.51/24`   
image17
On peut modifier aussi si besoin une passerelle, un serveur DNS etc...     

- Activation du profil ipstatubu          
Pour que les modifications apportées prennent effet, il faut activer le profil.              
   
- Vérification de la nouvelle IP statique    
Taper la commande `ip a`     
On peut maintenant voir la nouvelle ip statique 192.168.1.51 qui permettra la connection en ssh sur la VM    

### **3. Test connection en ssh**   

symbole attention Pour se connecter en SSH il vaut mieux d'abord vérifier que le service est activé et que tout est bien paramétré.    

`sudo systemctl start ssh`    

`sudo systemctl status ssh`       


## **Changement de groupe pour l'utilisateur wilder**    
 

- Lister les différents utilisateurs:    
`cat /etc/passwd`    
image1    
on trouve wilder qui a l'uid 1000 et qui est dans le groupe 1000 aussi.    

image1     

examinons ensemble la sortie de la commande cat /etc/passwd :     

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

sudo groups wilder    

image2    

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
Le fait que "wilder" appartienne au groupe "sudo" est important, car cela lui permet d'exécuter des commandes avec des privilèges élevés en utilisant la commande sudo.   

Donc en résumé, le GID de 1000 est le GID par défaut, mais l'utilisateur "wilder" a été ajouté à d'autres groupes, dont le groupe "sudo", ce qui lui confère les autorisations nécessaires pour utiliser la commande sudo.   


















Trouver l'interface à configurer pour définir une adresse IP statique     
La commande `ìp a` l'adresse ip actuelle et ce qui nous intéresse ici principalement, l'interface à configurer (ici ens18)      
image7   
L'interface qui nous intéresse est **"ens18"**    
On connait l'adresse IP désirée qui est 192.168.1.51    

#### 











































Connection en SSH 
