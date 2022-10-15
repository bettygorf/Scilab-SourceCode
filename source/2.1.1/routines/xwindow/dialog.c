#include "scilab_d.h"
#include "../machine.h"

static char *str;
static Widget toplevel;
extern XtAppContext app_con;
int ok_Flag_sci= 0;

static void 
DialogOk(w, client_data, call_data) 
     Widget w;
     XtPointer client_data, call_data;	
{ 
  Arg args[1];
  Widget dialog = (Widget) client_data;
  int ind ;
  char *lstr;
  XtSetArg(args[0], XtNstring, &lstr);
  XtGetValues( dialog, args, 1);
  str=(char *) malloc((unsigned) (strlen(lstr)+1)*(sizeof(char)));
  if (str != 0)
     {
       strcpy(str,lstr);
       ind = strlen(str) - 1 ;
       if (str[ind] == '\n') str[ind] = '\0' ;
     }
  else 
    Scistring("Malloc : No more place");
  ok_Flag_sci= 1;
}

static XtCallbackProc 
DialogCancel(w,client_data,callData)
     Widget w;
     XtPointer client_data, callData;	
{ 
  ok_Flag_sci = -1;
}

void 
DialogWindow(description,valueinit,nd,nv,buttonname)
     char * description;
     char * valueinit;
     char **buttonname;
     int * nv;
     int * nd;
  {
    Arg args[10];
    int iargs = 0;
    XFontStruct     *temp_font;
    int width,i,height,n,ni,li,max_width;
    Widget shell,dialog,dialogform,port,label,okbutton,wid,box;
    static Display *dpy = (Display *) NULL;

    DisplayInit("",&dpy,&toplevel);

    shell = XtCreatePopupShell("dialogShell",
			       transientShellWidgetClass,toplevel,
			       args,iargs);

    iargs = 0;
    dialogform = XtCreateManagedWidget("dialogForm",formWidgetClass,
				      shell,args,iargs);
    iargs=0;
    XtSetArg(args[iargs], XtNlabel,  description); iargs++; 
    label=XtCreateManagedWidget("dialogLabel",labelWidgetClass,dialogform,args,
			  iargs);
    iargs=0;
    XtSetArg(args[0],XtNfont, &temp_font);  iargs++;
    XtGetValues(label, args, iargs);
    height=Min(*nv+1,30)*(char_height(temp_font) + 2);
    /* width of valueinit */
    width=0 ;
    max_width=1;
    for (i = 0 ; i < (int)strlen(valueinit);i++)
      {
	width++;
	if ( valueinit[i]=='\n' || i == strlen(valueinit)  -1)
	  {
	    max_width= (max_width > width ) ?  max_width : width;
	    width=0;
	  }
      }
    width=(max_width+2)*Max(char_width(temp_font),1);
    iargs = 0;
    XtSetArg(args[iargs], XtNheight, height);               iargs++;
    XtSetArg(args[iargs], XtNwidth, width);   iargs++;
    XtSetArg(args[iargs], XtNstring, valueinit);            iargs++;
    dialog = XtCreateManagedWidget("dialogAscii",asciiTextWidgetClass,
				       dialogform, args, iargs);

    iargs=0;
    box=XtCreateManagedWidget("dialogCommand",formWidgetClass,dialogform,args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, buttonname[0] ); iargs++;
    okbutton=XtCreateManagedWidget("okCommand",commandWidgetClass,
				   box,args,iargs);
    XtAddCallback(okbutton, XtNcallback,(XtCallbackProc)DialogOk ,
		  (XtPointer) dialog); 
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, buttonname[1] ); iargs++;
    wid=XtCreateManagedWidget("cancelCommand",commandWidgetClass,
			      box,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)DialogCancel ,NULL);  

    XtMyLoop(shell,dpy);
    if (ok_Flag_sci == -1) *nv=0;
}

XtMyLoop(w,dpy)
     Widget w;
     Display *dpy;
{
  Atom	 wmDeleteWindow;
  XEvent event;
  ok_Flag_sci= 0;
  /*  XtPopup(w,XtGrabExclusive);*/
  XtPopup(w,XtGrabNone); 
  /* On ignore les delete envoyes par le Window Manager */
  wmDeleteWindow = XInternAtom(XtDisplay(w),"WM_DELETE_WINDOW", False);
  XSetWMProtocols(XtDisplay(w),XtWindow(w), &wmDeleteWindow, 1);
  for (;;) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
    if (ok_Flag_sci != 0) break;
  }
  XtDestroyWidget(w);  
  XFlush(dpy);
  XSync(dpy,0);
}

void C2F(xdialg)(value,ptrv,nv,desc,ptrdesc,nd,btn,ptrbtn,nb,res,ptrres,nr,ierr)
     int *value,*ptrv,*nv,*desc,*ptrdesc,*nd,*btn,*nb,*ptrbtn,*res,*ptrres,*nr,*ierr;
{
  void C2F(cvstr)(),DialogWindow();
  int maxlines,maxchars,i;
  char  *description,*valueinit,**buttonname;
  maxlines= *nr;
  maxchars= *ierr;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2C(value,nv,ptrv,&valueinit,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(btn,nb,ptrbtn,&buttonname,ierr);
  if ( *ierr == 1) return;
  DialogWindow(description,valueinit,nd,nv,buttonname);
  free(description);
  free(valueinit);
  for (i=0 ; i < *nb ; i++ )free((char*)buttonname[i]);
  free(buttonname);
  if (*nv==0)
      *nr=0;
  else {
      ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines);
      free(str);/** allocated in DialogOK **/
  }
}

/* 
   Pour forcer les taille max : ca ne marche pas a la creation 
   si le popup est trop grand c'est donc inutile car on peut specifier 
   ce qui suit en resources

 */

ForceMaxSize(w)
Widget w;
{
    XSizeHints	size_hints;
    size_hints.min_width  =20;
    size_hints.max_width = 800;
    size_hints.min_height =50;
    size_hints.max_height =800;
    size_hints.flags =  PMinSize | PMaxSize;
    XSetWMNormalHints(XtDisplay(w),XtWindow(w), &size_hints);
  } 
