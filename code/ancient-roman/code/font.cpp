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

u16 GetSentenceWidth(const char* text, u32 curIdx, u8* graphic)
{
	const char* start = text - curIdx;
	u8 letterIdx = 0;
	if (start != text)
	{
		u16 x = 0;
		for (u16 i = 0; i < curIdx; i++)
		{
			u16 letter = start[i];
			if (letter > 0x80)
			{
				letter = (letter << 0x8) + start[i + 1];
				i++;

				x += 0x0F;
			}
			else
			{
				x += GetLetterWidth(letter);
			}

			letterIdx++;
		}

		u8* firstGraphic = (graphic - (0x28 * letterIdx)) - 0x15;
		u32 textX = firstGraphic[0] | firstGraphic[1] << 8;
		textX = textX + x;

		(graphic - 0x15)[0] = textX;
		(graphic - 0x15)[1] = textX >> 8;

		(graphic - 0x05)[0] = textX;
		(graphic - 0x05)[1] = textX >> 8;

		textX += 0x0F;

		(graphic - 0x0D)[0] = textX;
		(graphic - 0x0D)[1] = textX >> 8;

		(graphic + 0x03)[0] = textX;
		(graphic + 0x03)[1] = textX >> 8;

	}

	return text[0];
}