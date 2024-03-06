# Système d'Enregistrement des Employés
Ce programme en langage d'assemblage permet d'enregistrer des employés, de lister tous les employés enregistrés, d'afficher un employé spécifique, de trouver l'age moyen des employés et de quitter le programme.

Pour exécuter ce programme, vous devez avoir un assembleur x86 et un environnement capable d'exécuter des programmes en langage d'assemblage. Voici les étapes à suivre pour assembler et exécuter le programme :

1. [Utilisation](#utilisation)
2. [Fonctionnalités](#fonctionnalités)
2. [Structure du projet](#structure-du-projet)
2. [Enregistrement dun employer](#enregistrement-dun-employer)
2. [Lister les employés](#lister-les-employés)
2. [Afficher un employé spécifique](#afficher-un-employé-spécifique)
2. [Afficher âge moyen](#afficher-âge-moyen)




## Utilisation
1. Installer nasm si on a pas fait:
    ```bash
    sudo apt install nasm
    ```
2. Assemblez le programme en utilisant NASM :
    ```bash
    nasm -f elf sys-inlist.asm
    ```
3. Liez le fichier objet pour créer l'exécutable :
    ```bash
     ld -m elf_i386 -o sys-inlist.elf sys-inlist.o
    ```
4. Exécutez le programme :
    ```bash
    ./sys-inlist.elf 
    ```

## Fonctionnalités

- **Enregistrer un employé**: Permet d'ajouter un nouvel employé avec son nom et âge.
- **Lister tous les employés**: Affiche la liste de tous les employés enregistrés.
- **Afficher un employé spécifique**: Recherche un employé par son identifiant.
- **Trouver l'age moyen**: Identifie l'age moyen de tous les employés.
- **Quitter**: Termine l'exécution du programme.



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
    ```asm
    mov al, [nbEmployes]
    imul eax, eax, employeSize
    mov edi, employes
    ```
    Après avoir trouvé l'addresse pour charger , on boucle et on charge jusqu'a trouver un retour a la ligne ce qui marque la fin de la saisie.
3. Après avoir chargé l'employé on incrémente le nombre d'employé total et on recharge le menu.

## Lister les employés
Pour lister les employés il nous faut savoir au début le nombre d'employés courant grace à la fonctionnalités Enregistrement ensuite il nous faut un compteur pour boucler tout au long.
1. Dans un premier temps nous comparons si le compteur a atteint le nombre d'employés courant. si atteint nous quittons et nous revenons au menu sinon nous poursuivons.
    ```asm
        mov al, [compteur]
        mov bl, [nbEmployes]
        cmp al, bl
    ```
2. Nous parcourons notre espace employé et nous affichons le nom et l'age tout en vérifiant si le caractère suivant n'est pas un retour a la ligne ce qui marque le prochain employé.
    ```asm
        mov al, [esi]
        inc esi
        cmp al, 10 
    ```
    Et nous répetons ce processus jusqu'a que le compteur soit égal au nombre d'employés .

## Afficher un employé spécifique

Cette fonctionnalité permet à l'utilisateur de rechercher et d'afficher les informations d'un employé spécifique par son identifiant, qui correspond à l'ordre d'enregistrement de l'employé dans le système (par exemple, le premier employé enregistré a l'identifiant 1, le deuxième a l'identifiant 2, et ainsi de suite).

Pour réaliser cette opération, le programme procède comme suit :

1. **Demande d'Identifiant :** Le programme invite l'utilisateur à saisir l'identifiant de l'employé qu'il souhaite afficher.
   
2. **Validation de la Saisie :** Le programme vérifie que l'identifiant saisi correspond bien à un employé existant. Si l'identifiant est invalide (c'est-à-dire, s'il dépasse le nombre d'employés enregistrés), un message d'erreur est affiché et l'utilisateur est invité à essayer à nouveau.

3. **Recherche de l'Employé :** Le programme parcourt la liste des employés enregistrés jusqu'à trouver celui qui correspond à l'identifiant saisi.

4. **Affichage des Informations :** Une fois l'employé trouvé, le programme affiche son identifiant, son nom et son âge.

### Code d'implémentation

La fonction d'affichage d'un employé spécifique utilise les instructions suivantes pour parcourir la liste des employés et afficher les informations de celui qui correspond à l'identifiant saisi :

```asm
; Supposons que inputBuffer contienne l'identifiant saisi par l'utilisateur
mov esi, inputBuffer  ; Pointeur vers l'identifiant saisi
; Convertit l'identifiant de ASCII en nombre
; Recherche de l'employé
; Affichage des informations
```
#### Cas D'utilisations
Veuillez entrer 
l'identifiant de l'employé : 2  
Nom: John Doe  
Âge: 30 ans


## Afficher Âge Moyen

Cette fonctionnalité vise à identifier l'âge moyen de tous les employés enregistrés dans le système. Elle implique les étapes suivantes :

1. **Calcul de l'Âge Moyen :** Le programme parcourt la liste des employés enregistrés et calcule la somme totale de leurs âges.
    ```asm
        pop ebx
        add [compteur_add_spec], bl
    ```

2. **Diviser par le Nombre d'Employés :** Une fois la somme des âges obtenue, elle est divisée par le nombre total d'employés pour obtenir l'âge moyen.

3. **Affichage du Résultat :** Le programme affiche ensuite l'âge moyen calculé à l'utilisateur.

    ```assembly
    fin_trouverAgeMoyen:
        xor ecx, ecx         ; This sets the entire ecx register to 0
        xor eax, eax         ; This sets the entire ecx register to 0
        xor edx, edx 
        mov cl, [nbEmployes]
        mov al , [compteur_add_spec]
        idiv ecx
        mov [tmp], al
        call afficherMessageAge
        call affiche_nombre
        call newlinefunc
    ```

## Quitter le programme
fonctionnalité  implémenter
## Auteurs

- **Woldemichael Eyosias**
- **Diakité Madina**

Vous pouvez trouver le détaille du code, ainsi que les différentes étapes venant à la conclusion.      
Ici 👉 [link to project](https://github.com/Eyosias1/assembly-registration_system).