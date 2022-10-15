#include <stdio.h>
#include "../machine.h"
#include "../graphics/Graphics.h"
#include "../sun/men_Sutils.h"

#if defined(__MWERKS__)||defined(THINK_C)
#define Widget int
#define TRUE 1
#define FALSE 0
#else
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
#include <X11/Xaw/Toggle.h>
#endif

#include <string.h>
#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

/* used only for message and dialog boxes */

#define Min(x,y)	(((x)<(y))?(x):(y))
#define Max(x,y)	(((x)>(y))?(x):(y))

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

/* choose */

typedef struct {
  char *description;    /** Title **/
  char **strings;       /** items **/
  int nstrings;         /** number of items **/
  char **buttonname;    /** buttons **/
  int nb;               /** number of buttons **/
  int choice;           /** number of selected item **/
}  ChooseMenu ;

/* dialog */

extern char *dialog_str;

typedef struct {
  char *description;      /** Title **/
  char *init;              /** initial value **/
  char **pButName;         /** buttons **/
  int  nb;                /** number of buttons **/
  int  ierr;
}  SciDialog ;


/* Data structure to deal with a set of choices */

typedef struct {
  char *name;
  char *cbinfo ; 
  Widget toggle;
} SciData;

typedef struct {
  struct {
    char *name;
    char *text;
    int   num_toggles;
    int   columns;
    int  (*function)();
    int  default_toggle; /* and is set dynamically to the selected value */
    Widget label;
  } choice;
  SciData *data;
} SciStuff;

extern SciStuff **Everything ;

/* Data structure to deal with message */

typedef struct {
  char *string;            /** texte  **/
  char **pButName;         /** buttons **/
  int  nb;                /** number of buttons **/
  int  ierr;
}  SciMess ;

/* Data structure to deal with mdialog */

/* WARNING: it's not enough to change the following
 * define in order to increase the number of possible items 
 */

#define NPAGESMAX 10000
#define NITEMMAXPAGE 3000

typedef struct {
  char *labels;           /** Title **/
  char **pszTitle;        /** items **/
  char **pszName;         /** buttons **/
  int  nv;                /** number of items **/
  int  ierr;
}  MDialog ;


/** Data structure for MatDialog */

typedef struct {
  char *labels;           /** Title **/
  char **VDesc;           /* Vertical labels */
  char **HDesc;           /* Horizontal lables */
  char **data ;           /* values */
  int  nv;                /** number of items **/
  int  nl,nc;
  int  ierr;
}  MADialog ;

/** Data structure for printDialog **/

typedef struct {
  int numChoice ;
  char *filename ;
  char **PList ;
  char *Pbuffer ;
  int ns;
} PrintDial;


/* "men_choice-n.c.X1" */

extern void C2F(xchoices) _PARAMS((int *,int *,int *,int *,int *,int *,int *,int *,int *));  
extern int TestChoice  _PARAMS((void));  
extern int SciChoice  _PARAMS((char *, char **, int *, int ));  

/* "men_choose-n.c.X1" */

extern int TestChoose  _PARAMS((void));  
extern void C2F(xchoose) _PARAMS((int *, int *, int *, int *, int *, int *, int *, int *, int *, int *, int *));  

/* "men_dialog-n.c.X1" */

extern int TestDialog  _PARAMS((void));  
extern void C2F(xdialg) _PARAMS((int *value, int *ptrv, int *nv, int *, int *ptrdesc, int *nd, int *btn, int *ptrbtn, int *nb, int *res, int *ptrres, int *nr, int *ierr));  
extern void xdialg1  _PARAMS((char *, char *valueinit, char **pButName, char *value, int *ok));  

/* "men_getfile-n.c.X1" */

extern int TestGetFile  _PARAMS((void));  
extern void C2F(xgetfile) _PARAMS((char *filemask, char *dirname, char **res, integer *ires, integer *ierr, integer *rhs));  

/* "men_madial-n.c.X1" */

