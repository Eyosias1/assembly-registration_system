section .data
menu: db "1. Enregistrer un employé", 10
      db "2. Lister tous Les employés", 10
      db "3. Afficher un employé spécifique", 10
      db "4. Afficher âge moyen", 10
      db "5. Quitter", 10
menuLength: equ $-menu
message_enregistre: db "Enregistrement du personnel :", 10
message_enregistreLength: equ $-message_enregistre
message_nom_Age: db "Nom et Age :", 32
message_nom_AgeLength: equ $-message_nom_Age
message_Id: db "Identifiant :", 32
message_IdLength: equ $-message_Id
message_liste: db "Liste des personnes :", 10
message_listeLength: equ $-message_liste
message_cherche: db "Cherche la personne :", 10
message_chercheLength: equ $-message_cherche
message_alert: db "No such person!", 10
message_alertLength: equ $-message_alert
message_age: db "Age en moyenne :", 10
message_ageLength: equ $-message_age
message_menu_choix: db "Votre choix :", 32
message_menu_choixLength: equ $-message_menu_choix
message_alert_choix: db 9,9,9,"MAUVAISE SAISIE ECRIVER UN CHIFFRE !!! ", 10
message_alert_choixLength: equ $-message_alert_choix
message_alert_max_employer: db 9,9,9,"Nombre max de employer atteint!!! ", 10
message_alert_max_employerLength: equ $-message_alert_max_employer
newline: db 10  ; newline
espace: db 32 ; espace
inputBufferone: times 2 db 0            ; alloue 2 bytes pour input (chiffre) et pour le saut de ligne   
inputBuffer: times 100 db 0             ; Buffer d'entrée pour lire le nom et l'âge     
inputBufferLength: equ $-inputBuffer    ; Longueur du buffer d'entrée
Buffer: times 6 db 0                    ;  Buffer d'entrée pour stocker l'age
BufferLength: equ $-Buffer              ; Longueur du buffer 
compteur: db 0 
compteur_add_spec: db 0                 ; address spécifique en saut
tmp: db 0
value: db 0
exchangeTmp: db 0                       ; variable d'échange entre deux registre
employes: times 1000 db 0               ; Espace pour 100 employés avec 10 octets par employé (exemple simplifié)      
employeSize: equ 20                     ; Taille d'un employé en octets (nom + âge + newline)
maxEmployes: equ 100
nbEmployes: db 0                        ; Nombre actuel d'employés
section .text

global _start

_start:
    call newlinefunc
    call afficherMenu
    call lireChoix
    ; Traiter le choix
    cmp eax, 1
    je enregistrerEmploye
    cmp eax, 2
    je listerEmployes
    ; cmp eax, 3
    ;je lireChoixAfficheEmply
    ;cmp eax, 4
    ;je trouverAgeMoyen
    ;cmp eax, 5
    ;je quitterProgramme
    jmp _start


;/////////////////////////////////////////////
;         fonction neccessaire pour          /
;         Enregistrement d'un employer       /
;                                            /
;/////////////////////////////////////////////

lireChoix:
    call afficheMessageVotre_choix
    mov eax, 3                      ; sys_read
    mov ebx, 0                      ; Descripteur de fichier pour stdin
    mov ecx, inputBufferone         ; Adresse du tampon d'entrée
    mov edx, 2                      ; Nombre d'octets à lire
    int 0x80                        ; Appel au noyau
    mov al, [inputBufferone]        ; Déplace le premier octet dans al
    sub al, '0'                     ; Convertit ASCII en entier
    mov ah, 0                       ; Nettoie ah pour éviter la contamination des données
    ret

enregistrerEmploye:
    call afficherMessageEnre
    call afficheMessageNomAge
    mov al, [nbEmployes]
    cmp al, maxEmployes
    jae finEnregistrement           ; Si on a atteint le maximum, on saute à la fin
    xor eax, eax                    ; Nettoyer EAX (met à zéro tous les bits)
    mov al, [nbEmployes]            ; Remettre le nombre d'employés dans AL (maintenant dans EAX propre)
    imul eax, eax, employeSize      ; EAX = index pour le nouvel employé
    mov edi, employes               ; Charger l'adresse de base du tableau 'employes' dans EDI
    add edi, eax                    ; Ajouter l'offset stocké dans EAX à EDI (edi par convention est pointeur de destination mais on peut utiliser d'autre registre)
    mov eax, 3                      ; sys_read
    mov ebx, 0                      ; stdin
    mov ecx, inputBuffer            ; adresse du buffer d'entrée
    mov edx, 100                    ; nombre maximal d'octets à lire
    int 0x80                        ; appel système
    mov ecx, 100                    ; Supposons max 100 caractères pour le nom et age
    mov esi, inputBuffer            ; Pointeur source vers inputBuffer
    xor eax, eax                    ; Nettoyer eax pour utilisation
    ;TO DOO envoyer caractères max si exeder
    enregistre_emp:                 ; Boucle pour copier le nom caractère par caractère
        cmp ecx, 0
        je fin_en_emp                ; Si le compteur atteint 0, fin de la boucle
        dec ecx                     ; Décrémenter le compteur
        mov al, [esi]               ; Charger le caractère courant dans al
        inc esi                     ; Incrémenter esi pour pointer vers le prochain caractère
        mov [edi], al               ; Stocker le caractère courant à la destination
        inc edi                     ; Incrémenter edi pour la prochaine destination
        cmp al, 10                  ; Vérifier si le caractère courant est un entré
        je fin_en_emp               ; Si c'est un espace, fin de la copie du nom
        jmp enregistre_emp          ; Continuer la boucle
    fin_en_emp:
    inc byte [nbEmployes]           ; Incrémenter le nombre d'employés
    jmp _start
    finEnregistrement:
    call afficheMessage_alert_max_employer
    jmp _start



