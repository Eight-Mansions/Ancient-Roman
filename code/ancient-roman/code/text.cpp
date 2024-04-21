#include "text.h"

void LoadText(char* dest, char* src)
{
	u16* textBoxInfo = (u16*)0x8013acd4;
	if (textBoxInfo[0] == 0xB4 && textBoxInfo[1] == 0x13) // Regular dialogue
		textBoxInfo[0] = 0xA8;

	if (src[0] == 0x80)
	{
		uint16_t newPos = src[1] | src[2] << 8;
		src = (char*)(0x8011D3C4 + newPos);
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