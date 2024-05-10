#ifndef SUBTITLE_H_
#define SUBTITLE_H_

#include <string.h>
#include "platform.h"
#include "generated.h"

extern "C" {
	u32 InitMovieSubtitle(void* videoname);

	extern u32 PlayMovie(void* videoname);

	void ResetMovieSubtitle();

	void DrawMovieSubtitle(RECT* area, u16* image, u16* font, u32 curFrame);

	static short letterPosition[78] = {0, 0};

	static int movieSubIdx = -1;
	static int currentMovieFrame = -1;
	static int currentMovieSubtitleIndexes[3] = { -1, -1 , -1 };
}
#endif