;/////////////////////////////////////////////
;         fonction neccessaire pour          /
;         lister les employer                /
;                                            /
;/////////////////////////////////////////////


listerEmployes:
    call afficherMessageListe
    mov esi, employes
    boucle_list:
        mov al, [compteur]
        mov bl, [nbEmployes]
        cmp al, bl
        jge fin_boucle_liste
        inc byte [compteur]
        cmp byte [compteur], 2
        jl no_newline
        call newlinefunc
        no_newline:
        mov al, [compteur]
        mov [tmp], al
        call affiche_nombre
        call space_func
        boucle_affichage:
        mov al, [esi]                   ; Charger le caractère courant dans AL
        inc esi                         ; Passer au caractère suivant dans le buffer
        cmp al, 10                      ; Vérifier si nous avons atteint la fin de la chaîne
        je boucle_list                  ; Si c'est la fin, sortir de la boucle
        cmp al, '0'                     ; Vérifier si le caractère est un chiffre ('0')
        jl not_digit                    ; Si AL >= '0', pourrait être un chiffre
        cmp al, '9'                     ; Vérifier si c'est en dessous ou égal à '9'
        jg not_digit                    ; Si AL <= '9', c'est un chiffre, terminer la boucle
        jmp est_chiffre
        not_digit:
            mov [tmp], al
            mov eax, 4                      ; sys_write
            mov ebx, 1
            mov ecx, tmp                    ; Pointeur vers le caractère courant                        ; sys_write nécessite l'adresse du début des données à écrire
            mov edx, 1                      ; Nombre d'octets à écrire
            int 0x80                        ; Appel système pour écrire
        jmp boucle_affichage            ; Continuer la boucle
        est_chiffre:
            mov [tmp], al
            sub byte [tmp], '0'
            call affiche_nombre
        jmp boucle_affichage
    fin_boucle_liste:
    call newlinefunc
    mov byte [compteur], 0          ; mettre le compteur a 0
    jmp _start


affiche_nombre:
    push -1
    mov al, [tmp]
    cmp al, 9
    jle afficher_nb
    divisition:
        mov edx, 0
        mov ecx, 10
        idiv ecx
        push edx
        cmp eax, 9
        jl afficher_nb
    jmp divisition
    afficher_nb:
        mov [tmp], al
        add byte [tmp], '0'
        mov eax, 4                     ; sys_write
        mov ebx, 1                     ; stdout
        mov ecx, tmp
        mov edx, 1
        int 0x80
        pop eax
        cmp eax, -1
    jne afficher_nb
    ret
quitterProgramme:
    mov eax, 1              ; syscall pour quitter
    xor ebx, ebx            ; code de retour 0
    int 0x80                ; interrompre pour quitter

;/////////////////////////////////////////////
;         fonction de affichage de           /
;                  message                   /
;                                            /
;/////////////////////////////////////////////
afficherMenu:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, menu                                   ; Pointeur vers le début du message à afficher
    mov edx, menuLength                             ; Longueur du message à afficher
    int 0x80
    call newlinefunc                                        ; Appeler le kernel Linux
    ret

afficherMessageEnre:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_enregistre                     ; Pointeur vers le début du message à afficher
    mov edx, message_enregistreLength               ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret

afficheMessageVotre_choix:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_menu_choix                                   ; Pointeur vers le début du message à afficher
    mov edx, message_menu_choixLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret
afficheMessageVotre_choix_alert:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_alert_choix                                   ; Pointeur vers le début du message à afficher
    mov edx, message_alert_choixLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret
afficheMessage_alert_max_employer:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_alert_max_employer                                   ; Pointeur vers le début du message à afficher
    mov edx, message_alert_max_employerLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret

afficheMessageNomAge:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_nom_Age                                   ; Pointeur vers le début du message à afficher
    mov edx, message_nom_AgeLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret

afficheMessageID:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_Id                                   ; Pointeur vers le début du message à afficher
    mov edx, message_IdLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret
afficherMessageListe:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_liste                          ; Pointeur vers le début du message à afficher
    mov edx, message_listeLength                    ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    call newlinefunc
    ret

afficherMessageCherche:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_cherche                        ; Pointeur vers le début du message à afficher
    mov edx, message_chercheLength                  ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret
afficherMessageAlert:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_alert                        ; Pointeur vers le début du message à afficher
    mov edx, message_alertLength                  ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    call newlinefunc
    ret

afficherMessageAge:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, message_age                          ; Pointeur vers le début du message à afficher
    mov edx, message_ageLength                    ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    call newlinefunc
    ret

newlinefunc:
    mov eax, 4                      ; sys_write
    mov ebx, 1
    mov ecx, newline                ; Pointeur vers le caractère courant
    mov edx, 1                      ; Nombre d'octets à écrire
    int 0x80
    ret 
space_func:
    mov eax, 4                      ; sys_write
    mov ebx, 1
    mov ecx, espace                 ; Pointeur vers le caractère courant
    mov edx, 1                      ; Nombre d'octets à écrire
    int 0x80
    ret 
