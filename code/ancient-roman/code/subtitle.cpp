#include "subtitle.h"

#define GetPtr(x)	*((u32*)(x))

int counter = 0;
static int curAudioSubtitleLength = 0;

int sdbmHash(const char* text) {
	int hash = 0;
	int i = 0;

	for (; text[i] != 0; i++) {
		hash = text[i] + (hash << 6) + (hash << 16) - hash;
	}
	return hash;
}

int GetTimInfo(const uint32_t* tim, TIM_IMAGE* info) {

	if ((*(tim++) & 0xffff) != 0x0010)
		return 1;

	info->mode = *(tim++);
	if (info->mode & 8) {
		const uint32_t* palette_end = tim;
		palette_end += *(tim++) / 4;

		info->crect = (RECT*)tim;
		info->caddr = (u_long*)&tim[2];

		tim = palette_end;
	}
	else {
		info->caddr = 0;
	}

	tim++;
	info->prect = (RECT*)tim;
	info->paddr = (u_long*)&tim[2];

	return 0;
}

bool InitMovieSubtitle(void* videoname)
{
	if (letterPosition[1] == 0)								
	{
		int position = 0x180;
		for (int i = 1; i < 78; i++)
		{
			letterPosition[i] = position;
			position += 0x180;
		}
	}

	movieSubIdx = -1;
	int videonameHash = sdbmHash((const char*)GetPtr(videoname));  // Videoname is a pointer to a pointer so need to get the real pointer to get the name
	for (int i = 0; i < movieSubtitlesCount; i++)
	{
		if (videonameHash == movieSubtitles[i].id)
		{
			movieSubIdx = i;
			break;
		}
	}

	bool moviePlayed =  PlayMovie(videoname);

	ResetMovieSubtitle();

	return moviePlayed;
}

void ResetMovieSubtitle()
{
	movieSubIdx = -1;
}

void DrawMovieSubtitle(RECT* area, u16* image, u16* font, u32 curFrame)
{
	u32 sliceW = area->w;
	u32 sliceX = area->x;

	if (movieSubIdx >= 0)
	{
		MovieSubtitle subs = movieSubtitles[movieSubIdx];

		if (curFrame != currentMovieFrame)
		{
			currentMovieFrame = curFrame;
			currentMovieSubtitleIndexes[0] = -1;
			currentMovieSubtitleIndexes[1] = -1;
			currentMovieSubtitleIndexes[2] = -1;
			int idx = 0;

			for (int i = 0; i < subs.partsCount; i++)
			{
				if (subs.parts[i].startFrame <= curFrame && curFrame < subs.parts[i].endFrame)
				{
					currentMovieSubtitleIndexes[idx] = i;
					idx++;
				}
			}
		}

		for (int i = 0; i < 3 && currentMovieSubtitleIndexes[i] != -1; i++)
		{
			int idx = currentMovieSubtitleIndexes[i];

			const char* text = subs.parts[idx].text;

			if (sliceX <= subs.parts[idx].x && subs.parts[idx].x < sliceX + sliceW)
			{
				subs.parts[idx].textIdx = 0;
				subs.parts[idx].curX = subs.parts[idx].x - sliceX;
				subs.parts[idx].curY = subs.parts[idx].y * 16; // 16 comes from max width of a character = 8 * 2 (16bpp = 2 bytes)
			}

			u16 curX = subs.parts[idx].curX;
			u16 curY = subs.parts[idx].curY;
			while (subs.parts[idx].textIdx < subs.parts[idx].len)
			{
				u32 srcPixelPos = text[subs.parts[idx].textIdx] << 7; // 0x80 is half the width of our letters.  The entire byte count is (w * 2 (16bpp) * h).  We're using shorts or 2 bytes at a time so half.

				bool overflowed = false;
				for (u32 x = 0; x < 8; x++) // 8 is our max letter width... soon will be width of letter
				{
					u32 imgPos = curX + curY;
					for (u32 y = 0; y < 256;) // += 16 comes from max width of a character = 8 * 2 (16bpp = 2 bytes)  ----- 256 = may height times the 16 we get from the previous equation
					{
						// 0x8000 is the pixel color of the black background
						u16 sp = font[srcPixelPos++];
						if (sp != 0x8000) image[imgPos + y] = sp;

						y += 16;
					}

					curX++;
				}

				subs.parts[idx].textIdx++;

				if (curX >= sliceW)
				{
					subs.parts[idx].curX = 0;
					break;
				}
			}
		}
	}

	LoadImage(area, (u_long*)image);
}

//void DrawMovieSubtitle(RECT* area, u8* image, u8* font, u32 curFrame)
//{
//	u32 sliceW = 16;
//	u32 sliceWP = 16 * 3; // How many pixels wide are we?
//	u32 sliceX = (area->x / 24) * 16;
//
//	if (movieSubIdx >= 0)
//	{
//		MovieSubtitle subs = movieSubtitles[movieSubIdx];
//
//		for (int i = 0; i < subs.partsCount; i++)
//		{
//
//			if (subs.parts[i].startFrame <= curFrame && curFrame < subs.parts[i].endFrame)
//			{
//				const char* text = subs.parts[i].text;
//
//
//				if (sliceX <= subs.parts[i].x && subs.parts[i].x < sliceX + sliceW)
//				{
//					subs.parts[i].textIdx = 0;
//					subs.parts[i].curX = subs.parts[i].x - sliceX;
//					subs.parts[i].curY = subs.parts[i].y * 48;
//				}
//
//				u16 curX = (subs.parts[i].curX * 3);
//				u16 curY = subs.parts[i].curY;
//				while (subs.parts[i].textIdx < subs.parts[i].len)
//				{
//					u32 srcPixelPos = letterPosition[text[subs.parts[i].textIdx]];
//					for (u32 x = 0; x < 8; x++)
//					{
//						for (u32 y = 0; y < 768;)
//						{
//							u32 imgPos = curX + curY + y;
//
//							u8 sp = font[srcPixelPos++];
//							if (sp != 0) image[imgPos] = sp;
//							sp = font[srcPixelPos++];
//							if (sp != 0) image[imgPos + 1] = sp;
//							sp = font[srcPixelPos++];
//							if (sp != 0) image[imgPos + 2] = sp;
//
//							y += 48;
//						}
//
//						curX += 3;
//					}
//
//					subs.parts[i].textIdx++;
//
//					if (curX >= sliceWP)
//					{
//						subs.parts[i].curX = 0;
//						break;
//					}
//				}
//			}
//		}
//	}
//
//	LoadImage(area, (u_long*)image);
//}