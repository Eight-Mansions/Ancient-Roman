#ifndef LOADFILE_H_
#define LOADFILE_H_

#include "platform.h"

extern "C" {
	void LoadFile();

	extern void LoadFileIsh(const char* filename); // It really just loads the TIMs but we'll hijack it :)
}

#endif
