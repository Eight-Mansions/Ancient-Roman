.psx
.open "cd\Ancient-Roman-Disc-1\CODE.DAT",0x801D0000
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

CallGetSentenceWidth:
	addiu sp, sp, -24
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	sw v1, 20(sp)

	addu a0, r0, s0
	addu a1, r0, s3
	jal GetSentenceWidth
	addu a2, r0, s1
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a2, 12(sp)
	lw a3, 16(sp)
	lw v1, 20(sp)
	j 0x8003e294
	addiu sp, sp, 24
.close

.open "exe\SLPS_011.08",0x8000F800

.definelabel CopyString, 0x80083b78
.definelabel LoadFileIsh, 0x80015f2c


.org 0x800156c4
	j LoadCodeFile

.org 0x80067258
	nop
	
.org 0x8001f268
	jal LoadText
	
.org 0x8003e28c
	j CallGetSentenceWidth


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
	
.org 0x800B8000
	.importobj "code\ancient-roman\debug\loadfile.obj"

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
.close