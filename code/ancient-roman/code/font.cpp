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

	u8* xpos1 = graphic - 0x15;
	u8* xpos2 = graphic - 0x05;
	u8* xpos3 = graphic - 0x0D;
	u8* xpos4 = graphic + 0x03;


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
			u8* xPos = graphic - 0x15;
			x = (graphic - 0x15)[0] | (graphic - 0x15)[1] << 8;
		}
		else
		{
			xpos1[0] = x;
			xpos1[1] = x >> 8;

			xpos2[0] = x;
			xpos2[1] = x >> 8;

			xpos3[0] = (x + 0x0F);
			xpos3[1] = (x + 0x0F) >> 8;

			xpos4[0] = (x + 0x0F);
			xpos4[1] = (x + 0x0F) >> 8;
		}

		x += width;
	}
	else
	{
		xpos1[0] = x;
		xpos1[1] = x >> 8;

		xpos2[0] = x;
		xpos2[1] = x >> 8;

		xpos3[0] = (x + 0x0F);
		xpos3[1] = (x + 0x0F) >> 8;

		xpos4[0] = (x + 0x0F);
		xpos4[1] = (x + 0x0F) >> 8;
	}

	return text[0];
}