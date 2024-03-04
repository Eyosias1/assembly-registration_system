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

L'enregistrement d'un employer ce fait en plusieurs étapes.
Dans un premier temps nous créant. 
Un espace pour 100 employer. 
``employes: times 1000 db 0`` car nous supposons que un employer au maximum prend 20 octets (``employeSize: equ 20``  ) ceci ce base sur la réaliter pour aussi permettre a une compilation plus rapide.


1. Il faut demander a l'utilisateur de saisir le **nom** et **l'age.**
2. Une fois saisie nous allons vérifier si le nombre d'employer maximum n'est pas atteint. Si oui on affiche un message d'alert et on redirige vers le menu pour utiliser options ou fonctionnalités sinon on calcul le offset pour commencer a charger le nom et age de l'employer.
    ```
    mov al, [nbEmployes]
    imul eax, eax, employeSize
    mov edi, employes
    ```
    Après avoir trouver l'addresse pour charger on boucle et on charge jusqu'a trouver un retour a la ligne ce qui marque la fin de la saisie.
3. Après avoir chargé l'employer on incrémente le nombre d'employer total et on recharge le menu.

## Lister les employés
Pour lister les employé ils nous faut savoir au début le nombre d'employer courrant grace à la fonctionnaliter Enregistrement ensuite ils nous faut un compteur pour boucler tout a long.
1. Dans un premier temps nous comparons si le compteur a atteint le nombre d'employer courant. si atteint nous quittons et nous revenons au menu sinon nous poursuivons.
    ```
        mov al, [compteur]
        mov bl, [nbEmployes]
        cmp al, bl
    ```
2. Nous parcourons notre espace employer et nous affichons le nom et l'age tout en vérifions si le caractère suivant n'est pas un retour a la ligne ce qui marque le prochain employer.
    ```
        mov al, [esi]
        inc esi
        cmp al, 10 
    ```
    Et nous répetons ce processus jusqu'a que le compteur soit égale au nombre d'employer.

## Afficher un employé spécifique
 pas implémenter pour l'instant
## Afficher âge moyen
 pas implémenter pour l'instant
## Auteurs

- **Woldemichael Eyosias**
- **Diakité Madina**

