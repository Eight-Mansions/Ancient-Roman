.psx
.open "cd\Ancient-Roman-Disc-1\CODE.DAT",0x801E1000
	.importobj "code\ancient-roman\obj\text.obj"
	.importobj "code\ancient-roman\obj\font.obj"
	.importobj "code\ancient-roman\obj\generated_movie.obj"
	.importobj "code\ancient-roman\obj\generated_audio.obj"
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
	
CallGetPlaceNameWidth:
	addiu sp, sp, -4
	sw a0, 0(sp)
	
	jal GetPlaceNameWidth
	nop
	
	lw a0, 0(sp)
	jal CountLetters
	addiu sp, sp, 4
	
	j 0x8004b264
	nop
	
SetPlaceNameShadowBoxWidth:
	la v0, locationNameWidth
	lh v0, 0(v0)
	j 0x8004b3a8
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
	
	jal 0x8003d8b8
	addiu sp, sp, 20
	
	
	j 0x800526ac
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
	
	
	j 0x80057e0c
	nop

StoreFrameNumber:
	lw v0, 0x18(sp)
	nop
	lw v0, 8(v0)
	la v1, framenum
	sw v0, 0(v1)
	lw v0, 0x14(sp)
	lui v1, 0x8008
	j 0x800186f8
	lhu v1, 0x54A4(v1)
	
	
DisplayMovieSubs:
	la a2, SubFont
	la a3, framenum
	jal DrawMovieSubtitle
	lw a3, 0(a3)
	
	j 0x80018554
	nop
	
CallIgnoreHiriganaEnglishButtons:
	addiu sp, sp, -4
	sw ra, 0(sp)
	
	jal IgnoreHiriganaEnglishButtons
	nop
	
	lw ra, 0(sp)	
	j 0x8005b8a8
	addiu sp, sp, 4

framenum:
	.dw 0
NumWindowLinesPos:
	.dw 0x8013acd4
cursorPosition:
	.dw 254
audioSubitlesGraphicsList:
	.dw 0
.close

.open "exe\SLPS_011.08",0x8000F800

.definelabel CopyString, 0x80083b78
.definelabel LoadFileIsh, 0x80015f2c
.definelabel LoadImage, 0x80080440
.definelabel FUN_8003dba8, 0x8003dba8
.definelabel PlayMovie, 0x80017f40
.definelabel FUN_8003e238, 0x8003e238
.definelabel EnterCriticalSection, 0x80084fc8
.definelabel ExitCriticalSection, 0x80084fd8
.definelabel AddPrim, 0x8007f60c
.definelabel FUN_8003eb04, 0x8003eb04
.definelabel FUN_8003f958, 0x8003f958
.definelabel lineLength, 0x8010254c
.definelabel lineCount, 0x80102548
.definelabel nameEntryCol, 0x8011638c
.definelabel nameEntryRow, 0x80116390
.definelabel FUN_8003dc00, 0x8003dc00
.definelabel DisplayString, 0x80057d30
.definelabel PlayAudio, 0x800458cc
.definelabel MemoryAllocate, 0x8004590c
.definelabel InitGraphicPrimitives, 0x8003d8b8
.definelabel SetGraphicPrimitives, 0x8003dba8
.definelabel DrawShopGraphics, 0x80057e44
.definelabel DrawBattleGraphics, 0x8004e4e4
.definelabel DrawGraphics, 0x8003dda8
.definelabel AudioIsPlaying1, 0x800b76bc
.definelabel AudioIsPlaying2, 0x800b76c0
.definelabel otag, 0x80122024

.org 0x80019404
	lui a1, 0x801F
	nop

.org 0x80019604
	lui a0, 0x801F
	nop
	
.org 0x80019650
	lui a2, 0x801F
	nop
	
.org 0x800196bc
	lui a2, 0x801F
	nop
	
.org 0x80019750
	lui s0, 0x801F
	nop	
	
.org 0x8001FD28
	lui t1, 0x801F
	nop
	
.org 0x8002695c
	lui s0, 0x801F
	nop

.org 0x80026978
	lui v0, 0x801F
	lw v0, 4(v0)
	lui v1, 0x801F
	lw v1, 8(v1)
	

.org 0x8005006c	; Update x placement of spells/items in battle menu
	li a0,-0x44
	
.org 0x80059828	; Update highlight width of spells/items in battle menu
	li v0, 0x3e
	
.org 0x80059bd4
	addiu v1, v1, -0x1 ; Tweak x placement of highlight for spells/items in battle menu
	
