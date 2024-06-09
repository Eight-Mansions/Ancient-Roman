#include "text.h"

#define GetPtr(x)	*((u32*)(x))

void LoadText(char* dest, char* src)
{
	u16* textBoxInfo = (u16*)NumWindowLinesPos;
	if (textBoxInfo[0] == 0xB4 && textBoxInfo[1] == 0x13) // Regular dialogue
		textBoxInfo[0] = 0xA8;

	//if (src[0] == 0x80)
	{
		uint16_t newPos = src[0] | src[1] << 8;
		src = (char*)(0x801F0000 + newPos);
	}

	u32 lineCnt = 1;
	u32 idx = 0;
	while (true)
	{
		u8 c = src[idx++];
		if (c == 0)
			break;

		if (c == 0x0A)
			lineCnt++;
	}

	if (lineCnt > 2)
	{
		textBoxInfo[2] = lineCnt;
	}
	else
	{
		textBoxInfo[2] = 2;
	}

	CopyString(dest, src);
}

u8 CountLetters(char* line)
{
	u8 cnt = 0;
	for (int i = 0; i < 255; i++)
	{
		if (line[i] == 0)
		{
			break;
		}
		else if (line[i] > 0x80)
		{
			i++;
		}

		cnt++;
	}

	return cnt;
}