#include "loadfile.h"

void LoadFile()
{
	LoadFileIsh("\\CODE.DAT;1");

	u32* srcPos = (u32*)0x80158154;
	u32* destPos = (u32*)0x801E0000;
	u32 cnt = 0x7200 / 4;
	for (int i = 0; i < cnt; i++)
	{
		destPos[i] = srcPos[i];
	}
}