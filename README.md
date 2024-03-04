# Système d'Enregistrement des Employés
Ce programme en langage d'assemblage permet d'enregistrer des employés, de lister tous les employés enregistrés, d'afficher un employé spécifique, de trouver l'age moyen des employés et de quitter le programme.

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
- **Trouver l'age moyen**: Identifie l'age moyen de tous les employés.
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

L'enregistrement d'un employé ce fait en plusieurs étapes.
Dans un premier temps nous allons créer : 
Un espace pour 100 employés. 
``employes: times 1000 db 0`` car nous supposons que un employé au maximum prend 20 octets (``employeSize: equ 20``  ) ceci se base sur la réalité pour aussi permettre une compilation plus rapide.


1. Il faut demander a l'utilisateur de saisir le **nom** et **l'age.**
2. Une fois saisie nous allons vérifier si le nombre d'employé maximum n'est pas atteint. Si oui on affiche un message d'alert et on se  redirige vers le menu pour utiliser les  options ou fonctionnalités sinon on calcul le offset pour commencer à charger le nom et age de l'employé.
    ```
    mov al, [nbEmployes]
    imul eax, eax, employeSize
    mov edi, employes
    ```
    Après avoir trouvé l'addresse pour charger , on boucle et on charge jusqu'a trouver un retour a la ligne ce qui marque la fin de la saisie.
3. Après avoir chargé l'employé on incrémente le nombre d'employé total et on recharge le menu.

## Lister les employés
Pour lister les employés il nous faut savoir au début le nombre d'employés courant grace à la fonctionnalités Enregistrement ensuite il nous faut un compteur pour boucler tout au long.
1. Dans un premier temps nous comparons si le compteur a atteint le nombre d'employés courant. si atteint nous quittons et nous revenons au menu sinon nous poursuivons.
    ```
        mov al, [compteur]
        mov bl, [nbEmployes]
        cmp al, bl
    ```
2. Nous parcourons notre espace employé et nous affichons le nom et l'age tout en vérifiant si le caractère suivant n'est pas un retour a la ligne ce qui marque le prochain employé.
    ```
        mov al, [esi]
        inc esi
        cmp al, 10 
    ```
    Et nous répetons ce processus jusqu'a que le compteur soit égal au nombre d'employés .

## Afficher un employé spécifique
 pas implémenter pour l'instant
## Afficher âge moyen
 pas implémenter pour l'instant
## Quitter le programme
fonctionnalité  implémenter
## Auteurs

- **Woldemichael Eyosias**
- **Diakité Madina**

