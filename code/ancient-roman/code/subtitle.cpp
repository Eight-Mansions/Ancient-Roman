#include "subtitle.h"

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

void InitMovieSubtitle(const char* videoname)
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
	int videonameHash = sdbmHash(videoname);
	for (int i = 0; i < movieSubtitlesCount; i++)
	{
		if (videonameHash == movieSubtitles[i].id)
		{
			movieSubIdx = i;
			break;
		}
	}
}

void ResetMovieSubtitle()
{
	movieSubIdx = -1;
}

void DrawMovieSubtitle(RECT* area, u8* image, u8* font, u32 curFrame)
{
	u32 sliceW = 16;
	u32 sliceWP = 16 * 3; // How many pixels wide are we?
	u32 sliceX = (area->x / 24) * 16;

	if (movieSubIdx >= 0)
	{
		MovieSubtitle subs = movieSubtitles[movieSubIdx];

		for (int i = 0; i < subs.partsCount; i++)
		{

			if (subs.parts[i].startFrame <= curFrame && curFrame < subs.parts[i].endFrame)
			{
				const char* text = subs.parts[i].text;


				if (sliceX <= subs.parts[i].x && subs.parts[i].x < sliceX + sliceW)
				{
					subs.parts[i].textIdx = 0;
					subs.parts[i].curX = subs.parts[i].x - sliceX;
					subs.parts[i].curY = subs.parts[i].y * 48;
				}

				u16 curX = (subs.parts[i].curX * 3);
				u16 curY = subs.parts[i].curY;
				while (subs.parts[i].textIdx < subs.parts[i].len)
				{
					u32 srcPixelPos = letterPosition[text[subs.parts[i].textIdx]];
					for (u32 x = 0; x < 8; x++)
					{
						for (u32 y = 0; y < 768;)
						{
							u32 imgPos = curX + curY + y;

							u8 sp = font[srcPixelPos++];
							if (sp != 0) image[imgPos] = sp;
							sp = font[srcPixelPos++];
							if (sp != 0) image[imgPos + 1] = sp;
							sp = font[srcPixelPos++];
							if (sp != 0) image[imgPos + 2] = sp;

							y += 48;
						}

						curX += 3;
					}

					subs.parts[i].textIdx++;

					if (curX >= sliceWP)
					{
						subs.parts[i].curX = 0;
						break;
					}
				}
			}
		}
	}

	LoadImage(area, (u_long*)image);
}