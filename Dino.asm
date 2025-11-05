; Dino.asm — manages the dinosaur sprite
; Requires dino.txt containing ASCII art of the dinosaur.

INCLUDE Irvine32.inc
INCLUDE Macros.inc

; Constants
DINO_WIDTH = 31; columns per row
DINO_HEIGHT = 17; number of rows
DINO_SIZE = DINO_WIDTH * DINO_HEIGHT

.data
dinoFilename  BYTE "dino.txt", 0
fileHandle    HANDLE ?
dinoSprite    BYTE DINO_SIZE DUP(? )

.code

; ------------------------------------------------------------
; LoadDino — loads dino.txt into memory
; Returns BL = 1 if successful, 0 otherwise
; ------------------------------------------------------------
LoadDino PROC USES eax ecx edx
mov  edx, OFFSET dinoFilename
call OpenInputFile
mov  fileHandle, eax
cmp  eax, INVALID_HANDLE_VALUE
jne  file_ok
mWrite <"Cannot open dino file", 0dh, 0ah>
mov  bl, 0
jmp  quit

file_ok :
mov  eax, fileHandle
mov  edx, OFFSET dinoSprite
mov  ecx, DINO_SIZE
call ReadFromFile
jc   read_error

mov  bl, 1
jmp  close_file

read_error :
mWrite "Error reading dino file."
call WriteWindowsMsg
mov  bl, 0

close_file :
    mov  eax, fileHandle
    call CloseFile

    quit :
ret
LoadDino ENDP


; ------------------------------------------------------------
; DrawDino — draws the loaded dino sprite at position
; Parameters:
;   AL = top row(Y)
;   BL = left column(X)
; ------------------------------------------------------------
DrawDino PROC USES eax ebx ecx edx esi
mov  esi, OFFSET dinoSprite
mov  ecx, DINO_HEIGHT
mov  dh, al; starting Y
mov  dl, bl; starting X

DrawNextRow :
; Position cursor for this row
call Gotoxy
mov  edx, esi
call WriteString

; Advance sprite pointer to next row
add  esi, DINO_WIDTH
inc  dh
loop DrawNextRow
ret
DrawDino ENDP

END
