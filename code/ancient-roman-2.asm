.psx
.open "cd\Ancient-Roman-Disc-2\CODE.DAT",0x801E0000
	.importobj "code\ancient-roman\obj\text.obj"
	.importobj "code\ancient-roman\obj\font.obj"
	.importobj "code\ancient-roman\obj\generated_movie.obj"
	.importobj "code\ancient-roman\obj\subtitle.obj"
SubFont:
	.incbin "graphics\sub_font.bin" ; Font used for subtitles

CheckForNewline:
	lbu t1, 0(a0)
	addiu v0, r0, 0x0A	
	beq v0, t1, isNewLine1
	nop
	
	lbu t0, 1(a0)
	nop
	beq v0, t0, isNewLine2
	nop
	j 0x8003f8ac
	addiu a0, 0x02

isNewLine1:
	j 0x8003f908
	addiu a0, 0x01

isNewLine2:
	sb t1, 0(a3)
	j 0x8003f908
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
	j 0x8003e14c
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
	j 0x8003db00
	lbu v0, 0(s1)
	
CallGetPlaceNameWidth:
	addiu sp, sp, -4
	sw a0, 0(sp)
	
	jal GetPlaceNameWidth
	nop
	
	lw a0, 0(sp)
	jal CountLetters
	addiu sp, sp, 4
	
	j 0x8004b11c
	nop
	
SetPlaceNameShadowBoxWidth:
	la v0, locationNameWidth
	lh v0, 0(v0)
	j 0x8004b260
	nop
	
CallGetHeaderNameCenter:
	addiu sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	
	jal GetHeaderNameCenter
	addu a0, r0, s3
	
	sra a2, s1, 0x10
	addu a2, a2, v0
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a3, 16(sp)
	
	jal 0x8003d770
	addiu sp, sp, 20
	
	
	j 0x80052564
	nop
	
StoreFrameNumber:
	lw v0, 0x18(sp)
	nop
	lw v0, 8(v0)
	la v1, framenum
	sw v0, 0(v1)
	lw v0, 0x14(sp)
	lui v1, 0x8008
	j 0x800185b0
	lhu v1, 0x535C(v1)
	
	
DisplayMovieSubs:
	la a2, SubFont
	la a3, framenum
	jal DrawMovieSubtitle
	lw a3, 0(a3)
	
	j 0x8001840c
	nop

framenum:
	.dw 0
.close

.open "exe\SLPS_011.09",0x8000F800

.definelabel CopyString, 0x80083a30
.definelabel LoadFileIsh, 0x80015f18
.definelabel LoadImage, 0x800802f8
.definelabel FUN_8003dba8, 0x8003da60
.definelabel PlayMovie, 0x80017df8
.definelabel FUN_8003e238, 0x8003e0f0
.definelabel EnterCriticalSection, 0x80084e80
.definelabel ExitCriticalSection, 0x80084e90
.definelabel AddPrim, 0x8007f4c4
.definelabel FUN_8003eb04, 0x8003e9bc



; .org 0x800156c4
	; j LoadCodeFile

; .org 0x80067258
	; nop
	
.org 0x8001f120
	jal LoadText

.org 0x8003e144
	j CallGetSentenceWidthForDialogues
	
.org 0x8003e8d0
	jal InitDialogueText
	
.org 0x8003f79c
	jal SetupDialogueText
	
.org 0x8003f7c8
	jal DisplayDialogueText
	
.org 0x8003daf8
	j CallGetSentenceWidthForMenus
	
.org 0x80040220
	lh a3, 0x04(s0)
	jal SetBabyLetterWidths
	
.org 0x80052574
	jal SetBabyLetterWidths
	
.org 0x80057cd4
	jal SetBabyLetterWidths
	li a3, 0x0D
	
.org 0x80038780
	lw v1, 0x1174(v1) ; Increase loading Kai's name to be 8 bytes vs 5

.org 0x80038788
	sw v1, 0x04(s0)
	
.org 0x8004b114
	j CallGetPlaceNameWidth

.org 0x8004b258
	j SetPlaceNameShadowBoxWidth
	lw a0, 0(v1)
	
.org 0x8004b120
	sll v0, s3, 0x02


.org 0x8005296c
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Party menu
	
.org 0x80052980
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Party menu

