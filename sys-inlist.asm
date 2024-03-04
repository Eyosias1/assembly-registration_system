section .data
menu: db "1. Enregistrer un employé", 10
      db "2. Lister tous Les employés", 10
      db "3. Afficher un employé spécifique", 10
      db "4. Afficher âge moyen", 10
      db "5. Quitter", 10
menuLength: equ $-menu

section .text

global _start

_start:
    call afficherMenu
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

afficherMenu:
    mov eax, 4                                      ; syscall write
    mov ebx, 1                                      ; fd (file descriptor) pour stdout
    mov ecx, menu                                   ; Pointeur vers le début du message à afficher
    mov edx, menuLength                             ; Longueur du message à afficher
    int 0x80                                        ; Appeler le kernel Linux
    ret