	section	.TEXT
    	global	sdiv

sdiv:
	push	ebp
	mov	ebp, esp
	push	edi
	push    ebx
    	push    esi

	mov     esi, [ebp+12]		; contains d buffor
    	mov     ebx, [ebp+16]		; contains divisor

    	mov     eax, -1
    	dec     ebx

count_length1:				; count length of divisor and change chars
    	inc	eax
	inc	ebx
	mov	dl, [ebx]
	cmp     dl, 0           	; count until end of string found
	jz	prepare_before_count
	cmp	dl, 'A'
	jl	count_length1
	sub	BYTE [ebx], 7
	jmp	count_length1


prepare_before_count:
	mov	ecx, -1
    	mov	ebx, [ebp+20]		; contains divident
    	dec	ebx

count_length2:				; count length of divident and change chars
	inc	ebx
	inc	ecx
	mov	dl, [ebx]
	cmp	dl, 0   	        ; count until end of string found
	jz	main
	cmp	dl, 'A'
	jl	count_length2
	sub	BYTE [ebx], 7
	jmp	count_length2

main:
	push	ecx			; push dividend length
	dec	ebx
	push	ebx			; push address of last element

	cmp	eax, ecx    		; compare both lengths
	jl	prepare_d               ; if dividend is longer return

	mov	ebx, [ebp+16]		; contains divisor
	add	ebx, [esp+4]		; move to the place we will subtract to
	dec	ebx			

check_if_end:
	cmp	BYTE [ebx], 0           ; if end of string found, return
	jz	correct_result
	mov	eax, ebx
	sub	eax, [esp+4]		; define interval for operation
	mov	ecx, [ebp+20]		; contains divident
	dec	ebx
	dec	esi

shift_if_zero:				; if first char in interval is 0 shift interval
    	inc	eax			
	inc	ebx
	inc	esi
	cmp     BYTE [ebx], 0           ; if end of string found, return
	jz	correct_result
	cmp	BYTE [eax], '0'
	je	shift_if_zero
	dec	eax
	dec     ecx

compare:
	inc	eax
	inc	ecx
	mov	dl, [eax]
	cmp	dl, [ecx]		; compare divisor char with divident char
	je	compare			
	ja	prepare			; prepare before subtraction

	inc	ebx
	inc	esi
	cmp	BYTE [ebx], 0           ; if end of string found, return
	jz	correct_result

prepare:
    	inc     BYTE [esi]		; increasing result
	mov	ecx, [esp]
	mov	eax, ebx
	mov	edx, [esp+4]		; row counter of magnitude
	mov	edi, ebx

chars:
	mov	bl, [eax]		; contains divisor char
    	mov     bh, [ecx]		; contains divident char

subtract:
	sub	bl, bh
	jge	continue        	; if number >= 0 continue	

	add	bl, [ebp+8]	        ; else add number base
    	dec     BYTE [eax-1]            ; decrement previous char

continue:
    	add	bl, '0'
	mov	BYTE [eax], bl		; put the number back
	dec	eax
	dec	ecx
	dec	edx
	jnz	chars             	; if we subtracted from all numbers, go back to the preparation
	mov	ebx, edi
	cmp	BYTE [eax], '0'
	ja	prepare
	jmp	check_if_end            ; check if we found end of the string

correct_result:				; puts esi to the first char of result
    	mov     esi, [ebp+12]
    	dec     esi

get_char:				; change result into chars
    	inc     esi
    	mov     dl, [esi]           	; check value of the char
    	test    dl, dl
    	jz      prepare_d           	; if end of string found, return
    	cmp     dl, 'A'
    	jge     get_char
    	cmp     dl, '9'             	; if char is bigger than '9', add 7 to it
    	jle     get_char
    	add     BYTE [esi], 7
    	jmp     get_char

prepare_d:                           

	mov     ebx, [ebp+16]		; contains divisor
	dec	ebx
change_chars:				; changes divisor letters back
	inc	ebx
	cmp	BYTE [ebx], 0
	jz	end
	cmp	BYTE [ebx], '9'
	jle	change_chars
	add	BYTE [ebx], 7
	jmp	change_chars

end:					; end and return
	pop	eax
	pop	eax
	pop	esi
	pop	ebx
	pop	edi
	pop	ebp
	ret


;------------------------------

; ESP+4 - length of dividend
; ESP - address to the last element of the divisor
