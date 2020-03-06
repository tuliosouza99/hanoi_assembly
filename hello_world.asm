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

    v_orig db 2 dup (?)
    v_dest db 2 dup (?)
 
.code

start:

    ; hanoi(n, origem, destino, aux)
    push 2                      ;torre aux
    push 3                      ;torre destino
    push 1                      ;torre origem
    push 4                      ;n discos
    call hanoi
    
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

    pop ebx ;n
    pop esi ;torre origem
    pop edi ;torre destino
    pop ecx ;torre aux

    invoke dwtoa, esi, addr v_orig
    invoke dwtoa, edi, addr v_dest
     
    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    
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

    push ecx ;torre aux
    push edi ;torre destino
    push esi ;torre origem
    push ebx ;n
       
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

    invoke dwtoa, esi, addr v_orig
    invoke dwtoa, edi, addr v_dest
     
    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    
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

quit:
    mov esp, ebp
    pop ebp
    ret

end start