.org 0x80052c10
	li v0, 0x0A	; Increase read of characters for names in Party menu
	
.org 0x800530f8
	li a2, 0x0A	; Increase read of characters for names in Party menu

.org 0x80053098
	li a2, 0x0A	; Alow names to be 10 characters  in Party menu



.org 0x80057250
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Battle

.org 0x80057264
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Battle
	
.org 0x8005749c
	li v0, 0x0A	; Increase read of characters for names in Battle

.org 0x800578b0
	li a2, 0x000A ; Increase read of characters for names in Battle

.org 0x8005790c
	li a2, 0x000A ; Alow names to be 10 characters in Battle
	


.org 0x8004a9d4 ; Increase graphic reserve spots for location names on the map
	ori a0 ,r0, 0x560
	ori a0, r0, 0x560

.org 0x8004aa08	; Increase initialzing graphic reserve spots for location names on the map
	ori v0, r0, 0x20
	
.org 0x8004b174
	ori a3, r0, 0x20
	
.org 0x8004b1c4
	ori a2, r0, 0x20
	
.org 0x8004b23c
	ori a2, r0, 0x20
	
.org 0x8004b150
	addu v1, s2, r0 ; Tweak centering of short names
	
.org 0x8004b178		; Tweak position of long names
	li v0, 0x125

.org 0x8005255c
	j CallGetHeaderNameCenter
	
.org 0x80052538
	nop



.org 0x8003f8fc	; Hard code copy length (although it will stop once it hits a 0)
	slti v0, t4, 0x39

.org 0x8003e130 ; The compare is set by the script itself which is usually 0x13 and is stored at 0x8013acd6 in memory.  Hopefully this wont break other things ;_;
	slti v0, s3, 0x39

.org 0x8003f758 ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x39
	
.org 0x8003f7cc ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x39

.org 0x8003f0e4		; Initialize our double sized link list
	ori v0, r0, 0x39

.org 0x8003eab8		; Increase linked list for sentences (double the size)
	ori a0,zero,0xC30
    ori a0,zero,0xC30

.org 0x8003dd94		; Update letter dest width
	addiu v1, s2, 0x0F
	
.org 0x8003e200		; Update letter source width
	ori a3, v1, 0x0F
	
.org 0x8003e18c		; Increase the index for where were at in the string
	addiu s3, s3, 1
	
.org 0x8003f81c
	addiu t1, r0, 0
	addiu t0, r0, 0
	
.org 0x8003f8a0
	j CheckForNewline
	nop

.org 0x8004580c
	j 0x8004583c
	
.org 0x80052520
	jal CountLetters
	
.org 0x80057c80
	jal CountLetters
	
.org 0x8005acc4
	jal CountLetters

.org 0x8005ad38
	jal CountLetters
	
.org 0x8005b2c0
	jal CountLetters
	
.org 0x8005b46c
	jal CountLetters
	
.org 0x8005b4e4
	jal CountLetters

.org 0x8005b4fc
	jal CountLetters

.org 0x8001a05c
	jal InitMovieSubtitle
	
.org 0x80015e04
	jal InitMovieSubtitle
	
.org 0x800185a4
	j StoreFrameNumber
	nop
	
.org 0x80018404
	j DisplayMovieSubs

; Move stuff that will get overwritten by expanded vram for menus
.org 0x80045944
	lui at, 0x8012

.org 0x8004594c
	sw v1, 0x165c(at)

.org 0x800459b4
	lui at, 0x8012
	
.org 0x800459bc
	lw a0, 0x165c(at)
	
.org 0x80045a1c
	lui at ,0x8012
	sw v0, 0x161c(at)
	lui at ,0x8012
	sw v1, 0x1618(at)

.org 0x8004600c
	lui v1, 0x8012
    lw v1, 0x161c(v1)

.org 0x80045fb4
	lui v0, 0x8012
    lw v0, 0x1618(v0)

.org 0x80045a78
	lui at, 0x8012
	sh v1, 0x1614(at)
	lui at, 0x8012
	sh a1, 0x1610(at)

.org 0x80046104
	lui a0, 0x8012
    addiu a0, a0, 0x160c
    addiu a1, a0, 0x1640
	
.org 0x8003f8b0
	nop
	
; .org 0x8009db24
	; .db 0x10 ; New Game
