#ifndef TEXT_H_
#define TEXT_H_

#include "platform.h"

extern "C" {
	void LoadText(char* dest, char* src);

	void IsNewline(char* src);

	extern void CopyString(char* dest, char* src);
}

#endif
