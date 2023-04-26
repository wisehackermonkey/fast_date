.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\msvcrt.lib ; include the C runtime library


printf proto C :dword, :vararg          ; msvcrt
ExitProcess proto STDCALL :DWORD        ; kernel32


.data
    message db 'The current date is: %s',0
    buffer db 11 dup(?) ; buffer for storing the date string

.code
main PROC
    LOCAL SystemTime:SYSTEMTIME

    ; get the current system time
    invoke GetSystemTime, ADDR SystemTime

    ; format the system time as a date string
    invoke GetDateFormat, LOCALE_USER_DEFAULT, 0, ADDR SystemTime, NULL, ADDR buffer, 11

    ; print the date string to the console using printf
    invoke printf, ADDR message, ADDR buffer

    ; exit the program
    invoke ExitProcess, 0
main ENDP

END main
