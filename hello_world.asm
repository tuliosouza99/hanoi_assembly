.686
.model flat, stdcall
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
    msg2 db "para torre", 0h
    msg3 db " ", 0ah, 0h
    torre1 dd "1", 0h
    torre2 dd "2", 0h
    torre3 dd "3", 0h
    aux dd ?
    
    write_count dd 0; Variavel para armazenar caracteres escritos na console
    var_write dd ?
    
    orig db 10 dup (?)
    dest db 10 dup (?)

.code

start:

    ; hanoi(n, torre1, torre2, torre3)
    push 0                      ;base da pilha
    push torre3                      ;torre3
    push torre2                      ;torre2
    push torre1                      ;torre1
    push 3                      ;n discos
    call hanoi
    add esp, 8                 ;limpa a pilha
    
    invoke ExitProcess, 0

hanoi:
    push ebp
    mov ebp, esp
    
    mov ebx, [ebp+8]           ;get n
    mov esi, [ebp+12]          ;get torre1
    mov edi, [ebp+16]          ;get torre2
    mov ecx, [ebp+20]          ;get torre3
    
    ; if(n == 1)
    cmp ebx, 1
    je exception

    ; hanoi (n-1, torre1, torre3, torre2)
    push edi
    push ecx
    push esi
    dec ebx
    push ebx
    call hanoi

    pop esi ;pop [ebp+12]
    ;mov aux, esi
    invoke atodw, addr torre1
    invoke dwtoa, eax, addr orig
    pop edi ;pop [ebp+16]
    mov aux, edi
    invoke atodw, addr aux
    invoke dwtoa, eax, addr dest

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg1, sizeof msg1, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr orig, sizeof orig, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg2, sizeof msg2, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr dest, sizeof dest, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg3, sizeof msg3, addr write_count, NULL
    
    ; hanoi(n-1, torre3, torre2, torre1)

    mov ebx, [ebp+8]           ;get n
    mov esi, [ebp+12]          ;get torre1
    mov edi, [ebp+16]          ;get torre2
    mov ecx, [ebp+20]          ;get torre3
    
    push esi
    push edi
    push ecx
    dec ebx
    push ebx
    call hanoi
    
    jmp quit
    
exception:
    
    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg1, sizeof msg1, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr orig, sizeof orig, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg2, sizeof msg2, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr dest, sizeof dest, addr write_count, NULL

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg3, sizeof msg3, addr write_count, NULL
    
kpop:
    pop [ebp+8]
    pop [ebp+12]
    pop [ebp+16]
    pop [ebp+20]



quit:
    mov esp, ebp
    pop ebp
    ret

end start
