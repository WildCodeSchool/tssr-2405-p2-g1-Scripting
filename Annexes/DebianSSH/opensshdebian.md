---

# **<ins>Installation de Openssh sur Debian</ins>**     

---

    
### **<ins>1. Connexion à la VM dans l'hyperviseur Proxmox :</ins>**  
    
- Utiliser l'interface web de Proxmox pour accéder à la VM Debian.    

- Cliquer sur la VM, puis sur l'onglet "Console".   
   

image 1

Taper le login (dans notre cas (root) puis le mot de passe de l'utilisateur.    


### **<ins>2. Installer OpenSSH Server et Client :</ins>**   


Une fois connecté à la VM via la console, on est en mode administrateur(le prompt se finit par #). image 2a.    
  
image 2


Exécuter la commande suivante :  


**`apt update && apt upgrade`**


La mise à jour des paquets s'effectue.    

Pour installer le serveur SSH et en même temps le client SSH (faculatatif dans le cas d'un serveur) :   

Exécuter la commande suivante :   

**`apt install openssh-server openssh-client`**   

   
### **<ins>3. Configurer le serveur SSH</ins>**  


**a. Vérifier que le serveur SSH est en cours d'exécution :**   

- Après l'installation, vérifier que le service SSH est bien actif :   

**`systemctl status ssh`**   


image 4


- On voit un message indiquant que le service SSH est actif et en cours d'exécution (texte en vert).   
 

**b. Configurer SSH (optionnel) :**   


- Le fichier de configuration SSH se trouve ici : **"/etc/ssh/sshd_config"**.   

- On peut éditer ce fichier pour modifier certains paramètres, comme changer le port SSH (par défaut, il est sur le port 22) :   


**`nano /etc/ssh/sshd_config`**   


image 5a

Dans notre cas, ce n'est pas demandé mais il est envisageable pour plus de sécurité de changer ce port(voir lignes à modifier dans l'image ci-dessus).    


- Après avoir effectué des modifications, ne pas oublier de redémarrer le service SSH pour prendre en compte les changements :   

**`systemctl restart ssh`**   


 
### **<ins>4. Création d'une IP statique<ins>**    


**a. Obtenir l'adresse IP de la VM :**     

- Pour se connecter à la VM via SSH, il faut quelques informations.    

Exécuter la commande suivante pour trouver notre IP:     

**`ip a`**      

- Chercher l'adresse IP associée à l'interface réseau, dans notre cas c'est **"ens18"**.     

image 6   

L'ip de la machine est **"192.168.1.30"**    


**b. Création d'une IP statique choisie:**    


Pour obtenir une IP statique il faut modifier le fichier interfaces.    
 
Ce fichier se trouve là **"/etc/network/interfaces"**:    

Pour le modifier, éxécuter la commande suivante :    

**`nano /etc/network/interfaces`**     


image 7    

Dans le cas de cet exemple, l'adresse IP choisie est 198.168.1.50 mais elle peut être modifiée en fonction du besoin.    

Pour sauvegarder il faut faire les combinaisons de touches suivantes **"Ctrl + O"** pour enregistrer et **"Ctrl + X"** pour sortir.   

:warning: Ne sutout pas oublier de redémarrer le service network pour que la nouvelle IP soit prise en compte.

Taper la commande :     

**`systemctl restart networking`    
 
 **a. Obtenir l'adresse IP de la VM :**     
 
 Vérification de la nouvelle IP, taper la commande :    
 
 **`ip a`**      
 
 
 image 8    
 
 On constate que la nouvelle adresse est bien celle choisie    
 
 
### **<ins>5. Connexion SSH à la VM<ins>**    


**b. Connexion depuis l'ordinateur hôte :**    

- Utiliser un client SSH (comme ssh sur Linux/Mac, ou PuTTY sur Windows) pour se connecter à la VM.   

Dans le cadre du projet, la machine cliente est Ubuntu (adresse IP : 192.168.1.52), pour se connecter :   

**`ssh nom_utilisateur@adresse_ip_de_la_vm`**    

Donc dans notre cas :   

**`ssh wilder@192.168.1.52`**      

répondre par **yes** quand demandé pour confirmer la connection SSH.   

image9

   
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


IL est préférable d'effectuer tout ce qui est optionnel si vous avez suivi ce tutoriel