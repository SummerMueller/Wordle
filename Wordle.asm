INCLUDE Irvine32.inc

.data
welcome byte "WORDLE in asm", 0
promptMessage byte "Enter guess: ", 0
gameoverMessage byte "You ran out of guesses :(", 0
winMessage byte "You guessed the word!!", 0
target byte "STONE"
newline byte 13, 10, 0
guess BYTE 6 DUP(0)
colors BYTE 5 DUP(0)

.code
main PROC
mov ebx, 6
call Clrscr

; Prints welcome message
mov edx, offset welcome
call writestring
mov edx, offset newline
call writestring
mov edx, offset newline
call writestring

jmp getinput
afterinput :

jmp printoutput
afteroutput :

jmp checkforwin
nowin :
; Decrements the remaining guess counter
dec ebx
xor eax, eax
cmp ebx, eax
jnz getinput

; Prints the game over message if the user uses all size guesses
mov dl, 0
mov dh, 0
call gotoxy
mov edx, OFFSET gameoverMessage
call WriteString
jmp endprogram

; Reads the input from the bottom of the screen
getinput :
mov dl, 0
mov dh, 29
call gotoxy
mov edx, offset promptMessage
call writestring
mov edx, OFFSET guess
mov ecx, SIZEOF guess
call ReadString
mov esi, offset guess
call toupper
jmp afterinput

; Prints the output
printoutput :
mov esi, offset guess
mov edi, offset target
call compareguess
mov dl, 0
mov dh, 0
call gotoxy
; call debugcolors
call printcolors
mov edx, OFFSET newline
call WriteString
jmp afteroutput

; Checks if the target word was guessed
checkforwin :
mov esi, offset guess
mov edi, offset target
mov ecx, 5
repe cmpsb
jnz nowin
; Prints the win message if the word was found
mov edx, offset newline
call writestring
mov edx, offset newline
call writestring
mov edx, offset winMessage
call writestring

endprogram :
exit
main ENDP


toupper proc
nextchar :
mov al, [esi]
cmp al, 0
je done
cmp al, 'a'
jb skip
cmp al, 'z'
ja skip
sub al, 32
mov[esi], al
skip :
inc esi
jmp nextchar
done :
ret
toupper endp


compareguess proc
pushad

mov esi, offset guess
mov edi, offset target
mov ebx, offset colors
mov ecx, 5

checkgreen:
mov al, [esi]
mov dl, [edi]
cmp al, dl
jne notgreen
mov byte ptr [ebx], 2
jmp next1
notgreen:
mov byte ptr [ebx], 0
next1:
inc esi
inc edi
inc ebx
loop checkgreen

mov esi, offset guess
mov ebx, offset colors
mov ecx, 5

yellowouter:
mov al, [esi]
cmp byte ptr [ebx], 2
je skipyellowouter
mov edi, offset target
mov edx, 5

yellowinner:
mov ah, [edi]
cmp al, ah
jne notyellow
mov byte ptr [ebx], 1
jmp skipyellowouter
notyellow:
inc edi
dec edx
jnz yellowinner

skipyellowouter:
inc esi
inc ebx
loop yellowouter

popad
ret
compareguess endp


printcolors proc
pushad

mov esi, offset guess
mov ebx, offset colors
mov ecx, 5

printloop:
mov dl, [ebx]
cmp dl, 2
je green2
cmp dl, 1
je yellow1
mov eax, 7
jmp setcolor

green2:
mov eax, 10
jmp setcolor
yellow1:
mov eax, 6
setcolor:
call settextcolor
mov al, [esi]
call writechar

inc esi
inc ebx
loop printloop

mov eax, 7
call settextcolor

popad
ret
printcolors endp


DebugColors PROC
pushad; preserve all registers
mov esi, OFFSET colors; start of colors array
mov ecx, 5; number of letters

print_colors_debug :
movzx eax, byte ptr[esi]; load 0, 1, 2 into EAX
call WriteDec; print as decimal

mov al, ' '; print a space between values
call WriteChar

inc esi
loop print_colors_debug

mov edx, OFFSET newline; move to next line after printing
call WriteString

popad
ret
DebugColors ENDP



END main
