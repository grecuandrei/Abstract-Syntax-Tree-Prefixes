%include "includes/io.inc"

extern getAST
extern freeAST

section .bss; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text; evaluate expresion
eval:
    push ebp
    mov ebp, esp
    xor ecx, ecx
    xor ebx, ebx
    mov ecx, [ebp+8] ; operatia din root
    
    mov eax, [ecx+4]
    mov edx, [eax]
    mov eax, [edx] ; valoarea din stanga
    
    xor edx, edx
    mov edx, [ecx+8]
    mov ebx, [edx]
    mov edx, [ebx] ; valoarea din dreapta
    
    xor ebx, ebx
    mov ebx, [ecx]
    mov ecx, [ebx] ; operatia din root dereferentiata
    
    cmp ecx, 0x2b ; +
    jz plus	
    cmp ecx, 0x2d ; -
    jz minus	
    cmp ecx, 0x2a ; *
    jz mull
    cmp ecx, 0x2f ; /
    jz divv	
plus:
    add eax, edx
    jmp fin
minus:
    sub eax, edx
    jmp fin
mull:
    imul edx
    jmp fin
divv:
    xor ecx, ecx
    mov ecx, edx
    xor edx, edx
    cdq
    idiv ecx
    jmp fin	
fin:
    mov [ebp+8], eax
    leave
    ret

len: ; len of the string
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    xor ecx, ecx    
lop:
    mov bl, byte [eax]
    test bl, bl ; daca a ajuns la terminatorul de sir, se iese din fct
    je out
    inc eax
    inc ecx
    jmp lop    
out:
    leave ; in ecx va fi salvata lungimea
    ret

atoi: ; atoi
    push ebp
    mov ebp, esp
    
    xor ebx, ebx
    mov ebx, dword [ebp+8]
    mov ecx, [ebx]
    xchg ecx, ebx
    
    push ebx
    call len ; calculeaza lungimea stringului
    pop ebx
    xor edx, edx
    
    mov al, byte [ebx] ; daca primul char e -, retine intr-un registru ca nr-ul e negativ
    cmp al, 0x2d
    je negative
    
final:
    xor eax, eax
    mov al, byte [ebx] ; iau fiecare byte
    sub al, 0x30 ; scad pentru a aduce din hex la cifra corespunzatoare
    add edx, eax ; formez numarul
    cmp ecx, 1 ; compar sa nu se termine stringul
    je exit
    xor eax, eax
    mov eax, 10
    mul edx ; inmultesc numarul in dec cu 10
    mov edx, eax
    inc ebx ; muta la charul urm
    dec ecx ; scad lungimea
    jnz final
exit:
    cmp  edi, 1
    je isneg
back1:
    mov [ebp + 8], edx ; salvez rezultatul atoi pe stiva
    leave
    ret
negative:
    xor edi, edi
    mov edi, 1 ; salvez in edi ca numarul de negativ
    inc ebx ; mut la urm char
    dec ecx ; decrementez lungimea
    jmp final
isneg:
    neg edx
    xor edi, edi
    jmp back1

rfunction: ; recursiv function
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]
    push eax ; push adresa root-ului pnetru a fi restaurata mai incolo
    xor edx, edx
    xor ecx, ecx

    mov ebx, [eax+4] ; stg
    cmp dword ebx, 0 ; verifica daca in stanga are copil, daca nu, e frunza
    je frunza
    
    mov ecx, [ebx]
    push ebx
    call rfunction
    add esp, 4
    
    mov eax, [ebp+8]
    xor ebx, ebx
    mov ebx, [eax+8] ; dr
    mov edx, [ebx]
    push ebx
    call rfunction
    add esp, 4

    pop eax
    push eax
    call eval ; in eax va fi valoarea dupa evaluate
    pop ecx
    
    mov edx, [ebp+8]
    mov ecx, [edx]
    mov [ecx], eax ; in ebp+8 trb pusa valoarea lui eax, rezultatul operatiei        
    leave
    ret	
frunza:
    push eax
    call atoi
    pop eax ; valoarea in integer a frunzei
    pop ebx
    mov ecx, [ebx]
    mov [ecx], eax ; muta in locul stringului din frunza, valoarea in integer
    leave
    ret
	
global main
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    push dword [root]	
    xor ebx, ebx
    call rfunction
    pop eax
    mov ebx, [eax]
    mov eax, [ebx]
    PRINT_DEC 4, eax
	
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    leave
    ret