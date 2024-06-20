#ifndef SUBTITLE_H_
#define SUBTITLE_H_

#include <string.h>
#include "platform.h"
#include "generated.h"

extern "C" {
	void InitAudioSubtitle(const char* audioFilename, u32 id, u32 unk1);

	void DrawShopAudioSubtitle(void* otag);

	extern void DrawShopGraphics(void* otag);

	extern void DrawGraphics(void* otag, u32* add, u32 size);

	extern void DisplayString(const char* text, u32 x, u32 y);

	extern void PlayAudio(const char* audioFilename, u32 id, u32 unk1);

	u32 InitMovieSubtitle(void* videoname);

	extern u32 PlayMovie(void* videoname);

	void ResetMovieSubtitle();

	void DrawMovieSubtitle(RECT* area, u16* image, u16* font, u32 curFrame);

	static short letterPosition[78] = {0, 0};

	static int movieSubIdx = -1;
	static int currentMovieFrame = -1;
	static int currentMovieSubtitleIndexes[3] = { -1, -1 , -1 };

	static int audioSubIdx = -1;
	static u32* audioSubitlesGraphicsList1;
	static u32* audioSubitlesGraphicsList2;

	extern u32* MemoryAllocate(int size);

	extern void InitGraphicPrimitives(u32* addr1, u32* addr2, int x, int y, int size);

	extern void SetGraphicPrimitives(u32* addr1, u32* addr2, char* string, int unk1);

	extern void ShopDisplay(u32* otag);



}
#endif