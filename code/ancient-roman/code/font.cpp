#include "font.h"

const u8 dialogueLetterWidths[] = {
	0x03, //  
	0x02, // !
	0x04, // "

	0x08, // #
	0x06, // $
	0x07, // %
	0x0A, // &
	
	0x02, // '	
	0x05, // (
	0x05, // )
	0x08, // *
	0x09, // +
	0x03, // ,
	0x09, // -
	0x03, // .
	0x0E, // /
	0x07, // 0
	0x04, // 1
	0x07, // 2
	0x07, // 3
	0x09, // 4
	0x07, // 5
	0x07, // 6
	0x07, // 7
	0x07, // 8
	0x07, // 9
	0x02, // :
	
	0x03, // ;
	0x07, // <
	0x09, // =
	0x07, // >
	
	0x08, // ?

	0x08, // @
	
	0x08, // A
	0x08, // B
	0x08, // C
	0x08, // D
	0x08, // E
	0x08, // F
	0x08, // G
	0x08, // H
	0x02, // I
	0x07, // J
	0x08, // K
	0x07, // L
	0x08, // M
	0x08, // N
	0x08, // O
	0x08, // P
	0x08, // Q
	0x08, // R
	0x08, // S
	0x08, // T
	0x08, // U
	0x08, // V
	0x08, // W
	0x08, // X
	0x08, // Y
	0x08, // Z

	0x05, // [
	0x0E, // /
	0x05, // ]
	0x08, // ^
	0x07, // _
	0x0C, // `

	0x09, // a
	0x09, // b
	0x09, // c
	0x0A, // d
	0x09, // e
	0x07, // f
	0x09, // g
	0x08, // h
	0x02, // i
	0x05, // j
	0x08, // k
	0x02, // l
	0x0C, // m
	0x08, // n
	0x09, // o
	0x09, // p
	0x09, // q
	0x06, // r
	0x08, // s
	0x07, // t
	0x08, // u
	0x0A, // v
	0x0C, // w
	0x08, // x
	0x08, // y
	0x08, // z

	0x04, // {
	0x02, // |
	0x04, // }
	0x0E, // ~

};

const u8 menuLetterWidths[] = {
	0x03, //  
	0x02, // !
	0x04, // "
	0x07, // #
	0x05, // $
	0x06, // %
	0x05, // &
	0x02, // '
	0x03, // (
	0x03, // )
	0x07, // *
	0x05, // +
	0x03, // ,
	0x08, // -
	0x02, // .
	0x05, // /
	0x08, // 0
	0x05, // 1
	0x08, // 2
	0x08, // 3
	0x08, // 4
	0x08, // 5
	0x08, // 6
	0x08, // 7
	0x08, // 8
	0x08, // 9

	0x01, // :
	0x02, // ;
	0x06, // <
	0x05, // =
	0x06, // >
	0x07, // ?
	0x07, // @

	0x05, // A
	0x05, // B
	0x05, // C
	0x05, // D
	0x05, // E
	0x05, // F
	0x05, // G
	0x06, // H
	0x04, // I
	0x05, // J
	0x06, // K
	0x05, // L
	0x06, // M
	0x06, // N
	0x05, // O
	0x05, // P
	0x05, // Q
	0x05, // R
	0x05, // S
	0x06, // T
	0x06, // U
	0x06, // V
	0x06, // W
	0x06, // X
	0x06, // Y
	0x06, // Z

	0x04, // [
	0x0F, // /
	0x04, // ]
	0x07, // ^
	0x06, // _
	0x0B, // `

	0x05, // a
	0x05, // b 
	0x05, // c
	0x05, // d
	0x05, // e
	0x04, // f
	0x05, // g
	0x05, // h
	0x02, // i
	0x03, // j
	0x05, // k
	0x02, // l
	0x06, // m
	0x05, // n
	0x05, // o
	0x05, // p
	0x05, // q
	0x05, // r
	0x05, // s
	0x04, // t
	0x05, // u
	0x05, // v
	0x06, // w
	0x06, // x
	0x05, // y
	0x05, // z
	
	
	0x03, // {
	0x01, // |
	0x03, // }
	0x08, // ~

};

u8 GetLetterWidth(const u32 letter)
{
	u32 idx = letter - 0x20;
	return dialogueLetterWidths[idx];
}