; .org 0x8009db30
	; .db 0x10 ; Continue

; .org 0x8009daac
	; .db 0x10 ; Yes
; .org 0x8009dab8
	; .db 0x10 ; No
	
; .org 0x8009d02c
	; .db 0x10	; Magic
; .org 0x8009d038
	; .db 0x10	; Status
; .org 0x8009d044
	; .db 0x10	; Item
; .org 0x8009d050
	; .db 0x10	; Equipment
; .org 0x8009d05c
	; .db 0x10	; Party
; .org 0x8009d068
	; .db 0x10	; Save
; .org 0x8009d074
	; .db 0x10	; Load
; .org 0x8009d080
	; .db 0x10	; Close

; .org 0x8009d534
	; .db 0x01	; Weapon
; .org 0x8009d540
	; .db 0x01	; Head
; .org 0x8009d54c
	; .db 0x01	; Armor
; .org 0x8009d558
	; .db 0x01	; Shield
; .org 0x8009d564
	; .db 0x01	; Accessory
; .org 0x8009d570
	; .db 0x01	; Accessory
; .org 0x8009d57c
	; .db 0x01	; Accessory

; .org 0x8009d588
	; .db 0x10 ; Equipped Sword
; .org 0x8009d594
	; .db 0x10 ; Equipped Head
; .org 0x8009d5a0
	; .db 0x10 ; Equipped Armor
; .org 0x8009d5ac
	; .db 0x10 ; Equipped Shield
; .org 0x8009d5b8
	; .db 0x10 ; Equipped Accessory 1
; .org 0x8009d5c4
	; .db 0x10 ; Equipped Accessory 2
; .org 0x8009d5d0
	; .db 0x10 ; Equipped Accessory 3

; .org 0x8009d1cc
	; .db 0x10 ; Item 1
; .org 0x8009d1d8
	; .db 0x10 ; Item 2
; .org 0x8009d1e4
	; .db 0x10 ; Item 3
; .org 0x8009d1f0
	; .db 0x10 ; Item 4
; .org 0x8009d1fc
	; .db 0x10 ; Item 5
; .org 0x8009d208
	; .db 0x10 ; Item 6
; .org 0x8009d214
	; .db 0x10 ; Item 7
; .org 0x8009d220
	; .db 0x10 ; Item 8
; .org 0x8009d22C
	; .db 0x10 ; Item 9
; .org 0x8009d238
	; .db 0x10 ; Item 10
; .org 0x8009d244
	; .db 0x10 ; Item 11
; .org 0x8009d250
	; .db 0x10 ; Item 12
; .org 0x8009d25C
	; .db 0x10 ; Item 13
; .org 0x8009d268
	; .db 0x10 ; Item 14
	
; .org 0x8009d74c
	; .db 0x10 ; Item Shop 1
; .org 0x8009D770
	; .db 0x10 ; Item Shop 1
; .org 0x8009D794
	; .db 0x10 ; Item Shop 3
; .org 0x8009D7B8
	; .db 0x10 ; Item Shop 4
; .org 0x8009D7DC
	; .db 0x10 ; Item Shop 5
; .org 0x8009D800
	; .db 0x10 ; Item Shop 6
; .org 0x8009D824
	; .db 0x10 ; Item Shop 7
	
; .org 0x8009d0ac
	; .db 0x10 ; Menu Spell 1
; .org 0x8009D0B8
	; .db 0x10 ; Menu Spell 2
; .org 0x8009D0C4
	; .db 0x10 ; Menu Spell 3
; .org 0x8009D0D0
	; .db 0x10 ; Menu Spell 4
; .org 0x8009D0DC
	; .db 0x10 ; Menu Spell 5
; .org 0x8009D0E8
	; .db 0x10 ; Menu Spell 6
; .org 0x8009D0F4
	; .db 0x10 ; Menu Spell 7
; .org 0x8009D100
	; .db 0x10 ; Menu Spell 8
; .org 0x8009D10C
	; .db 0x10 ; Menu Spell 9
; .org 0x8009D118
	; .db 0x10 ; Menu Spell 10
; .org 0x8009D124
	; .db 0x10 ; Menu Spell 11
; .org 0x8009D130
	; .db 0x10 ; Menu Spell 12
