/* Copyright INRIA */
#include <stdio.h>
#include <X11/Intrinsic.h>

#include "graphics.h"
#include "metio.h"

#define NUMFONTS 6

char *fontNames[] = {
  "-adobe-times-bold-r-normal--8-80-*-*-p-*-iso8859-1",
  "-adobe-times-bold-r-normal--10-100-*-*-p-*-iso8859-1",
  "-adobe-times-bold-r-normal--12-120-*-*-p-*-iso8859-1",
  "-adobe-times-bold-r-normal--14-140-*-*-p-*-iso8859-1",
  "-adobe-times-bold-r-normal--18-180-*-*-p-*-iso8859-1",
  "-adobe-times-bold-r-normal--24-240-*-*-p-*-iso8859-1"
};

static XFontStruct *fontStructs[NUMFONTS];

XFontStruct *theDrawFont;

void GetFonts()
{
  int i;
  XFontStruct *fontstruct;

  for (i = 0; i < NUMFONTS; i++) {
    if ((fontstruct = XLoadQueryFont(theG.dpy, fontNames[i])) == NULL) {
      if ((fontstruct = XLoadQueryFont(theG.dpy, "fixed")) == NULL) {
	sprintf(Description,"Unable to find any font\n");
	MetanetAlert(Description);
	exit(1);
      }
    }
    fontStructs[i] = fontstruct;
  }
}

XFontStruct *FontSelect(s)
int s;
{
  switch (s) {
  case 8:
    return fontStructs[0];
    break;
  case 10:
    return fontStructs[1];
    break;
  case 12:
    return fontStructs[2];
    break;
  case 14:
    return fontStructs[3];
    break;
  case 18:
    return fontStructs[4];
    break;
  case 24:
    return fontStructs[5];
    break;
  default:
    return NULL;
    break;
  }
}
