; Assembly Letter Counter
; This program counts the number of letters in a string and displays the result

.model small
.stack 100h
.data
    input db "Hello World! Hello Assembly!", 0  ; String text as an example
    msg db "Total letters counted: $", 0        ; Output message
    total_letters dw 0                          ; Counter for total letters
    output db '00000$', 0                       ; Buffer for the output number

.code
main:
    ; Point to the start of the string text
    lea si, input
    xor ax, @data                 ; Clear AX register to use it for the letter count

next_char:
    lodsb                       ; Load the next character into AL
    cmp al, 0                   ; Is the character null (end of string)?
    je print_result             ; If yes, jump to print the result

    ; Check if the character is a letter
    cmp al, 'A'
    jl not_a_letter             ; If less than 'A', it's not a letter
    cmp al, 'Z'
    jle count_letter            ; If between 'A' and 'Z', count it
    cmp al, 'a'
    jl not_a_letter             ; If less than 'a', it's not a letter
    cmp al, 'z'
    jg not_a_letter             ; If greater than 'z', it's not a letter

count_letter:
    inc ax                      ; Increment total letters count

not_a_letter:
    jmp next_char               ; Process the next character

print_result:
    ; Store the count in total_letters
    mov total_letters, ax

    ; Print the output message
    lea dx, msg
    mov ah, 09h
    int 21h

    ; Convert the total number of letters to a string and print it
    mov ax, total_letters
    call number_to_string

    ; Print the total letters
    lea dx, output
    mov ah, 09h
    int 21h

    ; Exit the program
    mov ax, 4C00h
    int 21h

; Routine to convert number in AX to string in output buffer
number_to_string proc
    mov cx, 5                   ; We're converting a 5-digit number max
    lea di, output              ; Point to the output buffer
    add di, 4                   ; Start from the last digit position
    mov bx, 10                  ; Divisor for decimal conversion

convert_loop:
    xor dx, dx
    div bx                      ; Divide AX by 10, quotient in AX, remainder in DX
    add dl, '0'                 ; Convert remainder to ASCII
    mov [di], dl                ; Store ASCII digit in the buffer
    dec di                      ; Move to the next position
    dec cx                      ; Decrement count
    test ax, ax                 ; Check if quotient is zero
    jnz convert_loop

    ; Fill remaining positions with '0' if necessary
    mov al, '0'
fill_zeroes:
    mov [di], al
    dec di
    loop fill_zeroes

    ret
number_to_string endp

end main