.org 0x8005ade0
	jal DisableVwfOnNamingScreen
	


.org 0x8005b818
	j CallIgnoreHiriganaEnglishButtons
	nop

.org 0x800156c4
	j LoadCodeFile

.org 0x80067258
	nop
	
.org 0x8001f268	; For Dialogue
	jal LoadText
	
.org 0x8001b2f8	; For Shop Title
	jal LoadText

.org 0x8003e28c
	j CallGetSentenceWidthForDialogues
	
.org 0x8003ea00
	jal GetArrowPlacementForDialogue
	
.org 0x8003f274
	la v0, cursorPosition
	lw v1, 0(v0)
	b 0x8003f290
	sll a3, a0, 0x04

.org 0x8003f290
	addu a2, r0, v1
	nop
	nop
	
.org 0x8003ea18
	jal InitDialogueText
	
.org 0x8003f8e4
	jal SetupDialogueText
	
.org 0x8003f910
	jal DisplayDialogueText
	
.org 0x8003dc40
	j CallGetSentenceWidthForMenus

; For cost in shops?	
; .org 0x                             LAB_8003dab4                                    XREF[1]:     8003db84(j)  
        ; 8003dab4 00 00 22 92     lbu        v0,0x0(s1)

	
.org 0x80040368
	lh a3, 0x04(s0)
	jal SetBabyLetterWidths
	
.org 0x800526bc
	jal SetBabyLetterWidths
	
.org 0x80057e1c	; Shop titles
	jal SetBabyLetterWidths
	li a3, 0x1A

.org 0x80052870
	jal SetBabyLetterWidths
	
.org 0x800388c8
	lw v1, 0x1174(v1) ; Increase loading Kai's name to be 8 bytes vs 5

.org 0x800388d0
	sw v1, 0x04(s0)
	
.org 0x8004b25c
	j CallGetPlaceNameWidth

.org 0x8004b3a0
	j SetPlaceNameShadowBoxWidth
	lw a0, 0(v1)
	
.org 0x8004b268
	sll v0, s3, 0x02


.org 0x80052ab4
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Party menu
	
.org 0x80052ac8
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Party menu

.org 0x80052d58
	li v0, 0x0A	; Increase read of characters for names in Party menu
	
.org 0x80053240
	li a2, 0x0A	; Increase read of characters for names in Party menu

.org 0x800531e0
	li a2, 0x0A	; Alow names to be 10 characters  in Party menu



.org 0x80057398
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Battle

.org 0x800573ac
	ori a0, r0, 0x190 ; Increase graphic reserve spots for character names in Battle
	
.org 0x800575e4
	li v0, 0x0A	; Increase read of characters for names in Battle

.org 0x800579f8
	li a2, 0x000A ; Increase read of characters for names in Battle

.org 0x80057a54
	li a2, 0x000A ; Alow names to be 10 characters in Battle
	


.org 0x8004ab1c ; Increase graphic reserve spots for location names on the map
	ori a0 ,r0, 0x560
	ori a0, r0, 0x560

.org 0x8004ab50	; Increase initialzing graphic reserve spots for location names on the map
	ori v0, r0, 0x20
	
.org 0x8004b2bc
	ori a3, r0, 0x20
	
.org 0x8004b30c
	ori a2, r0, 0x20
	
.org 0x8004b384
	ori a2, r0, 0x20
	
.org 0x8004b298
	addu v1, s2, r0 ; Tweak centering of short names
	
.org 0x8004b2c0		; Tweak position of long names
	li v0, 0x125

.org 0x800526a4
	j CallGetHeaderNameCenter

.org 0x80052680
	nop
	
.org 0x80057e04
	j CallGetHeaderNameCenterForShops

.org 0x80057de0
	nop
	


.org 0x80057da8 ; Increase graphic reserve spots for shop names
	ori a0 ,r0, 0x410
	ori a0, r0, 0x410

.org 0x80057dd0	; Increase initialzing graphic reserve spots for shop names
	ori v1, r0, 0x1A

.org 0x80057e94
    ori a2, r0, 0x1A

	



.org 0x80052814	; Increase allowed characters for Gahme for Item shop
	ori a0, r0, 0x100
	ori a0, r0, 0x100
	
.org 0x80052850
	ori v0, r0, 0x5

.org 0x8005293c
	ori a2, r0, 0x5
	
.org 0x8005282c
	addiu s2, 0x0033 ; Tweak position of Gahme

.org 0x800527d4
	addiu a2, s2, 2
	

.org 0x8003fa44	; Hard code copy length (although it will stop once it hits a 0)
	slti v0, t4, 0x39

