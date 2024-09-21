; routine to read and store integers in memory mapper pages
; to store a value in a mapper: _usr0("VFFFF,FF33"), where 
; - the first char is a capital letter V..Z
; - then the index in the array in capital hex
; - a seperator that determines the end of the hex value, aka something that can't be used as an HEX digit :-)
; - then the 16bit value to store
;
; to read a value in a mapper: _usr1("VFFFF"), where 
; - the first char is a capital letter V..Z
; - then the index in the array 
;
;
; So you can do in basic _USR0("U"+hex$(c)+","+hex$(v))

DAC	equ 0xF7F6 ; 8 bytes containing the data of the variable
VALTYP	equ 0xF663 ; 1 byte indicate the type of variable in DAC
		;VALTYP can be
		; 2 = Integer
		;	DAC byte 0+1 is the 16bits integer
		; 3 = String
		;   DAC byte 2+3 is pointer to string descriptor
		;	  descriptor byte 0 is number of chars
		;	  descriptor byte 1+2 pointer to string storage
		; 4 = Single precision
		;	DAC byte 0+1+2+3 single precision real number
		; 8 = Double precision
		;	DAC byte 0..7 double precision real number


	org 0xd800

	jr store

retrieve:
	call set_mmpage_get_indx_ptr
	ld e,(hl)	; read 16bit value at indx_ptr
	inc hl
	ld d,(hl)
	ld (DAC+2),de	; store in DAC
	ld a,2
	ld (VALTYP),a	; set return type to int
	jr back2basic

store:
	call set_mmpage_get_indx_ptr
	push hl
	call converthex
	ex de,hl
	pop hl
	ld (hl),e
	inc hl
	ld (hl),d
back2basic:
	ld a,1
	out (0xFE),a
	ei
	ret

set_mmpage_get_indx_ptr:
	; get string pointer to interprete
	; no input validation simply assume it is a string...
	ld hl,(DAC+2)

	ld b,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	ld a,(hl)
	dec b
	sub a,'V'-3 ; =>V=3,W=4,X=5,Y=6,Z=7
	di
	out (#FE),a
	inc hl
	ex de,hl
	call converthex
	; hl is index read from string so convert to pointer in range 0x8000-0xBFFF
	add hl,hl ; 2 bytes per index!
	ld a,0x3F
	and h
	or 128
	ld h,a
	ret


converthex:
	ld hl,0
.loop:
	; if no characters left we return
	ld a,b
	or a
	ret z

	; otherwise get the next character 
	; and adjust pointer and counter
	ld a,(de)
	inc de
	dec b

	; check if it is a valid hex digit '0-9A-F'
	sub a,'0'
	ret c ;end of convertion
	cp 10
	jr c,.addvalue
	sub a,7
	cp 16
	ret nc ;end of convertion
.addvalue:	; digit is now in A
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	push de
	ld d,0
	ld e,a
	add hl,de
	pop de
	jr .loop


