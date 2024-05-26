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
	
CallGetHeaderNameCenterForShops:
	addiu sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)
	sw a1, 8(sp)
	sw a2, 12(sp)
	sw a3, 16(sp)
	
	jal GetHeaderNameCenterForShops
	addu a0, r0, s3
	
	sra a2, s1, 0x10
	addu a2, a2, v0
	
	lw ra, 0(sp)
	lw a0, 4(sp)
	lw a1, 8(sp)
	lw a3, 16(sp)
	
	jal 0x8003d8b8
	addiu sp, sp, 20
	
	
	j 0x80057cc4
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


.org 0x800192bc
	lui a1, 0x801F
	nop

.org 0x800194bc
	lui a0, 0x801F
	nop
	
.org 0x80019508
	lui a2, 0x801F
	nop
	
.org 0x80019574
	lui a2, 0x801F
	nop
	
.org 0x80019608
	lui s0, 0x801F
	nop
	
.org 0x8001fbe0
	lui t1, 0x801F
	nop
	
.org 0x80026814
	lui s0, 0x801F
	nop

.org 0x80026830
	lui v0, 0x801F
	lw v0, 4(v0)
	lui v1, 0x801F
	lw v1, 8(v1)




.org 0x800156bc
	j LoadCodeFile

.org 0x80067110
	nop
	
.org 0x8001f120
	jal LoadText
	
.org 0x8001b1b0
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
	
.org 0x80057cd4	; Shop titles
	jal SetBabyLetterWidths
	li a3, 0x1A
	
.org 0x80052728
	jal SetBabyLetterWidths
	
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
	
.org 0x80057e04
	j CallGetHeaderNameCenterForShops

.org 0x80057de0
	nop
	


.org 0x80057c60 ; Increase graphic reserve spots for shop names
	ori a0 ,r0, 0x410
	ori a0, r0, 0x410

.org 0x80057c88	; Increase initialzing graphic reserve spots for shop names
	ori v1, r0, 0x1A

.org 0x80057d4c
    ori a2, r0, 0x1A

	



.org 0x800526cc	; Increase allowed characters for Gahme for Item shop
	ori a0, r0, 0x100
	ori a0, r0, 0x100
	
.org 0x80052708
	ori v0, r0, 0x5

.org 0x800527f0
	ori a2, r0, 0x5
	
.org 0x800526e4
	addiu s2, 0x0033 ; Tweak position of Gahme

.org 0x8005268c
	addiu a2, s2, 2

	

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
	
.org 0x8009D9DC
	.db 0x10 ; New Game
.org 0x8009D9E8
	.db 0x10 ; Continue

.org 0x8009D964
	.db 0x10 ; Yes
.org 0x8009D970
	.db 0x10 ; No
	
.org 0x8009CEE4
	.db 0x10	; Magic
.org 0x8009CEF0
	.db 0x10	; Status
.org 0x8009CEFC
	.db 0x10	; Item
.org 0x8009CF08
	.db 0x10	; Equipment
.org 0x8009CF14
	.db 0x10	; Party
.org 0x8009CF20
	.db 0x10	; Save
.org 0x8009CF2C
	.db 0x10	; Load
.org 0x8009CF38
	.db 0x10	; Close

.org 0x8009D3EC
	.db 0x10	; Weapon
.org 0x8009D3F8
	.db 0x10	; Head
.org 0x8009D404
	.db 0x10	; Armor
.org 0x8009D410
	.db 0x10	; Shield
.org 0x8009D41C
	.db 0x10	; Accessory
.org 0x8009D428
	.db 0x10	; Accessory
.org 0x8009D434
	.db 0x10	; Accessory

.org 0x8009D440
	.db 0x10 ; Equipped Sword
.org 0x8009D44C
	.db 0x10 ; Equipped Head
.org 0x8009D458
	.db 0x10 ; Equipped Armor
.org 0x8009D464
	.db 0x10 ; Equipped Shield
.org 0x8009D470
	.db 0x10 ; Equipped Accessory 1
.org 0x8009D47C
	.db 0x10 ; Equipped Accessory 2
.org 0x8009D488
	.db 0x10 ; Equipped Accessory 3

.org 0x8009D084
	.db 0x10 ; Item 1
.org 0x8009D090
	.db 0x10 ; Item 2
.org 0x8009D09C
	.db 0x10 ; Item 3
.org 0x8009D0A8
	.db 0x10 ; Item 4
.org 0x8009D0B4
	.db 0x10 ; Item 5
.org 0x8009D0C0
	.db 0x10 ; Item 6
.org 0x8009D0CC
	.db 0x10 ; Item 7
.org 0x8009D0D8
	.db 0x10 ; Item 8
.org 0x8009D0E4
	.db 0x10 ; Item 9
.org 0x8009D0F0
	.db 0x10 ; Item 10
.org 0x8009D0FC
	.db 0x10 ; Item 11
.org 0x8009D108
	.db 0x10 ; Item 12
.org 0x8009D114
	.db 0x10 ; Item 13
.org 0x8009D120
	.db 0x10 ; Item 14
	
.org 0x8009D604
	.db 0x10 ; Item Shop 1
.org 0x8009D610
	.db 0x10 ; Item Shop 1
.org 0x8009D61C
	.db 0x10 ; Item Shop 3
.org 0x8009D628
	.db 0x10 ; Item Shop 4
.org 0x8009D634
	.db 0x10 ; Item Shop 5
.org 0x8009D640
	.db 0x10 ; Item Shop 6
.org 0x8009D64C
	.db 0x10 ; Item Shop 7
	
.org 0x8009CF64
	.db 0x10 ; Menu Spell 1
.org 0x8009CF70
	.db 0x10 ; Menu Spell 2
.org 0x8009CF7C
	.db 0x10 ; Menu Spell 3
