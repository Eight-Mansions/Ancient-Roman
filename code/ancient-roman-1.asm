.psx
.open "cd\Ancient-Roman-Disc-1\CODE.DAT",0x801E0000
	.importobj "code\ancient-roman\obj\text.obj"
	.importobj "code\ancient-roman\obj\font.obj"

CheckForNewline:
	lbu t1, 0(a0)
	addiu v0, r0, 0x0A	
	beq v0, t1, isNewLine1
	nop
	
	lbu t0, 1(a0)
	nop
	beq v0, t0, isNewLine2
	nop
	j 0x8003f9f4
	addiu a0, 0x02

isNewLine1:
	j 0x8003fa50
	addiu a0, 0x01

isNewLine2:
	sb t1, 0(a3)
	j 0x8003fa50
	addiu a0, 0x02

CallGetSentenceWidthForDialogues:
	addiu sp, sp, -24
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw v1, 20(sp)

	addu a0, r0, s0
	addu a1, r0, s3
	jal GetDialogueSentenceWidth
	addu a2, r0, s1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw v1, 20(sp)
	j 0x8003e294
	addiu sp, sp, 24
	
CallGetSentenceWidthForMenus:
	addiu sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)

	addu a0, r0, s1
	addiu a1, s2, 0xFFFF
	jal GetMenuSentenceWidth
	addu a2, r0, s0
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	addiu sp, sp, 20
	j 0x8003dc48
	lbu v0, 0(s1)
	
	

CallSetBabyLetterWidths:
	addiu sp, sp, -24
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw v1, 20(sp)

	jal SetBabyLetterWidths
	lh a3, 0x04(s0)
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw v1, 20(sp)
	addiu sp, sp, 24
	
	jal 0x8003dba8
	nop
	
	j 0x80040374
.close

.open "exe\SLPS_011.08",0x8000F800

.definelabel CopyString, 0x80083b78
.definelabel LoadFileIsh, 0x80015f2c
.definelabel FUN_8003dba8, 0x8003dba8


.org 0x800156c4
	j LoadCodeFile

.org 0x80067258
	nop
	
.org 0x8001f268
	jal LoadText

;void FUN_8003dc0
;int FUN_8003e238
.org 0x8003e28c
	j CallGetSentenceWidthForDialogues
	
.org 0x8003dc40
	j CallGetSentenceWidthForMenus

.org 0x80040368
	lh a3, 0x04(s0)
	jal SetBabyLetterWidths

.org 0x8003fa44	; Hard code copy length (although it will stop once it hits a 0)
	slti v0, t4, 0x13

.org 0x8003e278 ; The compare is set by the script itself which is usually 0x13 and is stored at 0x8013acd6 in memory.  Hopefully this wont break other things ;_;
	slti v0, s3, 0x26

.org 0x8003f8a0 ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x26
	
.org 0x8003f914 ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x26

.org 0x8003f22c		; Initialize our double sized link list
	ori v0, r0, 0x26

.org 0x8003ec00		; Increase linked list for sentences (double the size)
	ori a0,zero,0x0820
    ori a0,zero,0x0820

.org 0x8003dedc		; Update letter dest width
	addiu v1, s2, 0x0F
	
.org 0x8003e348		; Update letter source width
	ori a3, v1, 0x0F
	
.org 0x8003e2d4		; Increase the index for where were at in the string
	addiu s3, s3, 1
	
.org 0x8003f964
	addiu t1, r0, 0x20
	addiu t0, r0, 0x20
	
.org 0x8003f9e8
	j CheckForNewline
	nop
	
.org 0x8003f9f8
	nop
	
.org 0x8009db24
	.db 0x10 ; New Game
.org 0x8009db30
	.db 0x10 ; Continue

.org 0x8009daac
	.db 0x10 ; Yes
.org 0x8009dab8
	.db 0x10 ; No
	
.org 0x8009d02c
	.db 0x10	; Magic
.org 0x8009d038
	.db 0x10	; Status
.org 0x8009d044
	.db 0x10	; Item
.org 0x8009d050
	.db 0x10	; Equipment
.org 0x8009d05c
	.db 0x10	; Party
.org 0x8009d068
	.db 0x10	; Save
.org 0x8009d074
	.db 0x10	; Load
.org 0x8009d080
	.db 0x10	; Close

.org 0x8009d534
	.db 0x01	; Weapon
.org 0x8009d540
	.db 0x01	; Head
.org 0x8009d54c
	.db 0x01	; Armor
.org 0x8009d558
	.db 0x01	; Shield
.org 0x8009d564
	.db 0x01	; Accessory
.org 0x8009d570
	.db 0x01	; Accessory
.org 0x8009d57c
	.db 0x01	; Accessory

.org 0x8009d588
	.db 0x20 ; Equipped Sword
.org 0x8009d594
	.db 0x20 ; Equipped Head
.org 0x8009d5a0
	.db 0x20 ; Equipped Armor
.org 0x8009d5ac
	.db 0x20 ; Equipped Shield
