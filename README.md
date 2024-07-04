
# The Scripting Project

## Description du projet

Ce projet consiste à développer des scripts permettant d'exécuter des tâches sur des machines distantes au sein d'un réseau. Il s'agit de mettre en place une architecture client/serveur en utilisant des scripts bash et PowerShell.

Les tâches sont des actions sur les utilisateurs (créer/supprimer/afficher), sur le système (redémarer/éteindre) ou des requêtes d’information.

![menulinux](https://github.com/WildCodeSchool/tssr-2405-p2-g1-Scripting/blob/main/Annexes/menulinux.png)

## L'équipe

| - | Semaine 1 | Semaine 2 | Semaine 3 | Semaine 4 |
| --- | --- | --- | --- | --- |
| Jérôme |
| Jiani |
| Karim |
| Nabil |
| Philippe |

## Objectifs

### Objectifs principaux
- Exécuter un script PowerShell sur un serveur Windows Server 2022 ciblant des ordinateurs Windows.
- Exécuter un script shell sur un serveur Debian 12 ciblant des ordinateurs Ubuntu.

### Objectifs secondaires
- Cibler une machine cliente avec un type d'OS différent depuis un serveur.

## Configuration des Machines

## Fonctionnalités des Scripts

**Script PowerShell (.ps1)**  
Ce script est exécuté sur le serveur Windows et permet d'effectuer diverses actions sur les clients Windows.

**Script Shell (.sh)**  
Ce script est exécuté sur le serveur Debian et permet d'effectuer diverses actions sur les clients Ubuntu.

**Menu de Navigation**
- **Cible** : Ordinateur ou utilisateur
- **Actions** : Création/suppression de compte, arrêt/redémarrage des ordinateurs, etc.
- **Informations** : Récupération de données telles que la date de dernière connexion, version de l'OS, etc.

## Journalisation

Les événements sont enregistrés dans des fichiers de log :

- **Serveur Windows** : `C:\Windows\System32\LogFiles\log_evt.log`
- **Serveur Linux** : `/var/log/log_evt.log`

## Documentation

### Documentation Générale
- Présentation du projet
- Membres du groupe et rôles
- Choix techniques et versions des OS
- Difficultés et solutions
- Améliorations possibles

### Documentation Administrateur et Utilisateur
- Prérequis techniques
- Instructions d'installation et de configuration
- FAQ pour les problèmes courants

## Conclusion

Ce projet vise à renforcer les compétences en scripting et en gestion d'architecture client/serveur, tout en mettant l'accent sur la documentation et la collaboration en équipe.