u32 x = 0;
u16 GetSentenceWidth(const char* text, u32 curIdx, u8* graphic, const u8 letterWidths[99], u8 defaultWidth)
{
	u8 width = 0;
	u16 letter = text[0];
	u8* xpos = graphic - 0x15;


	if (!vwfOn)
	{
		width = defaultWidth;
	}
	else if (letter == 0)
	{
		width = defaultWidth;
	}
	else if (letter > 0x80)
	{
		letter = (letter << 0x8) + text[1];
		if (letter == 0x8140) // Uppercase
		{
			width = 3;
		}
		if (letter >= 0x8260 && letter <= 0x8279) // Uppercase
		{
			u32 idx = letter - 0x823F;
			width = letterWidths[idx];
		}
		else if (letter >= 0x8281 && letter <= 0x829A) // Lowecase
		{
			u32 idx = letter - 0x8240;
			width = letterWidths[idx];
		}
		else if (letter >= 0x824F && letter <= 0x8258) // Numbers
		{
			u32 idx = letter - 0x823F;
			width = letterWidths[idx];
		}
		else if (letter == 0x8148) // ?
		{
			u32 idx = letter - 0x8129;
			width = letterWidths[idx];
		}
		else if (letter == 0x8149) // !
		{
			u32 idx = letter - 0x8148;
			width = letterWidths[idx];
		}
		else
		{			
			width = defaultWidth;
		}
	}
	else
	{
		u32 idx = letter - 0x20;
		width = letterWidths[idx];
	}

	if (curIdx == 0)
	{
		x = 0;
		x = ((u16*)xpos)[0];
	}
	else
	{
		((u16*)xpos)[0] = x;
		((u16*)(xpos + 0x10))[0] = x;

		u32 width = x + defaultWidth;

		((u16*)(xpos + 0x8))[0] = width;
		((u16*)(xpos + 0x18))[0] = width;
	}

	x += width;
	//}
	//else
	//{
	//	((u16*)xpos)[0] = x;
	//	((u16*)(xpos + 0x10))[0] = x;

	//	u32 width = x + defaultWidth;

	//	((u16*)(xpos + 0x8))[0] = width;
	//	((u16*)(xpos + 0x18))[0] = width;
	//}

	return text[0];
}

void GetMenuSentenceWidth(const char* text, u32 curIdx, u8* graphic)
{
	GetSentenceWidth(text, curIdx, graphic, menuLetterWidths, 8);
}

void  GetDialogueSentenceWidth(const char* text, u32 curIdx, u8* graphic)
{
	GetSentenceWidth(text, curIdx, graphic, dialogueLetterWidths, 15);
}

void SetBabyLetterWidths(POLY_FT4* p1, POLY_FT4* p2, char* text, ushort length)
{
	FUN_8003dba8(p1, p2, text, 7);

	int x = 0;
	u16 width = 0;
	int idx = 0;
	for(int i = 0; i < length; i++)
	{
		if (idx == 0)
		{
			x = p1->x0;
		}
		else
		{
			p1->x0 = p2->x0 = x;
			p1->x1 = p2->x1 = x + 8;
			p1->x2 = p2->x2 = x;
			p1->x3 = p2->x3 = x + 8;
		}
		
		p1 = (POLY_FT4*)(((u8*)p1) + sizeof(POLY_FT4));
		p2 = (POLY_FT4*)(((u8*)p2) + sizeof(POLY_FT4));
		
		u8 letter = text[idx];
		if (letter == 0)
			break;

		if (letter > 0x80)
		{
			idx++;
			x += 0x08;
		}
		else
		{
			u32 idx = letter - 0x20;
			x += menuLetterWidths[idx];
		}

		idx++;
	}
}

void InitDialogueText(u32 unk1, u32 unk2, u32 unk3, u32 unk4, u32 unk5)
{
	for (int idx = 0; idx < 10; idx++)
	{
		displayedLines[idx] = 0;
	}

	FUN_8003eb04(unk1, unk2, unk3, unk4, unk5);
}

i32 SetupDialogueText(POLY_FT4* p, u8* string, long maxLen, int len, int unk1)
{
	bool found = false;
	
	u8 dIdx = 0;
	for (; dIdx < 10; dIdx++)
	{
		if (displayedLines[dIdx] == 0)
			break;

		if (displayedLines[dIdx] == (u32)p)
		{
			found = true;
			break;
		}
	}

	if (!found)
	{
		FUN_8003e238(p, string, 0x39, 0x39, unk1);

		displayedLines[dIdx] = (u32)p;
	}
	return 0;
}

