#include "font.h"

const u8 widths[] = {
	0x03, //  
	0x02, // !
	0x04, // "

	0x08, // #
	0x06, // $
	0x07, // %
	0x06, // &
	
	0x02, // '
	
	0x04, // (
	0x04, // )
	0x04, // *
	0x06, // +

	0x03, // ,

	0x09, // -
	0x03, // .

	0x05, // /

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
	0x06, // =
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
	0x06, // U
	0x08, // V
	0x08, // W
	0x08, // X
	0x08, // Y
	0x08, // Z

	0x05, // [
	0x10, // /
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
	0x08, // ~

};

u8 GetLetterWidth(const u32 letter)
{
	u32 idx = letter - 0x20;
	return widths[idx];
}

u32 x = 0;
u16 GetSentenceWidth(const char* text, u32 curIdx, u8* graphic)
{
	u8 width = 0;
	u16 letter = text[0];
	u8* xpos = graphic - 0x15;

	if (letter != 0)
	{
		if (letter > 0x80)
		{
			letter = (letter << 0x8) + text[1];
			width = 0x0F;
		}
		else
		{
			u32 idx = letter - 0x20;
			width = widths[idx];
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

			u32 width = x + 0x0F;

			((u16*)(xpos + 0x8))[0] = width;
			((u16*)(xpos + 0x18))[0] = width;
		}

		x += width;
	}
	else
	{
		((u16*)xpos)[0] = x;
		((u16*)(xpos + 0x10))[0] = x;

		u32 width = x + 0x0F;

		((u16*)(xpos + 0x8))[0] = width;
		((u16*)(xpos + 0x18))[0] = width;
	}

	return text[0];
}

void SetBabyLetterWidths(POLY_FT4* p1, POLY_FT4* p2, char* text)
{
	int x = 0;
	u16 width = 0;
	int idx = 0;
	//while (true)
	for(int i = 0; i < 5; i++)
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

		letter++;

		if (letter > 0x80)
		{
			idx++;
			x += 0x08;
		}
		else
		{
			x += 0x06;
		}

		idx++;
	}
}