.org 0x8009d5b8
	.db 0x20 ; Equipped Accessory 1
.org 0x8009d5c4
	.db 0x20 ; Equipped Accessory 2
.org 0x8009d5d0
	.db 0x20 ; Equipped Accessory 3


	
; ; .org 0x8009d38c
	; ; .db 0x10
; ; .org 0x8009d3a4
	; ; .db 0x10
; ; .org 0x8009d3bc
	; ; .db 0x10
; ; .org 0x8009d3d4
	; ; .db 0x10
; ; .org 0x8009d3ec
	; ; .db 0x10
; .org 0x8009d3f8
	; .db 0x10	; Level
; .org 0x8009d410
	; .db 0x10	; EXP
; .org 0x8009d428
	; .db 0x10	; Next
; ; .org 0x8009d434
	; ; .db 0x10
; ; .org 0x8009d442
	; ; .db 0x10
; ; .org 0x8009d44e
	; ; .db 0x10

	
.org 0x800B8500
	.importobj "code\ancient-roman\obj\loadfile.obj"

LoadCodeFile:
	jal LoadFile
	nop
	jal 0x800165e0
	nop
	j 0x800156cc
	
.org 0x80096136		; Updating mappings to allow lowercase
	.db 0x30, 0xD1 ; a
	.db 0x31, 0xD1 ; b
	.db 0x32, 0xD1 ; c
	.db 0x33, 0xD1 ; d
	.db 0x34, 0xD1 ; e
	.db 0x35, 0xD1 ; f
	.db 0x36, 0xD1 ; g
	.db 0x37, 0xD1 ; h
	.db 0x38, 0xD1 ; i
	.db 0x39, 0xD1 ; j
	.db 0x3A, 0xD1 ; k
	.db 0x3B, 0xD1 ; l
	.db 0x3C, 0xD1 ; m
	.db 0x3D, 0xD1 ; n
	.db 0x3E, 0xD1 ; o
	.db 0x3F, 0xD1 ; p
	
	.db 0x50, 0xD1 ; q
	.db 0x51, 0xD1 ; r
	.db 0x52, 0xD1 ; s
	.db 0x53, 0xD1 ; t
	.db 0x54, 0xD1 ; u
	.db 0x55, 0xD1 ; v
	.db 0x56, 0xD1 ; w
	.db 0x57, 0xD1 ; x
	.db 0x58, 0xD1 ; y
	.db 0x49, 0xD1 ; z
	
.org 0x80098D20
	.db 0x81, 0x8D ; "

.org 0x80098D2A
	.db 0x81, 0x8C ;
	
.org 0x800933f2		; Updating mappings to allow lowercase for small font
	.db 0x20, 0xD1 ; a
	.db 0x21, 0xD1 ; b
	.db 0x22, 0xD1 ; c
	.db 0x23, 0xD1 ; d
	.db 0x24, 0xD1 ; e
	.db 0x25, 0xD1 ; f
	.db 0x26, 0xD1 ; g
	.db 0x27, 0xD1 ; h
	.db 0x28, 0xD1 ; i
	.db 0x29, 0xD1 ; j
	.db 0x2A, 0xD1 ; k
	.db 0x2B, 0xD1 ; l
	.db 0x2C, 0xD1 ; m
	.db 0x2D, 0xD1 ; n
	.db 0x2E, 0xD1 ; o
	.db 0x2F, 0xD1 ; p
	.db 0x30, 0xD1 ; q
	.db 0x31, 0xD1 ; r
	.db 0x32, 0xD1 ; s
	.db 0x33, 0xD1 ; t
	.db 0x34, 0xD1 ; u
	.db 0x35, 0xD1 ; v
	.db 0x36, 0xD1 ; w
	.db 0x37, 0xD1 ; x
	.db 0x38, 0xD1 ; y
	.db 0x39, 0xD1 ; z
	
.org 0x800144ea		; Adding lower case letters to naming screen 
	.db 0x82, 0x81 ; a
	.db 0x82, 0x82 ; b
	.db 0x82, 0x83 ; c
	.db 0x82, 0x84 ; d
	.db 0x82, 0x85 ; e
	.db 0x82, 0x86 ; f
	.db 0x82, 0x87 ; g
	.db 0x82, 0x88 ; h
	.db 0x82, 0x89 ; i
	.db 0x82, 0x8a ; j
	.db 0x82, 0x8b ; k
	.db 0x82, 0x8c ; l
	.db 0x82, 0x8d ; m
	.db 0x82, 0x8e ; n
	.db 0x82, 0x8f ; o
	.db 0x82, 0x90 ; p
	.db 0x82, 0x91 ; q
	.db 0x82, 0x92 ; r
	.db 0x82, 0x93 ; s
	.db 0x82, 0x94 ; t
	.db 0x82, 0x95 ; u
	.db 0x82, 0x96 ; v
	.db 0x82, 0x97 ; w
	.db 0x82, 0x98 ; x
	.db 0x82, 0x99 ; y
	.db 0x82, 0x9a ; z

.close