void DisplayDialogueText(u32* ot, POLY_FT4* p, int maxLen)
{
	EnterCriticalSection();

	for (int i = 0; i < 0x39; i++)
	{
		AddPrim(ot, p);
		p = (POLY_FT4*)(((u8*)p) + sizeof(POLY_FT4));
	}

	ExitCriticalSection();
	
}

void GetPlaceNameWidth(u8* string)
{
	u32 width = 0;
	for (int i = 0; i < 0x20; i++)
	{

		ushort letter = string[i];
		if (letter == 0)
			break;

		if (letter > 0x80)
		{
			letter = (letter << 0x8) + string[i + 1];
			i++;

			if (letter >= 0x8260 && letter <= 0x8279) // Uppercase
			{
				width += dialogueLetterWidths[letter - 0x823F];
			}
			else if (letter >= 0x8281 && letter <= 0x829A) // Lowecase
			{
				width += dialogueLetterWidths[letter - 0x8240];
			}
			else if (letter == 0x8148) // ?
			{
				width += dialogueLetterWidths[letter - 0x8129];
			}
			else if (letter == 0x8149) // !
			{
				width += dialogueLetterWidths[letter - 0x8148];
			}
			else
			{
				width += 15;
			}
		}
		else
		{
			width += dialogueLetterWidths[letter - 0x20];
		}

	}

	locationNameWidth = width + 3;
}

u32 GetHeaderNameCenter(u8* string)
{
	u32 width = 0;
	for (int i = 0; i < 6; i++)
	{

		ushort letter = string[i];
		if (letter == 0)
			break;

		if (letter > 0x80)
		{
			letter = (letter << 0x8) + string[i + 1];
			i++;

			if (letter >= 0x8260 && letter <= 0x8279) // Uppercase
			{
				width += dialogueLetterWidths[letter - 0x823F];
			}
			else if (letter >= 0x8281 && letter <= 0x829A) // Lowecase
			{
				width += dialogueLetterWidths[letter - 0x8240];
			}
			else if (letter == 0x8148) // ?
			{
				width += dialogueLetterWidths[letter - 0x8129];
			}
			else if (letter == 0x8149) // !
			{
				width += dialogueLetterWidths[letter - 0x8148];
			}
			else
			{
				width += 15;
			}
		}
		else
		{
			width += dialogueLetterWidths[letter - 0x20];
		}

	}

	return ((0x34 >> 1) - (width >> 1)) + 0x08; // 0x34 is width of the box
}

u32 GetHeaderNameCenterForShops(u8* string)
{
	u32 width = 0;
	for (int i = 0; i < 0x20; i++)
	{

		ushort letter = string[i];
		if (letter == 0)
			break;

		if (letter > 0x80)
		{
			letter = (letter << 0x8) + string[i + 1];
			i++;

			if (letter >= 0x8260 && letter <= 0x8279) // Uppercase
			{
				width += menuLetterWidths[letter - 0x823F];
			}
			else if (letter >= 0x8281 && letter <= 0x829A) // Lowecase
			{
				width += menuLetterWidths[letter - 0x8240];
			}
			else if (letter == 0x8148) // ?
			{
				width += menuLetterWidths[letter - 0x8129];
			}
			else if (letter == 0x8149) // !
			{
				width += menuLetterWidths[letter - 0x8148];
			}
			else
			{
				width += 15;
			}
		}
		else
		{
			width += menuLetterWidths[letter - 0x20];
		}

	}

	return (0x74 - width) / 2;
}

void GetArrowPlacementForDialogue(u8* string, u32 unk1, u32 unk2)
{
	FUN_8003f958(string, unk1, unk2);

	if (lineCount == 0)
		lineCount++;
}

void IgnoreHiriganaEnglishButtons()
{
	if (nameEntryRow == 4 || nameEntryRow == 5)
	{
		nameEntryRow = (nameEntryRowPrev == 6) ? 3 : 6;
	}
	nameEntryRowPrev = nameEntryRow;

	nameEntryCol = 0x0E;
}

void DisableVwfOnNamingScreen(u32* unk1, u8* unk2, u32 unk3, u32 unk4)
{
	vwfOn = false;
	FUN_8003dc00(unk1, unk2, unk3, unk4);
	vwfOn = true;
}