.org 0x8003e278 ; The compare is set by the script itself which is usually 0x13 and is stored at 0x8013acd6 in memory.  Hopefully this wont break other things ;_;
	slti v0, s3, 0x39

.org 0x8003f8a0 ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x39
	
.org 0x8003f914 ; Increase max line length from 0x1a to 0x26
	addiu a2, r0, 0x39

.org 0x8003f22c		; Initialize our double sized link list
	ori v0, r0, 0x39

.org 0x8003ec00		; Increase linked list for sentences (double the size)
	ori a0,zero,0xC30
    ori a0,zero,0xC30

.org 0x8003dedc		; Update letter dest width
	addiu v1, s2, 0x0F
	
.org 0x8003e348		; Update letter source width
	ori a3, v1, 0x0F
	
.org 0x8003e2d4		; Increase the index for where were at in the string
	addiu s3, s3, 1
	
.org 0x8003f964
	addiu t1, r0, 0
	addiu t0, r0, 0
	
.org 0x8003f9e8
	j CheckForNewline
	nop

.org 0x80045954
	j 0x80045984
	
.org 0x80052668
	jal CountLetters
	
.org 0x80057dc8
	jal CountLetters
	
.org 0x8005ae0c
	jal CountLetters

.org 0x8005ae80
	jal CountLetters
	
.org 0x8005b408
	jal CountLetters
	
.org 0x8005b5b4
	jal CountLetters
	
.org 0x8005b62c
	jal CountLetters

.org 0x8005b644
	jal CountLetters

.org 0x8001a1a4
	jal InitMovieSubtitle
	
.org 0x80015e18
	jal InitMovieSubtitle
	
.org 0x800186ec
	j StoreFrameNumber
	nop
	
.org 0x8001854c
	j DisplayMovieSubs
	


; Shop subtitles
.org 0x8004ed98
	jal InitAudioSubtitle
	
.org 0x8004ee24
	jal InitAudioSubtitle

.org 0x8004f15c
	jal InitAudioSubtitle

.org 0x8004f1b4
	jal InitAudioSubtitle

.org 0x8004f48c
	jal InitAudioSubtitle
	
.org 0x8004e630
	jal DrawShopAudioSubtitle
	
.org 0x8004ec88
	jal DrawShopAudioSubtitle
	
.org 0x8004f8a4
	jal DrawShopAudioSubtitle

.org 0x80052594
	jal DrawShopAudioSubtitle
	
;Battle subtitles
.org 0x80042d24
	jal InitAudioSubtitle
	
 .org 0x8004e458
	jal DrawBattleAudioSubtitle

	
	
; Move stuff that will get overwritten by expanded vram for menus
.org 0x80045a8c
	lui at, 0x8012

.org 0x80045a94
	sw v1, 0x165c(at)

.org 0x80045afc
	lui at, 0x8012
	
.org 0x80045b04
	lw a0, 0x165c(at)
	
.org 0x80045b64
	lui at ,0x8012
	sw v0, 0x161c(at)
	lui at ,0x8012
	sw v1, 0x1618(at)

.org 0x80046154
	lui v1, 0x8012
    lw v1, 0x161c(v1)

.org 0x800460fc
	lui v0, 0x8012
    lw v0, 0x1618(v0)

.org 0x80045bb8
	lui at, 0x8012
	sh v1, 0x1614(at)
	lui at, 0x8012
	sh a1, 0x1610(at)

.org 0x8004624c
	lui a0, 0x8012
    addiu a0, a0, 0x160c
    addiu a1, a0, 0x1640
	
.org 0x8003f9f8
	nop
	
.org 0x8005a92c
	li v0, 0x2E	; Set width of highligh for New Game
	
.org 0x8009db24
	.db 0x10 ; New Game
.org 0x8009db30
	.db 0x10 ; Continue

.org 0x8009daac
	.db 0x10 ; Yes
.org 0x8009dab8
	.db 0x10 ; No

.org 0x8009DB74
	.db 0x10	; Space
.org 0x8009db80
	.db 0x10
.org 0x8009db8c
	.db 0x10
.org 0x8009db98
	.db 0x10	; Confirm
	
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
	
	
.org 0x8009d530
	.db 0x04	; Weapon x position
.org 0x8009d53c
	.db 0x04	; Head x position
.org 0x8009d548
	.db 0x04	; Armor x position
.org 0x8009d554
	.db 0x04	; Shield x position
.org 0x8009d560
	.db 0x04	; Accessory x position