; .org 0x8009D13C
	; .db 0x10 ; Menu Spell 13
; .org 0x8009D148
	; .db 0x10 ; Menu Spell 14
; .org 0x8009D154
	; .db 0x10 ; Menu Spell 15
; .org 0x8009D160
	; .db 0x10 ; Menu Spell 16
; .org 0x8009D16C
	; .db 0x10 ; Menu Spell 17
; .org 0x8009D178
	; .db 0x10 ; Menu Spell 18
; .org 0x8009D184
	; .db 0x10 ; Menu Spell 19
; .org 0x8009D190
	; .db 0x10 ; Menu Spell 20
; .org 0x8009D19C
	; .db 0x10 ; Menu Spell 21

; .org 0x8009D8E4
	; .db 0x10 ; Battle Spell 1
; .org 0x8009D8F0
	; .db 0x10 ; Battle Spell 2
; .org 0x8009D8FC
	; .db 0x10 ; Battle Spell 3
; .org 0x8009D908
	; .db 0x10 ; Battle Spell 4
; .org 0x8009D914
	; .db 0x10 ; Battle Spell 5
; .org 0x8009D920
	; .db 0x10 ; Battle Spell 6
; .org 0x8009D92C
	; .db 0x10 ; Battle Spell 7
; .org 0x8009D938
	; .db 0x10 ; Battle Spell 8
; .org 0x8009D944
	; .db 0x10 ; Battle Spell 9
	
; .org 0x8009dad0
	; .db 0x20 ; Load from mem 1
; .org 0x8009dadc
	; .db 0x20 ; Load from mem 2
	
; .org 0x8009d884
	; .db 0x06	; Attack
; .org 0x8009d890
	; .db 0x06	; Magic
; .org 0x8009d89C
	; .db 0x06	; Defend
; .org 0x8009d8A8
	; .db 0x06	; Item
; .org 0x8009d8b4
	; .db 0x06	; Run

; .org 0x8009D4BC
	; .db 0x10
; .org 0x8009D4C8
	; .db 0x10
; .org 0x8009D4D4
	; .db 0x10
; .org 0x8009D4E0
	; .db 0x10
; .org 0x8009D4EC
	; .db 0x10
; .org 0x8009D4F8
	; .db 0x10	
; .org 0x8009d504
	; .db 0x20	; Select a character to
	
; .org 0x8009d38c
	; .db 0x10	; Michelia

; .org 0x8009d988
	; .db 0x10
; .org 0x8009d994 ; Michelia
	; .db 0x10
; .org 0x8009D9A0
	; .db 0x10

	
; .org 0x800B8500
	; .importobj "code\ancient-roman\obj\loadfile.obj"

; LoadCodeFile:
	; jal LoadFile
	; nop
	; jal 0x800165e0
	; nop
	; j 0x800156cc
	
locationNameWidth:
	.dw 0
	
; .org 0x80096136		; Updating mappings to allow lowercase
	; .db 0x30, 0xD1 ; a
	; .db 0x31, 0xD1 ; b
	; .db 0x32, 0xD1 ; c
	; .db 0x33, 0xD1 ; d
	; .db 0x34, 0xD1 ; e
	; .db 0x35, 0xD1 ; f
	; .db 0x36, 0xD1 ; g
	; .db 0x37, 0xD1 ; h
	; .db 0x38, 0xD1 ; i
	; .db 0x39, 0xD1 ; j
	; .db 0x3A, 0xD1 ; k
	; .db 0x3B, 0xD1 ; l
	; .db 0x3C, 0xD1 ; m
	; .db 0x3D, 0xD1 ; n
	; .db 0x3E, 0xD1 ; o
	; .db 0x3F, 0xD1 ; p
	
	; .db 0x50, 0xD1 ; q
	; .db 0x51, 0xD1 ; r
	; .db 0x52, 0xD1 ; s
	; .db 0x53, 0xD1 ; t
	; .db 0x54, 0xD1 ; u
	; .db 0x55, 0xD1 ; v
	; .db 0x56, 0xD1 ; w
	; .db 0x57, 0xD1 ; x
	; .db 0x58, 0xD1 ; y
	; .db 0x49, 0xD1 ; z
	
; .org 0x80098D20
	; .db 0x81, 0x8D ; "

