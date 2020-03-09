.686
.model flat,stdcall

option casemap:none

include   /masm32/include/windows.inc
include   /masm32/include/kernel32.inc
include   /masm32/include/user32.inc
include   /masm32/include/masm32.inc

includelib /masm32/lib/kernel32.lib
includelib /masm32/lib/user32.lib
includelib /masm32/lib/masm32.lib

.data
    msg1 db "Move da torre", 0h
    msg2 db "para a torre", 0h
    quebra_linha db " ", 0ah, 0h ;quebra de linha
    
    write_count dd 0; Variavel para armazenar caracteres escritos na console
    var_write dd ?
    
    indice dd 0
    movimentos dd 126 dup(0)

    v_orig db 2 dup (?)
    v_dest db 2 dup (?)
 
.code

start:

    ; hanoi(n, origem, destino, aux)
    push 2                      ;torre aux
    push 3                      ;torre destino
    push 1                      ;torre origem
    push 6                      ;n discos
    call hanoi

    push -1                     ;base da pilha
    dec indice                  
    mov eax, indice

    ;enquanto o indice do vetor for maior que 0
    laco:
        cmp eax, 0
        jl print
        push movimentos[eax*4]
        dec indice
        mov eax, indice
        
        jmp laco

    print:
        pop esi                 ;origem
        cmp esi, -1
        je fim_prog
        pop edi                 ;destino

        invoke dwtoa, esi, addr v_orig
        invoke dwtoa, edi, addr v_dest
    
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr msg1, sizeof msg1, addr write_count, NULL

        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr v_orig, sizeof v_orig, addr write_count, NULL

        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr msg2, sizeof msg2, addr write_count, NULL

        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr v_dest, sizeof v_dest, addr write_count, NULL

        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr quebra_linha, sizeof quebra_linha, addr write_count, NULL

        jmp print

    fim_prog:
        invoke ExitProcess, 0

hanoi:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8]           ;get n
    mov esi, [ebp+12]          ;get torre origem
    mov edi, [ebp+16]          ;get torre destino
    mov ecx, [ebp+20]          ;get torre aux

    ; if(n == 1)
    cmp ebx, 1
    je exception

    ; hanoi (n-1, origem, aux, destino)
    push edi
    push ecx
    push esi
    dec ebx
    push ebx
    call hanoi

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    
    mov eax, indice
    mov esi, [ebp+12]           ;origem
    mov edi, [ebp+16]           ;destino
    mov movimentos[eax*4], esi  ;Passa origem pro vetor
    inc eax
    mov movimentos[eax*4], edi  ;Passa destino pro vetor
    inc eax
    mov indice, eax
       
    ; hanoi(n-1, aux, destino, origem)
    mov ebx, [ebp+8]           ;get n
    mov esi, [ebp+12]          ;get torre origem
    mov edi, [ebp+16]          ;get torre destino
    mov ecx, [ebp+20]          ;get torre aux
    
    push esi
    push edi
    push ecx
    dec ebx
    push ebx
    call hanoi
    
    jmp quit
    
exception:

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)

    mov eax, indice
    mov movimentos[eax*4], esi ;Passa origem pro vetor
    inc eax
    mov movimentos[eax*4], edi ;Passa destino pro vetor
    inc eax
    mov indice,eax
    
   quit:
    mov esp, ebp
    pop ebp
    ret

end start