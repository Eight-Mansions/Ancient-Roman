#include "text.h"

void LoadText(char* dest, char* src)
{
	if (src[0] == 0x80)
	{
		uint16_t newPos = src[1] | src[2] << 8;
		src = (char*)(0x8011D3C4 + newPos);
	}

	CopyString(dest, src);
}