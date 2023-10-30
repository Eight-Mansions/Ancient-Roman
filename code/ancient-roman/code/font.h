#ifndef FONT_H_
#define FONT_H_

#include "platform.h"

extern "C" {

	int GetLetterWidth(u32 letter);

	u8 GetSentenceWidth(const char* text, u32 curIdx, u8* graphic);
}

#endif