extern void C2F(xmatdg) _PARAMS((int *, int *ptrlab, int *nlab, int *value, int *ptrv, int *v, int *ptrdescv, int *h, int *ptrdesch, int *nl, int *nc, int *res, int *ptrres, int *ierr));  
extern int TestMatrixDialogWindow  _PARAMS((void));  

/* "men_mdial-n.c.X1" */

extern int TestmDialogWindow  _PARAMS((void));  
extern void C2F(xmdial) _PARAMS((int *, int *ptrlab, int *nlab, int *value, int *ptrv, int *, int *ptrdesc, int *nv, int *res, int *ptrres, int *ierr));  

/* "men_message-n.c.X1" */

extern int TestMessage  _PARAMS((int n));  
extern void C2F(xmsg) _PARAMS((int *basstrings, int *ptrstrings, int *nstring, int *btn, int *ptrbtn, int *nb, int *nrep, int *ierr));  

/* "men_print-n.c.X1" */

extern int prtdlg  _PARAMS((integer *flag, char *printer, integer *colored, integer *orientation, char *file, integer *ok));  
extern int TestPrintDlg  _PARAMS((void));  
extern int SetPrinterList  _PARAMS((int));  

/* "xmen_Utils-n.c.X1" */

extern void XtMyLoop  _PARAMS((Widget , Display *, int, int *));  
extern void ShellFormCreate  _PARAMS((char *, Widget *, Widget *, Display **));  
extern int ButtonCreate  _PARAMS((Widget, Widget *, XtCallbackProc, XtPointer, char *, char *));  
extern int ViewpLabelCreate  _PARAMS((Widget, Widget *, Widget *, char *));  
extern int ViewpListCreate  _PARAMS((Widget, Widget *, Widget *, char **, int));  
extern int LabelSize  _PARAMS((Widget, int, int , Dimension *, Dimension *));  
extern int AsciiSize  _PARAMS((Widget, int, int , Dimension *, Dimension *));  
extern int SetLabel  _PARAMS((Widget, char *, Dimension , Dimension ));  
extern int SetAscii  _PARAMS((Widget, char *, Dimension , Dimension ));  

/* "xmen_choice-n.c.X1" */

extern int SciChoiceI  _PARAMS((char *, int *, int ));  
extern int SciChoiceCreate  _PARAMS((char **, int *, int ));  
extern int AllocAndCopy  _PARAMS((char **, char *));  
extern int SciChoiceFree  _PARAMS((int ));  
extern Widget create_choices  _PARAMS((Widget, Widget,int));  

/* "xmen_choose-n.c.X1" */

extern int ExposeChooseWindow  _PARAMS((ChooseMenu *));  

/* "xmen_dialog-n.c.X1" */

extern int DialogWindow  _PARAMS((void));  

/* "xmen_getfile-n.c.X1" */

extern int GetFileWindow  _PARAMS((char *, char **, char *, int, int *));  
extern void XtSpecialLoop  _PARAMS((void));  
extern void cancel_getfile  _PARAMS((void));  
extern int write_getfile  _PARAMS((char *, char *));  
extern int popup_file_panel1  _PARAMS((Widget ));  

/* "xmen_madial-n.c.X1" */

extern int MatrixDialogWindow  _PARAMS((void));  

/* "xmen_mdial-n.c.X1" */

extern int mDialogWindow  _PARAMS((void));  

/* "xmen_message-n.c.X1" */

extern int ExposeMessageWindow  _PARAMS((void));  

/* "xmen_print-n.c.X1" */

extern void PrintDlgOk  _PARAMS((Widget w, caddr_t , caddr_t ));  
extern void SaveDlgOk  _PARAMS((Widget w, caddr_t , caddr_t ));  
extern void PrintDlgCancel  _PARAMS((Widget w, caddr_t , caddr_t ));  
extern int ExposePrintdialogWindow  _PARAMS((int flag, int *, int *)); 