.org 0x8009CF88
	.db 0x10 ; Menu Spell 4
.org 0x8009CF94
	.db 0x10 ; Menu Spell 5
.org 0x8009CFA0
	.db 0x10 ; Menu Spell 6
.org 0x8009CFAC
	.db 0x10 ; Menu Spell 7
.org 0x8009CFB8
	.db 0x10 ; Menu Spell 8
.org 0x8009CFC4
	.db 0x10 ; Menu Spell 9
.org 0x8009CFD0
	.db 0x10 ; Menu Spell 10
.org 0x8009CFDC
	.db 0x10 ; Menu Spell 11
.org 0x8009CFE8
	.db 0x10 ; Menu Spell 12
.org 0x8009CFF4
	.db 0x10 ; Menu Spell 13
.org 0x8009D000
	.db 0x10 ; Menu Spell 14
.org 0x8009D00C
	.db 0x10 ; Menu Spell 15
.org 0x8009D018
	.db 0x10 ; Menu Spell 16
.org 0x8009D024
	.db 0x10 ; Menu Spell 17
.org 0x8009D030
	.db 0x10 ; Menu Spell 18
.org 0x8009D03C
	.db 0x10 ; Menu Spell 19
.org 0x8009D048
	.db 0x10 ; Menu Spell 20
.org 0x8009D054
	.db 0x10 ; Menu Spell 21

.org 0x8009D79C
	.db 0x10 ; Battle Spell 1
.org 0x8009D7A8
	.db 0x10 ; Battle Spell 2
.org 0x8009D7B4
	.db 0x10 ; Battle Spell 3
.org 0x8009D7C0
	.db 0x10 ; Battle Spell 4
.org 0x8009D7CC
	.db 0x10 ; Battle Spell 5
.org 0x8009D7D8
	.db 0x10 ; Battle Spell 6
.org 0x8009D7E4
	.db 0x10 ; Battle Spell 7
.org 0x8009D7F0
	.db 0x10 ; Battle Spell 8
.org 0x8009D7FC
	.db 0x10 ; Battle Spell 9
	
.org 0x8009D988
	.db 0x20 ; Load from mem 1
.org 0x8009D994
	.db 0x20 ; Load from mem 2
	
.org 0x8009D73C
	.db 0x06	; Attack
.org 0x8009D748
	.db 0x06	; Magic
.org 0x8009D754
	.db 0x06	; Defend
.org 0x8009D760
	.db 0x06	; Item
.org 0x8009D76C
	.db 0x06	; Run

.org 0x8009D374
	.db 0x10
.org 0x8009D380
	.db 0x10
.org 0x8009D38C
	.db 0x10
.org 0x8009D398
	.db 0x10
.org 0x8009D3A4
	.db 0x10
.org 0x8009D3B0
	.db 0x10	
.org 0x8009D3BC
	.db 0x20	; Select a character to
	
.org 0x8009D244
	.db 0x10	; Michelia

.org 0x8009D840
	.db 0x10
.org 0x8009D84C ; Michelia
	.db 0x10
.org 0x8009D858
	.db 0x10
	
.org 0x8009D61C ; Gahme
	.db 0x10
.org 0x8009D640
	.db 0x10
.org 0x8009D664
	.db 0x10	
.org 0x8009D664
	.db 0x10
.org 0x8009D6AC
	.db 0x10
.org 0x8009D6D0
	.db 0x10
.org 0x8009D6F4
	.db 0x10
	
	
.org 0x8009D59C ; Removed character when selling/buying
	.db 0x00
.org 0x8009D5A8
	.db 0x20 	; How many are you buying/selling?

	
.org 0x800B8500
	.importobj "code\ancient-roman\obj\loadfile2.obj"

LoadCodeFile:
	jal LoadFile
	nop
	jal 0x8003c610
	nop
	j 0x800156c4
	
locationNameWidth:
	.dw 0
	
.org 0x80095FEE		; Updating mappings to allow lowercase
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
	
.org 0x80098BD8
	.db 0x81, 0x8D ; "

.org 0x80098BE2
	.db 0x81, 0x8C ;
	
.org 0x800932AA		; Updating mappings to allow lowercase for small font
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

.org 0x800145E8
	.db 0x82, 0x60
	.db 0x82, 0x61
	.db 0x82, 0x62
	.db 0x82, 0x63
	.db 0x82, 0x64
	.db 0x82, 0x65
	.db 0x82, 0x66
	.db 0x82, 0x67
	.db 0x82, 0x68
	.db 0x82, 0x69
	.db 0x82, 0x6A
	.db 0x82, 0x6B
	.db 0x82, 0x6C
	.db 0x82, 0x6D
	.db 0x82, 0x6E
	.db 0x82, 0x6F
	.db 0x82, 0x70
	.db 0x82, 0x71
	.db 0x82, 0x72
	.db 0x82, 0x73
	.db 0x82, 0x74
	.db 0x82, 0x75
	.db 0x82, 0x76
	.db 0x82, 0x77
	.db 0x82, 0x78
	.db 0x82, 0x79
	.db 0x81, 0x7B
	.db 0x81, 0x7C
	.db 0x81, 0x7E
	.db 0x81, 0x80
	.db 0x82, 0x4F
	.db 0x82, 0x50
	.db 0x82, 0x51
	.db 0x82, 0x52
	.db 0x82, 0x53
	.db 0x82, 0x54
	.db 0x82, 0x55
	.db 0x82, 0x56
	.db 0x82, 0x57
	.db 0x82, 0x58
	.db 0x81, 0x81
	.db 0x81, 0x45
	.db 0x81, 0x49
	.db 0x81, 0x48
	.db 0x81, 0xA4
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
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40
	.db 0x81, 0x40

.close