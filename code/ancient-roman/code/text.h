#ifndef TEXT_H_
#define TEXT_H_

#include "platform.h"

extern "C" {

	void LoadText(char* src, char* dest);

	extern void CopyString(char* src, char* dest);
}

#endif
