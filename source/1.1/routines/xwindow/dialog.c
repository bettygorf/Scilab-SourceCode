#include "scilab_d.h"
#include "../machine.h"

static char *str;

void C2F(xdialg)(value,ptrv,nv,desc,ptrdesc,nd,res,ptrres,nr,ierr)
     int *value,*ptrv,*nv,*desc,*ptrdesc,*nd,*res,*ptrres,*nr,*ierr;
{
  void C2F(cvstr)(),DialogWindow();
  int maxlines,maxchars;
  char  *description,*valueinit;
  maxlines= *nr;
  maxchars= *ierr;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2C(value,nv,ptrv,&valueinit,ierr);
  if ( *ierr == 1) return;
  DialogWindow(description,valueinit);
  free(description);
  free(valueinit);
  ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines);
  free(str);/** allocated in DialogOK **/
}

extern Widget toplevel;
extern XtAppContext app_con;

int ok_Flag_sci= 0;

static void 
DialogOk(w, client_data, call_data) 
     Widget w;
     XtPointer client_data, call_data;	
{ 
  Widget dialog = (Widget) client_data;
  int ind ;
  char *lstr;
  lstr=XawDialogGetValueString(dialog);
  str=(char *) malloc((unsigned) (strlen(lstr)+1)*(sizeof(char)));
  if (str != 0)
     {
       strcpy(str,lstr);
       ind = strlen(str) - 1 ;
       if (str[ind] == '\n') str[ind] = '\0' ;
     }
  else 
    fprintf(stderr,"Malloc : No more place");
  ok_Flag_sci= 1;
}

#define X 147
#define Y 33

void DialogWindow(description,valueinit)
     char * description;
     char * valueinit;
  {
    Arg args[10];
    int iargs = 0;
    Widget shell,dialog;
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
    XawDialogAddButton(dialog, "ok", DialogOk, (XtPointer) dialog);
    XtMyLoop(shell);
}

XtMyLoop(w)
     Widget w;
{
  Atom	 wmDeleteWindow;
  XEvent event;
  ok_Flag_sci= 0;
  XtPopup(w,XtGrabExclusive);
  /* On ignore les delete envoyes par le Window Manager */
  wmDeleteWindow = XInternAtom(XtDisplay(w),"WM_DELETE_WINDOW", False);
  XSetWMProtocols(XtDisplay(w),XtWindow(w), &wmDeleteWindow, 1);
  for (;;) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
    if (ok_Flag_sci != 0) break;
  }
  XtDestroyWidget(w);  
  XFlush(XtDisplay(toplevel));
  XSync(XtDisplay(toplevel),0);
};

