INCLUDE Irvine32.inc

.data
welcome byte "WORDLE in asm", 0
promptMessage byte "Enter guess: ", 0
gameoverMessage byte "You ran out of guesses :(", 0
winMessage byte "You guessed the word!!", 0
target byte "STONE"
newline byte 13, 10, 0
guess BYTE 6 DUP(0)

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
mov dl, 0
mov dh, 0
call gotoxy
mov edx, OFFSET guess
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


END main
