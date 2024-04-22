#ifndef SUBTITLE_H_
#define SUBTITLE_H_

#include <string.h>
#include "platform.h"
#include "generated.h"

extern "C" {
	void InitMovieSubtitle(const char* videoname);

	void ResetMovieSubtitle();

	void DrawMovieSubtitle(RECT* area, u8* image, u8* font, u32 curFrame);

	static short letterPosition[78] = {0, 0};

	static int movieSubIdx = -1;
}
#endif