.686
.model flat,stdcall

option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib

.data
    msg1 db "Move o disco", 0h
    msg2 db " da torre", 0h
    msg3 db " para a torre", 0h
    msg4 db "oie", 0h
    torre1 db "A", 0h
    torre2 db "B", 0h
    torre3 db "C", 0h
    write_count dd 0; Variavel para armazenar caracteres escritos na console
    var_write dd ?
 
.code

start:

    call main
    invoke ExitProcess, 0

main:

    push ebp
    mov ebp, esp
    sub esp, 4
    
    mov dword ptr [ebp-4], 2
    
    push dword ptr [ebp-4]
    push dword ptr torre1
    push dword ptr torre2
    push dword ptr torre3
    call hanoi
    
    
    mov esp, ebp
    pop ebp
    ret 0
    
print:
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr msg1, sizeof msg1, addr write_count, NULL
    
        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr msg2, sizeof msg2, addr write_count, NULL

        invoke GetStdHandle, STD_OUTPUT_HANDLE
        mov var_write, eax
        invoke WriteConsole, var_write, addr msg3, sizeof msg3, addr write_count, NULL
        
        ret

hanoi:

    mov eax, [ebp-4]
    cmp eax, 1
    jne recursivo1
    call print

    ret

recursivo1:
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov var_write, eax
    invoke WriteConsole, var_write, addr msg4, sizeof msg4, addr write_count, NULL
    
    ret
        
end start