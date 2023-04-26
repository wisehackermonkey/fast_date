.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\msvcrt.lib ; include the C runtime library

.data
    message db 'The current date is: %s',0
    buffer db 11 dup(?) ; buffer for storing the date string

.code
printf proto C :dword, :vararg          ; prototype for the printf function
ExitProcess proto STDCALL :DWORD        ; prototype for the ExitProcess function
OpenClipboard proto :DWORD
EmptyClipboard proto
GetClipboardData proto :DWORD
SetClipboardData proto :DWORD, :DWORD
CloseClipboard proto

main PROC
    LOCAL SystemTime:SYSTEMTIME
    LOCAL hGlobal:DWORD

    ; get the current system time
    invoke GetSystemTime, ADDR SystemTime

    ; format the system time as a date string
    invoke GetDateFormat, LOCALE_USER_DEFAULT, 0, ADDR SystemTime, NULL, ADDR buffer, 11

    ; print the date string to the console using printf
    invoke printf, ADDR message, ADDR buffer

    ; open the clipboard and empty its contents
    invoke OpenClipboard, NULL
    invoke EmptyClipboard

    ; allocate global memory for the buffer contents
    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, SIZEOF buffer
    mov hGlobal, eax ; save handle to allocated memory

    ; lock the allocated memory and copy the buffer contents to it
    invoke GlobalLock, hGlobal
    mov edi, eax
    mov esi, OFFSET buffer
    mov ecx, SIZEOF buffer
    rep movsb

    ; set the clipboard data format and copy the buffer contents to the clipboard
    invoke SetClipboardData, CF_TEXT, hGlobal

    ; unlock the allocated memory and close the clipboard
    invoke GlobalUnlock, hGlobal
    invoke CloseClipboard

    ; exit the program
    invoke ExitProcess, 0
main ENDP

END main
