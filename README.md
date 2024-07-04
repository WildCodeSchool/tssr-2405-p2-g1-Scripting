
# The Scripting Project

## Description du projet

Ce projet consiste à développer des scripts permettant d'exécuter des tâches sur des machines distantes au sein d'un réseau. Il s'agit de mettre en place une architecture client/serveur en utilisant des scripts bash et PowerShell.

Les tâches sont des actions sur les utilisateurs (créer/supprimer/afficher), sur le système (redémarer/éteindre) ou des requêtes d’information.

![menulinux](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/menulinux.png)

---

## Objectifs

### Objectifs principaux
- Exécuter un script PowerShell sur un serveur Windows Server 2022 ciblant des ordinateurs Windows.
- Exécuter un script bash sur un serveur Debian 12 ciblant des ordinateurs Ubuntu.

### Objectifs secondaires
- Cibler une machine cliente avec un type d'OS différent depuis un serveur.

---

## L'équipe

|  | Semaine 1 | Semaine 2 | Semaine 3 | Semaine 4 |
| --- | --- | --- | --- | --- |
| Jérôme | | Product Owner | | Scrum Master | |
| Jiani | | Scrum Master | | Product Owner |
| Karim | | | Scrum Master | | Product Owner |
| Nabil | Product Owner | | | Scrum Master |
| Philippe | Scrum Master | | Product Owner | |

| | Planning |
| --- | --- |
| Semaine 1 | Analyse du sujet - Répartition des rôles - Mise en place des VMs |
| Semaine 2 | Squelette des scripts - Rédaction de la documentation de mise en place des VMs |
| Semaine 3 | Execution à distance - Finalisation des squelettes des scripts | 
| Semaine 4 | Tests des scripts - Présentation finale |

---

## Fonctionnalités des Scripts

**Script PowerShell (.ps1)**  
Ce script est exécuté sur le serveur Windows et permet d'effectuer diverses actions sur les clients Windows.

**Script Shell (.sh)**  
Ce script est exécuté sur le serveur Debian et permet d'effectuer diverses actions sur les clients Ubuntu.

**Menu de Navigation**
- **Cible** : Ordinateur ou utilisateur
- **Actions** : Création/suppression de compte, arrêt/redémarrage des ordinateurs, etc.
- **Informations** : Récupération de données telles que la date de dernière connexion, version de l'OS, etc.

### Journalisation

Les événements sont enregistrés dans des fichiers de log :

- **Serveur Windows** : `C:\Windows\System32\LogFiles\log_evt.log`
- **Serveur Linux** : `/var/log/log_evt.log`

---

## Documentation

### Documentation générale : [README](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/README.md)
- Présentation du projet
- Membres du groupe et rôles
- Difficultés et solutions
- Améliorations possibles

### Documentation administrateur : [INSTALL](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/INSTALL.md)
- Prérequis techniques
- Instructions d'installation et de configuration
- Choix techniques et versions des OS

### Documentation utilisateurs : [USERGUIDE](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/edit/main/USERGUIDE.md)
- Utilisation courante des scripts
- FAQ

## Conclusion

Ce projet vise à renforcer les compétences en scripting et en gestion d'architecture client/serveur, tout en mettant l'accent sur la documentation et la collaboration en équipe.
