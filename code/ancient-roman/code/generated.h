#ifndef GENERATED_H_
#define GENERATED_H_

#include "platform.h"

struct AudioSubtitlePart {
	const char* text;
	const u8 len;
	const u16 startFrame;
	const u16 endFrame;
	const i16 x;
	const i16 y;
};
struct AudioSubtitle {
	const i32 id;
	const i32 id2;
	const u8 partsCount;
	AudioSubtitlePart* parts;
};
struct AudioSubtitleDisplayed {
	const AudioSubtitlePart* parts;
	u8 partsCount;
	u8 nextPartIdx;
	u8 ticksTilNext;
};

extern const u32 audioSubtitlesCount;
extern AudioSubtitle audioSubtitles[];

struct MovieSubtitlePart {
	const char* text;
	const u8 len;
	u8 textIdx;
	const u16 startFrame;
	const u16 endFrame;
	const u16 x;
	const u16 y;
	const u16 w;
	u16 curX;
	u16 curY;
};

struct MovieSubtitle {
	const i32 id;
	const u8 partsCount;
	MovieSubtitlePart* parts;
};

extern const u32 movieSubtitlesCount;
extern MovieSubtitle movieSubtitles[];
#endif