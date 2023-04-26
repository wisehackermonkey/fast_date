.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

ExitProcess PROTO STDCALL, dwExitCode:DWORD

.code
start:
    ; Open the clipboard
    invoke OpenClipboard, NULL
    test eax, eax
    jz exit

    ; Empty the clipboard
    invoke EmptyClipboard

    ; Allocate memory for the string
    invoke GlobalAlloc, GHND, 16
    mov ebx, eax
    test ebx, ebx
    jz close_clipboard

    ; Lock the memory
    invoke GlobalLock, ebx
    mov edi,eax
    ; Copy the string to the allocated memory
mov esi, OFFSET helloWorld
mov ecx, 15
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

.data
helloWorld db 'current_date_is',0

end start