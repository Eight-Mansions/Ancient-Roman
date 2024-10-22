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

	void InitDialogueText(u32 unk1, u32 unk2, u32 unk3, u32 unk4, u32 unk5);
	extern void FUN_8003eb04(u32 unk1, u32 unk2, u32 unk3, u32 unk4, u32 unk5);

	extern i32 SetupDialogueText(POLY_FT4* p, u8* string, long maxLen, int len, int unk1);
	extern i32 FUN_8003e238(POLY_FT4* p, u8* string, long maxLen, int len, int unk1);

	extern void DisplayDialogueText(u32* otag, POLY_FT4* p, int len);

	static u32 displayedLines[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

	void GetPlaceNameWidth(u8* string);

	u32 GetHeaderNameCenter(u8* string);

	u32 GetHeaderNameCenterForShops(u8* string);

	extern u32 locationNameWidth;

	void GetArrowPlacementForDialogue(u8* string, u32 unk1, u32 unk2);

	extern void FUN_8003f958(u8* string, u32 unk1, u32 unk2);

	extern u32 cursorPosition;

	extern u32 lineLength[4];	
	extern u32 lineCount;

	void IgnoreHiriganaEnglishButtons();

	static u8 nameEntryRowPrev = 0;
	extern u8 nameEntryCol;
	extern u8 nameEntryRow;

	void DisableVwfOnNamingScreen(u32* unk1, u8* unk2, u32 unk3, u32 unk4);

	extern void FUN_8003dc00(u32* unk1, u8* unk2, u32 unk3, u32 unk4);

	static bool vwfOn = true;

	extern u32 NumWindowLinesPos;
	
	extern u32 cursorPosition;
	
}

#endif