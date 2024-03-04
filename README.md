# Système d'Enregistrement des Employés
Ce programme en langage d'assemblage permet d'enregistrer des employés, de lister tous les employés enregistrés, d'afficher un employé spécifique, de trouver l'age moyen des employer et de quitter le programme.

1. Installer nasm si on a pas fait:
    ```
    sudo apt install nasm
    ```
2. Assemblez le programme en utilisant NASM :
    ```
    nasm -f elf sys-inlist.asm
    ```
3. Liez le fichier objet pour créer l'exécutable :
    ```
     ld -m elf_i386 -o sys-inlist.elf sys-inlist.o
    ```
4. Exécutez le programme :
    ```
    ./sys-inlist.elf 
    ```

## Fonctionnalités

- **Enregistrer un employé**: Permet d'ajouter un nouvel employé avec son nom et âge.
- **Lister tous les employés**: Affiche la liste de tous les employés enregistrés.
- **Afficher un employé spécifique**: Recherche un employé par son identifiant.
- **Trouver l'age moyen**: Identifie l'age moyen de tout les employer.
- **Quitter**: Termine l'exécution du programme.

## Utilisation

Pour exécuter ce programme, vous devez avoir un assembleur x86 et un environnement capable d'exécuter des programmes en langage d'assemblage. Voici les étapes à suivre pour assembler et exécuter le programme :

1. Assemblez le programme avec votre assembleur préféré. Par exemple, en utilisant NASM :
    ```
    nasm -f elf64 mon_programme.asm -o mon_programme.o
    ```
2. Liez le fichier objet pour créer l'exécutable :
    ```
    ld mon_programme.o -o mon_programme
    ```
3. Exécutez le programme :
    ```
    ./mon_programme
    ```

## Structure du Projet

- **.data section**: Contient toutes les données statiques utilisées par le programme, y compris les menus et messages affichés à l'utilisateur.
- **.text section**: Contient le code exécutable du programme, y compris les procédures pour chaque fonctionnalité.


## Enregistrement d'un employer


## Auteurs

- **Woldemichael Eyosias**
- **Djiakité Madina**