.org 0x8009d56c
	.db 0x04	; Accessory x position
.org 0x8009d578
	.db 0x04	; Accessory x position

.org 0x8009d534
	.db 0x10	; Weapon
.org 0x8009d540
	.db 0x10	; Head
.org 0x8009d54c
	.db 0x10	; Armor
.org 0x8009d558
	.db 0x10	; Shield
.org 0x8009d564
	.db 0x10	; Accessory
.org 0x8009d570
	.db 0x10	; Accessory
.org 0x8009d57c
	.db 0x10	; Accessory
	
.org 0x8009d584
	.db 0x28 ; Equipped Sword x position
.org 0x8009d590
	.db 0x28 ; Equipped Head x position
.org 0x8009d59c
	.db 0x28 ; Equipped Armor x position
.org 0x8009d5a8
	.db 0x28 ; Equipped Shield x position
.org 0x8009d5b4
	.db 0x28 ; Equipped Accessory 1 x position
.org 0x8009d5c0
	.db 0x28 ; Equipped Accessory 2 x position
.org 0x8009d5cc
	.db 0x28 ; Equipped Accessory 3 x position

.org 0x8009d588
	.db 0x10 ; Equipped Sword
.org 0x8009d594
	.db 0x10 ; Equipped Head
.org 0x8009d5a0
	.db 0x10 ; Equipped Armor
.org 0x8009d5ac
	.db 0x10 ; Equipped Shield
.org 0x8009d5b8
	.db 0x10 ; Equipped Accessory 1
.org 0x8009d5c4
	.db 0x10 ; Equipped Accessory 2
.org 0x8009d5d0
	.db 0x10 ; Equipped Accessory 3

.org 0x8009d1cc
	.db 0x10 ; Item 1
.org 0x8009d1d8
	.db 0x10 ; Item 2
.org 0x8009d1e4
	.db 0x10 ; Item 3
.org 0x8009d1f0
	.db 0x10 ; Item 4
.org 0x8009d1fc
	.db 0x10 ; Item 5
.org 0x8009d208
	.db 0x10 ; Item 6
.org 0x8009d214
	.db 0x10 ; Item 7
.org 0x8009d220
	.db 0x10 ; Item 8
.org 0x8009d22C
	.db 0x10 ; Item 9
.org 0x8009d238
	.db 0x10 ; Item 10
.org 0x8009d244
	.db 0x10 ; Item 11
.org 0x8009d250
	.db 0x10 ; Item 12
.org 0x8009d25C
	.db 0x10 ; Item 13
.org 0x8009d268
	.db 0x10 ; Item 14

.org 0x8009d74c
	.db 0x10 ; Item Shop 1
.org 0x8009D770
	.db 0x10 ; Item Shop 1
.org 0x8009D794
	.db 0x10 ; Item Shop 3
.org 0x8009D7B8
	.db 0x10 ; Item Shop 4
.org 0x8009D7DC
	.db 0x10 ; Item Shop 5
.org 0x8009D800
	.db 0x10 ; Item Shop 6
.org 0x8009D824
	.db 0x10 ; Item Shop 7
	
.org 0x8009d0ac
	.db 0x10 ; Menu Spell 1
.org 0x8009D0B8
	.db 0x10 ; Menu Spell 2
.org 0x8009D0C4
	.db 0x10 ; Menu Spell 3
.org 0x8009D0D0
	.db 0x10 ; Menu Spell 4
.org 0x8009D0DC
	.db 0x10 ; Menu Spell 5
.org 0x8009D0E8
	.db 0x10 ; Menu Spell 6
.org 0x8009D0F4
	.db 0x10 ; Menu Spell 7
.org 0x8009D100
	.db 0x10 ; Menu Spell 8
.org 0x8009D10C
	.db 0x10 ; Menu Spell 9
.org 0x8009D118
	.db 0x10 ; Menu Spell 10
.org 0x8009D124
	.db 0x10 ; Menu Spell 11
.org 0x8009D130
	.db 0x10 ; Menu Spell 12
.org 0x8009D13C
	.db 0x10 ; Menu Spell 13
.org 0x8009D148
	.db 0x10 ; Menu Spell 14
.org 0x8009D154
	.db 0x10 ; Menu Spell 15
.org 0x8009D160
	.db 0x10 ; Menu Spell 16
.org 0x8009D16C
	.db 0x10 ; Menu Spell 17
.org 0x8009D178
	.db 0x10 ; Menu Spell 18
.org 0x8009D184
	.db 0x10 ; Menu Spell 19
