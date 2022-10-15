#ifndef GD_H
#define GD_H 1

/* gd.h: declarations file for the gifdraw module.

	Written by Tom Boutell, 5/94.
	Copyright 1994, Cold Spring Harbor Labs.
	Permission granted to use this code in any fashion provided
	that this notice is retained and any alterations are
	labeled as such. It is requested, but not required, that
	you share extensions to this module with us so that we
	can incorporate them into new versions. */

/* stdio is needed for file I/O. */
#include <stdio.h>
#include "../machine.h"

/* This can't be changed, it's part of the GIF specification. */

#define gdMaxColors 256

/* Image type. See functions below; you will not need to change
	the elements directly. Use the provided macros to
	access sx, sy, the color table, and colorsTotal for 
	read-only purposes. */

typedef struct  gdImageStruct { 
	unsigned char ** pixels;
	int sx;
	int sy;
	int colorsTotal;
	int red[gdMaxColors];
	int green[gdMaxColors];
	int blue[gdMaxColors]; 
	int open[gdMaxColors];
	int transparent;
	int *polyInts;
	int polyAllocated;
 	struct gdImageStruct *brush;
	struct gdImageStruct *tile;	 
	int brushColorMap[gdMaxColors];
	int tileColorMap[gdMaxColors];
	int styleLength;
	int stylePos;
	int *style;
	int interlace;
        int alu;
        int clipping;
        int cliprect[4];
        int background;
} gdImage;

typedef gdImage * gdImagePtr;

typedef struct {
	/* # of characters in font */
	int nchars;
	/* First character is numbered... (usually 32 = space) */
	int offset;
	/* Character width and height */
	int w;
	int h;
	/* Font data; array of characters, one row after another.
		Easily included in code, also easily loaded from
		data files. */
	char *data;
} gdFont;

/* Text functions take these. */
typedef gdFont *gdFontPtr;

/* For backwards compatibility only. Use gdImageSetStyle()
	for MUCH more flexible line drawing. Also see
	gdImageSetBrush(). */
#define gdDashSize 4

/* Special colors. */

#define gdStyled (-2)
#define gdBrushed (-3)
#define gdStyledBrushed (-4)
#define gdTiled (-5)

/* NOT the same as the transparent color index.
	This is used in line styles only. */
#define gdTransparent (-6)

/* functions to handle alu modes and clipping */
void gdSetClipping _PARAMS((gdImagePtr im , int xmin, int ymin, int xmax, int ymax));
void gdUnsetClipping  _PARAMS((gdImagePtr im)); 
void gdSetAlu _PARAMS((gdImagePtr im, int alu));


/* Functions to manipulate images. */

gdImagePtr gdImageCreate _PARAMS((int sx, int sy));
gdImagePtr gdImageCreateFromGif _PARAMS((FILE *fd));
gdImagePtr gdImageCreateFromGd _PARAMS((FILE *in));
gdImagePtr gdImageCreateFromXbm _PARAMS((FILE *fd));
void gdImageDestroy _PARAMS((gdImagePtr im));
void gdImageSetPixel _PARAMS((gdImagePtr im, int x, int y, int color));
int gdImageGetPixel _PARAMS((gdImagePtr im, int x, int y));
void gdImageLine _PARAMS((gdImagePtr im, int x1, int y1, int x2, int y2, int color));
/* For backwards compatibility only. Use gdImageSetStyle()
	for much more flexible line drawing. */
void gdImageDashedLine _PARAMS((gdImagePtr im, int x1, int y1, int x2, int y2, int color));
/* Corners specified (not width and height). Upper left first, lower right
 	second. */
void gdImageRectangle _PARAMS((gdImagePtr im, int x1, int y1, int x2, int y2, int color));
/* Solid bar. Upper left corner first, lower right corner second. */
void gdImageFilledRectangle _PARAMS((gdImagePtr im, int x1, int y1, int x2, int y2, int color));
int gdImageBoundsSafe _PARAMS((gdImagePtr im, int x, int y));
int gdImageChar _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, int c, int color));
void gdImageCharUp _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, int c, int color));
void gdImageString _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, unsigned char *s, int color));
void gdImageStringUp _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, unsigned char *s, int color));
void gdImageString16 _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, unsigned short *s, int color));
void gdImageStringUp16 _PARAMS((gdImagePtr im, gdFontPtr f, int x, int y, unsigned short *s, int color));

/* Point type for use in polygon drawing. */

typedef struct {
	int x, y;
} gdPoint, *gdPointPtr;

void gdImagePolygon _PARAMS((gdImagePtr im, gdPointPtr p, int n, int c));
void gdImageFilledPolygon _PARAMS((gdImagePtr im, gdPointPtr p, int n, int c));

int gdImageColorAllocate _PARAMS((gdImagePtr im, int r, int g, int b));
int gdImageColorClosest _PARAMS((gdImagePtr im, int r, int g, int b));
int gdImageColorExact _PARAMS((gdImagePtr im, int r, int g, int b));
void gdImageColorDeallocate _PARAMS((gdImagePtr im, int color));
void gdImageColorTransparent _PARAMS((gdImagePtr im, int color));
void gdImageGif _PARAMS((gdImagePtr im, FILE *out));
void gdImageGd _PARAMS((gdImagePtr im, FILE *out));
void gdImageArc _PARAMS((gdImagePtr im, int cx, int cy, int w, int h, int s, int e, int color));
void gdImageFillToBorder _PARAMS((gdImagePtr im, int x, int y, int border, int color));
void gdImageFill _PARAMS((gdImagePtr im, int x, int y, int color));
void gdImageCopy _PARAMS((gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int w, int h));
/* Stretches or shrinks to fit, as needed */
void gdImageCopyResized _PARAMS((gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int dstW, int dstH, int srcW, int srcH));
void gdImageSetBrush _PARAMS((gdImagePtr im, gdImagePtr brush));
void gdImageSetTile _PARAMS((gdImagePtr im, gdImagePtr tile));
void gdImageSetStyle _PARAMS((gdImagePtr im, int *style, int noOfPixels));
/* On or off (1 or 0) */
void gdImageInterlace _PARAMS((gdImagePtr im, int interlaceArg));
void gdImageChangeColor _PARAMS((gdImagePtr im, int old, int new));
void gdSetBackground _PARAMS((gdImagePtr im, int background));
int gdCharWidth _PARAMS((gdFontPtr f, int c));
void gdImageThickLine _PARAMS((gdImagePtr im, int x1, int y1, int x2, int y2, int color, int thick));
void gdImagePolyLine _PARAMS((gdImagePtr im, int *X, int *Y, int n, int color, int thick, int close));

/* Macros to access information about images. READ ONLY. Changing
	these values will NOT have the desired result. */
#define gdImageSX(im) ((im)->sx)
#define gdImageSY(im) ((im)->sy)
#define gdImageColorsTotal(im) ((im)->colorsTotal)
#define gdImageRed(im, c) ((im)->red[(c)])
#define gdImageGreen(im, c) ((im)->green[(c)])
#define gdImageBlue(im, c) ((im)->blue[(c)])
#define gdImageGetTransparent(im) ((im)->transparent)
#define gdImageGetInterlaced(im) ((im)->interlace)
#endif
