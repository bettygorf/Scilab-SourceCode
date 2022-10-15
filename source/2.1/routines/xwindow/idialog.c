#include "scilab_d.h"
#include "../machine.h"

static char *str;
static int lstr=0;
static Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;

static void 
IDialogOk(w, client_data, call_data) 
     Widget w;
     XtPointer client_data, call_data;	
{ 
  Widget dialog = (Widget) client_data;
  strncpy(str,XawDialogGetValueString(dialog),lstr-1);
  lstr=strlen(str);
  str[lstr-1] = '\n';
  ok_Flag_sci= 1;
}

#define X 147
#define Y 33

static void
IDialogWindow(description,valueinit)
     char description[],valueinit[];
  {
    Arg args[10];
    int iargs = 0;
    Widget shell,dialog;
    static Display *dpy = (Display *) NULL;
    DisplayInit("",&dpy,&toplevel);

    iargs=0;
    XtSetArg(args[iargs], XtNx, X + 10); iargs++ ;
    XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT +10); iargs++;
    XtSetArg(args[iargs], XtNallowShellResize, True); iargs++;
    shell = XtCreatePopupShell("dialogshell",
			       transientShellWidgetClass,toplevel,
			       args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, description); iargs++;
    XtSetArg(args[iargs], XtNvalue, valueinit); iargs++; 
    XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
    dialog = XtCreateManagedWidget("dialog",dialogWidgetClass,shell,
				   args,iargs);
    XawDialogAddButton(dialog, "ok", IDialogOk, (XtPointer) dialog);
    XtMyLoop(shell,dpy);
}


void C2F(idialg)(str1,nlr1,str2,nlr2,str3,nlr3,il1,il2,il3)
     char str1[],str2[],str3[];
     int *nlr1,*nlr2,*nlr3;
     long int il1,il2,il3;
{
  str=str3;
  lstr = *nlr3;
  IDialogWindow(str1,str2);
  *nlr3=lstr;
}




