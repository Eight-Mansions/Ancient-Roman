#include "font.h"

const u8 widths[] = {
	0x0A, // 0
	0x05, // 1
	0x0A, // 2
	0x0B, // 3
	0x0b, // 4
	0x0A, // 5
	0x0A, // 6
	0x0A, // 7
	0x0B, // 8
	0x0A, // 9
	0x00, // 0x59
	0x00, // 0x5A
	0x00, // 0x5B
	0x00, // 0x5C
	0x00, // 0x5D
	0x00, // 0x5E
	0x00, // 0x5F, I hate them skipping around...
	0x0B, // A
	0x0A, // B
	0x0B, // C
	0x0A, // D
	0x09, // E
	0x09, // F
	0x0B, // G
	0x0A, // H
	0x03, // I
	0x09, // J
	0x0A, // K
	0x0A, // L
	0x0C, // M
	0x0A, // N
	0x0B, // O
	0x0A, // P
	0x0B, // Q
	0x0A, // R
	0x0A, // S
	0x0B, // T
	0x0A, // U
	0x0B, // V
	0x0D, // W
	0x0A, // X
	0x0B, // Y
	0x0A, // Z
	0x00, // 0x7A
	0x00, // 0x7B
	0x00, // 0x7C
	0x00, // 0x7D
	0x00, // 0x7E
	0x00, // 0x7F
	0x00, // 0x80
	0x09, // a
	0x09, // b
	0x08, // c
	0x09, // d
	0x09, // e
	0x07, // f
	0x09, // g
	0x08, // h
	0x03, // i
	0x05, // j
	0x08, // k
	0x03, // l
	0x0B, // m
	0x08, // n
	0x09, // o
	0x09, // p
	0x09, // q
	0x07, // r
	0x08, // s
	0x07, // t
	0x08, // u
	0x09, // v
	0x0B, // w
	0x08, // x
	0x09, // y
	0x08, // z
	0x00, // 0x9B
	0x00, // 0x9C
	0x00, // 0x9D
	0x00, // 0x9E
	0x05, // space
	0x04, // ,
	0x03, // .
	0x04, // :
	0x04, // ;
	0x09, // ?
	0x04, // !
	0x05, // "
	0x05, // -
	0x04, // '
	0x06, // (
	0x06, // )
	0x0B, // +
	0x0B, // =
	0x0B, // /
	0x0D, // triangle
	0x0D, // square
	0x0A, // 0
	0x05, // 1
	0x0A, // 2
	0x0B, // 3
	0x0b, // 4
	0x00, // ^

};

u32 GetLetter(u8* text, u8* stackey)
{
	u32 increaseBy = 0;

	u32 letter = text[0];
	if (letter < 0x80 && letter >= 20)
	{
		letter += 0x823f;
	}
	else
	{
		letter = letter << 8 | text[1] & 0xFF;
		increaseBy++;
	}

	stackey[0] = letter >> 8;
	stackey[1] = letter & 0xFF;

	return increaseBy;
}

int GetLetterWidth(const u32 letter)
{
	if (letter >= 0x10 && letter <= 80)
	{
		u32 idx = letter - 0x10;
		return widths[idx];
	}
	else if (letter >= 0x824F && letter <= 0x82B5)
	{
		u32 idx = letter - 0x824F;
		return widths[idx];
	}
	else
	{
		return 0x0F;
	}
}

int GetSentenceWidth(const char* text, u32 length)
{
	int textWidth = 0;
	for (int i = 0; i < length; i++) // There is also a check for <$09> but not sure what that does... maybe breaks too?
	{
		int letter = 0;
		
		if (text[i] == 0x0A || text[i] == 0x00)
			break;

		if (text[i] > 0x80)
		{  letter = (text[i] << 0x8) + text[i + 1];
			i++;
		}
		else
		{
			letter = text[i] + 0x823F;
		}

		textWidth += GetLetterWidth(letter);
	}
	return textWidth;
}

int GetYForCentering(const char* text, u32 length)
{
	u32 textwidth = GetSentenceWidth(text, length);

	return (int)((256 >> 1) - (textwidth >> 1)); // 256 is the width of text box texture
}

void StringCopy(char* source, char* dest)
{
	int idx = 0;
	while (true)
	{
		dest[idx] = source[idx];
		if (source[idx] == 0)
			break;
		idx++;
	}
}

u32 GetPropperPuzzleLength(const char* text)
{
	int cnt = 0;
	while (true)
	{
		if (text[cnt] == 0)
			break;
		cnt++;
	}

	if (cnt % 2 != 0)
		cnt++;

	return cnt;
}