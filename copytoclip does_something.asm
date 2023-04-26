.586    
.mmx  
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

ExitProcess PROTO STDCALL, dwExitCode:DWORD

; SYSTEMTIME structure
SYSTEMTIME struct
    wYear      WORD ?
    wMonth     WORD ?
    wDayOfWeek WORD ?
    wDay       WORD ?
    wHour      WORD ?
    wMinute    WORD ?
    wSecond    WORD ?
    wMilliseconds WORD ?
SYSTEMTIME ends

.data
    currentDate db 'YYYYMMDD', 0
    systemTime SYSTEMTIME <>

.code
start:
    ; Open the clipboard
    invoke OpenClipboard, NULL
    test eax, eax
    jz exit

    ; Empty the clipboard
    invoke EmptyClipboard

    ; Get the current system time
    invoke GetSystemTime, ADDR systemTime

    ; Format the date string
    mov ax, word ptr [systemTime.wYear]
    add eax, 30303030h
    bswap eax
    mov dword ptr [currentDate], eax

    movzx eax, word ptr [systemTime.wMonth]
    add eax, 3030h
    xchg al, ah
    mov word ptr [currentDate + 4], ax

    movzx eax, word ptr [systemTime.wDay]
    add eax, 3030h
    xchg al, ah
    mov word ptr [currentDate + 6], ax

    ; Allocate memory for the date string
    invoke GlobalAlloc, GHND, 9
    mov ebx, eax
    test ebx, ebx
    jz close_clipboard

    ; Lock the memory
    invoke GlobalLock, ebx
    mov edi, eax

    ; Copy the date string to the allocated memory
    mov esi, OFFSET currentDate
    mov ecx, 8
    rep movsb

    ; Unlock the memory
    invoke GlobalUnlock, ebx

    ; Set the clipboard data
    invoke SetClipboardData, CF_TEXT, ebx

close_clipboard:
    ; Close the clipboard
    invoke CloseClipboard

exit:
    ; Exit the process
    invoke ExitProcess, 0

end start
