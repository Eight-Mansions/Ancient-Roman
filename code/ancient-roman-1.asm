.psx
.open "exe\SLPS_011.08",0x8000F800

.definelabel CopyString, 0x80083b78

.org 0x80067258
	nop
	
.org 0x8001f268
	jal LoadText
	
.org 0x800B8000
	.importobj "code\ancient-roman\obj\text.obj"

.close