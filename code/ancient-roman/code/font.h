#ifndef FONT_H_
#define FONT_H_

#include "platform.h"

extern "C" {

	int GetLetterWidth(u32 letter);

	int GetSentenceWidth(const char* text, int length);

	int GetYForCentering(const char* text, u32 length);

	u32 GetLetter(u8* text, u8* stackey);

	void StringCopy(char* source, char* dest);

	u32 GetPropperPuzzleLength(const char* text);
}

#endif