; .org 0x80098D2A
	; .db 0x81, 0x8C ;
	
; .org 0x800933f2		; Updating mappings to allow lowercase for small font
	; .db 0x20, 0xD1 ; a
	; .db 0x21, 0xD1 ; b
	; .db 0x22, 0xD1 ; c
	; .db 0x23, 0xD1 ; d
	; .db 0x24, 0xD1 ; e
	; .db 0x25, 0xD1 ; f
	; .db 0x26, 0xD1 ; g
	; .db 0x27, 0xD1 ; h
	; .db 0x28, 0xD1 ; i
	; .db 0x29, 0xD1 ; j
	; .db 0x2A, 0xD1 ; k
	; .db 0x2B, 0xD1 ; l
	; .db 0x2C, 0xD1 ; m
	; .db 0x2D, 0xD1 ; n
	; .db 0x2E, 0xD1 ; o
	; .db 0x2F, 0xD1 ; p
	; .db 0x30, 0xD1 ; q
	; .db 0x31, 0xD1 ; r
	; .db 0x32, 0xD1 ; s
	; .db 0x33, 0xD1 ; t
	; .db 0x34, 0xD1 ; u
	; .db 0x35, 0xD1 ; v
	; .db 0x36, 0xD1 ; w
	; .db 0x37, 0xD1 ; x
	; .db 0x38, 0xD1 ; y
	; .db 0x39, 0xD1 ; z

; .org 0x800145E8
	; .db 0x82, 0x60
	; .db 0x82, 0x61
	; .db 0x82, 0x62
	; .db 0x82, 0x63
	; .db 0x82, 0x64
	; .db 0x82, 0x65
	; .db 0x82, 0x66
	; .db 0x82, 0x67
	; .db 0x82, 0x68
	; .db 0x82, 0x69
	; .db 0x82, 0x6A
	; .db 0x82, 0x6B
	; .db 0x82, 0x6C
	; .db 0x82, 0x6D
	; .db 0x82, 0x6E
	; .db 0x82, 0x6F
	; .db 0x82, 0x70
	; .db 0x82, 0x71
	; .db 0x82, 0x72
	; .db 0x82, 0x73
	; .db 0x82, 0x74
	; .db 0x82, 0x75
	; .db 0x82, 0x76
	; .db 0x82, 0x77
	; .db 0x82, 0x78
	; .db 0x82, 0x79
	; .db 0x81, 0x7B
	; .db 0x81, 0x7C
	; .db 0x81, 0x7E
	; .db 0x81, 0x80
	; .db 0x82, 0x4F
	; .db 0x82, 0x50
	; .db 0x82, 0x51
	; .db 0x82, 0x52
	; .db 0x82, 0x53
	; .db 0x82, 0x54
	; .db 0x82, 0x55
	; .db 0x82, 0x56
	; .db 0x82, 0x57
	; .db 0x82, 0x58
	; .db 0x81, 0x81
	; .db 0x81, 0x45
	; .db 0x81, 0x49
	; .db 0x81, 0x48
	; .db 0x81, 0xA4
	; .db 0x82, 0x81 ; a
	; .db 0x82, 0x82 ; b
	; .db 0x82, 0x83 ; c
	; .db 0x82, 0x84 ; d
	; .db 0x82, 0x85 ; e
	; .db 0x82, 0x86 ; f
	; .db 0x82, 0x87 ; g
	; .db 0x82, 0x88 ; h
	; .db 0x82, 0x89 ; i
	; .db 0x82, 0x8a ; j
	; .db 0x82, 0x8b ; k
	; .db 0x82, 0x8c ; l
	; .db 0x82, 0x8d ; m
	; .db 0x82, 0x8e ; n
	; .db 0x82, 0x8f ; o
	; .db 0x82, 0x90 ; p
	; .db 0x82, 0x91 ; q
	; .db 0x82, 0x92 ; r
	; .db 0x82, 0x93 ; s
	; .db 0x82, 0x94 ; t
	; .db 0x82, 0x95 ; u
	; .db 0x82, 0x96 ; v
	; .db 0x82, 0x97 ; w
	; .db 0x82, 0x98 ; x
	; .db 0x82, 0x99 ; y
	; .db 0x82, 0x9a ; z
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40
	; .db 0x81, 0x40

.close