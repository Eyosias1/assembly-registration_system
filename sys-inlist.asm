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
newline: db 10  ; newline
espace: db 32 ; espace
inputBufferone: times 2 db 0            ; alloue 2 bytes pour input (chiffre) et pour le saut de ligne   
section .text

global _start

_start:
    call afficherMenu
    call lireChoix
    ; Traiter le choix
    ; cmp eax, 1
    ; je enregistrerEmploye
    ; cmp eax, 2
    ; je listerEmployes
    ; cmp eax, 3
    ;je lireChoixAfficheEmply
    ;cmp eax, 4
    ;je trouverAgeMoyen
    ;cmp eax, 5
    ;je quitterProgramme
    jmp _start

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
