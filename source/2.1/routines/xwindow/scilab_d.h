#include <stdio.h>
#include <string.h>
#include <malloc.h>
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
#include <X11/IntrinsicP.h>
#include <X11/Xaw/TextP.h>
#include <X11/Xaw/Scrollbar.h>

/* used only for message and dialog boxes */
#define DIALOGHEIGHT 30

#define VIEWHEIGHT 600
#define DRAWHEIGHT 3000
#define DRAWWIDTH 3000  

#define INTERHEIGHT 100

#define XWMENUFONT "*-fixed-medium-r-*-*-13-*-*-*-*-*-iso8859-*"
#define MaxWin 10

#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

#define         char_height(font) \
                ((font)->max_bounds.ascent + (font)->max_bounds.descent)

#define         char_width(font) ((font)->max_bounds.width)