.org 0x8009D190
	.db 0x10 ; Menu Spell 20
.org 0x8009D19C
	.db 0x10 ; Menu Spell 21

.org 0x8009D8E0
	.db 0x0A ; Battle spell 1 x
.org 0x8009D8E4
	.db 0x10 ; Battle Spell 1
.org 0x8009D8EC
	.db 0x47 ; Battle Spell 2 x
.org 0x8009D8F0
	.db 0x10 ; Battle Spell 2
.org 0x8009D8F8
	.db 0x84 ; Battle Spell 3 x
.org 0x8009D8FC
	.db 0x10 ; Battle Spell 3
.org 0x8009D904
	.db 0x0A ; Battle Spell 4 x
.org 0x8009D908
	.db 0x10 ; Battle Spell 4
.org 0x8009D910
	.db 0x47 ; Battle Spell 5 x
.org 0x8009D914
	.db 0x10 ; Battle Spell 5
.org 0x8009D91C
	.db 0x84 ; Battle Spell 6 x
.org 0x8009D920
	.db 0x10 ; Battle Spell 6
.org 0x8009D928
	.db 0x0A ; Battle Spell 7 x
.org 0x8009D92C
	.db 0x10 ; Battle Spell 7
.org 0x8009D934
	.db 0x47 ; Battle Spell 8 x
.org 0x8009D938
	.db 0x10 ; Battle Spell 8
.org 0x8009D940
	.db 0x84 ; Battle Spell 9 x
.org 0x8009D944
	.db 0x10 ; Battle Spell 9
	
.org 0x8009dad0
	.db 0x30 ; Load from mem 1
.org 0x8009dadc
	.db 0x30 ; Load from mem 2
	
.org 0x8009d884
	.db 0x06	; Attack
.org 0x8009d890
	.db 0x06	; Magic
.org 0x8009d89C
	.db 0x06	; Defend
.org 0x8009d8A8
	.db 0x06	; Item
.org 0x8009d8b4
	.db 0x06	; Run

.org 0x8009D4BC
	.db 0x10
.org 0x8009D4C8
	.db 0x10
.org 0x8009D4D4
	.db 0x10
.org 0x8009D4E0
	.db 0x10
.org 0x8009D4EC
	.db 0x10
.org 0x8009D4F8
	.db 0x10	
.org 0x8009d504
	.db 0x20	; Select a character to
	
.org 0x8009d38c
	.db 0x10	; Michelia

.org 0x8009d988
	.db 0x10
.org 0x8009d994 ; Michelia
	.db 0x10
.org 0x8009D9A0
	.db 0x10




.org 0x8009d754 ; Item cost x position
	.db 0x65
.org 0x8009d778 ; Item cost x position
	.db 0x65
.org 0x8009d79c ; Item cost x position
	.db 0x65
.org 0x8009D7C0 ; Item cost x position
	.db 0x65
.org 0x8009D7E4 ; Item cost x position
	.db 0x65
.org 0x8009D808 ; Item cost x position
	.db 0x65
.org 0x8009D82C ; Item cost x position
	.db 0x65

.org 0x8009d760 ; Gahme x position
	.db 0x97	
.org 0x8009d784
	.db 0x97
.org 0x8009d7a8
	.db 0x97	
.org 0x8009d7cc
	.db 0x97
.org 0x8009d7f0
	.db 0x97
.org 0x8009d814
	.db 0x97
.org 0x8009d838
	.db 0x97
	
.org 0x8009d764 ; Gahme
	.db 0x10	
.org 0x8009d788
	.db 0x10
.org 0x8009d7ac
	.db 0x10	
.org 0x8009d7d0
	.db 0x10
.org 0x8009d7f4
	.db 0x10
.org 0x8009d818
	.db 0x10
.org 0x8009d83c
	.db 0x10
	
	
.org 0x8009d6e4 ; Removed character when selling/buying
	.db 0x00
.org 0x8009d6f0
	.db 0x20 	; How many are you buying/selling?
	
.org 0x8009d9c4	; Update arrow for Loading complete
	.db 0x0C
.org 0x8009d9c3	; Update arrow for No save
	.db 0x13
	
.org 0x800B8500
	.importobj "code\ancient-roman\obj\loadfile.obj"

LoadCodeFile:
	jal LoadFile
	nop
	jal 0x800165e0
	nop
	j 0x800156cc
	
locationNameWidth:
	.dw 0
	
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
	
.org 0x80093208
	.db 0x3A, 0xD1 ; '
	.db 0x3B, 0xD1 ; "	

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