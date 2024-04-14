#ifndef FONT_H_
#define FONT_H_

#include "platform.h"

extern "C" {

	u8 GetLetterWidth(u32 letter);

	u16 GetSentenceWidth(const char* text, u32 curIdx, u8* graphic, const u8 letterWidths[99], u8 defaultWidth);

	void GetMenuSentenceWidth(const char* text, u32 curIdx, u8* graphic);

	void GetDialogueSentenceWidth(const char* text, u32 curIdx, u8* graphic);

	void SetBabyLetterWidths(POLY_FT4* p1, POLY_FT4* p2, char* text, ushort length);

	extern void FUN_8003dba8(POLY_FT4* p1, POLY_FT4* p2, char* text, u32 unk1);
}

#endif