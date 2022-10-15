#include <stdio.h>
#include "../machine.h"

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xaw/Box.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Dialog.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Paned.h>
#include <X11/Xaw/AsciiText.h>
#include <X11/Xaw/Viewport.h>
#include <X11/Xaw/Cardinals.h>
#include <X11/Shell.h>
#include <X11/Xaw/Form.h>
#include <X11/Xaw/List.h>
#include <X11/cursorfont.h>
#include <X11/Xaw/Scrollbar.h>

#include <string.h>
#include <malloc.h>

/* used only for message and dialog boxes */

#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

#define char_height(font) ((font)->max_bounds.ascent+(font)->max_bounds.descent)

#define char_width(font) ((font)->max_bounds.width)

#define PI0 (integer *) 0
#define PD0 (double *) 0

#ifdef lint5
#include <sys/stdtypes.h>
#define MALLOC(x) malloc(((size_t) x))
#define FREE(x) if (x  != NULL) free((void *) x);
#else
#define MALLOC(x) malloc(((unsigned) x))
#define FREE(x) if (x  != NULL) free((char *) x);
#endif






