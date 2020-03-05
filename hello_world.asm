.686
.model flat,stdcall

option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.data
    msg1 db "uhu", 0ah, 0h
    msg2 db "oi", 0ah, 0h
    
    write_count dd 0; Variavel para armazenar caracteres escritos na console
    var_write dd ?
 
.code

start:

    ; hanoi(n, torre1, torre2, torre3)
    push 3                      ;torre3
    push 2                      ;torre2
    push 1                      ;torre1
    push 4                      ;n discos
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

    ; printf("\nMove o disco %d da torre %c para a torre %c", n, origem, destino)
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg1, sizeof msg1, addr write_count, NULL
    
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
    invoke WriteConsole, var_write, addr msg2, sizeof msg2, addr write_count, NULL

quit:
    mov esp, ebp
    pop ebp
    ret

end start