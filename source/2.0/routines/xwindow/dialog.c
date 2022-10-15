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

#define X 147
#define Y 33

static
void DialogWindow(description,valueinit,nd,nv,buttonname)
     char * description;
     char * valueinit;
     char **buttonname;
     int * nv;
     int *nd;
  {
    Arg args[10];
    int iargs = 0;
    int width,i,height,n,ni,li;
    XFontStruct *font;
    Widget shell,dialog,dialogbox,port,label,okbutton;
    static Display *dpy = (Display *) NULL;

    DisplayInit("",&dpy,&toplevel);

    font = XLoadQueryFont(dpy,XWMENUFONT);
    height=font->ascent+font->descent;

    iargs=0;
    XtSetArg(args[iargs], XtNx, X + 10); iargs++ ;
    XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT +10); iargs++;
    XtSetArg(args[iargs], XtNallowShellResize, True); iargs++;

    shell = XtCreatePopupShell("dialogshell",
			       transientShellWidgetClass,toplevel,
			       args,iargs);

    iargs = 0;
    XtSetArg(args[iargs], XtNheight, height); iargs++;
    XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
    dialogbox = XtCreateManagedWidget("dialogbox",boxWidgetClass,
				      shell,args,iargs);

    iargs=0;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    XtSetArg(args[iargs], XtNlabel,  description); iargs++; 
    XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
    label=XtCreateManagedWidget("labelmessage",labelWidgetClass,dialogbox,args,
			  iargs);

    height=Min(*nv+2,30)*(height+1);
    iargs = 0;
    XtSetArg(args[iargs], XtNstring, valueinit);            iargs++;
    XtSetArg(args[iargs], XtNresizable, True);              iargs++;
    XtSetArg(args[iargs], XtNresize, XawtextResizeWidth);   iargs++;
    XtSetArg(args[iargs], XtNeditType, XawtextEdit);        iargs++;
    XtSetArg(args[iargs], XtNscrollVertical, XawtextScrollWhenNeeded);        iargs++;
    XtSetArg(args[iargs], XtNfromVert, label);              iargs++;
    XtSetArg(args[iargs], XtNleft, XtChainLeft);            iargs++;
    XtSetArg(args[iargs], XtNheight, height);               iargs++;
    XtSetArg(args[iargs], XtNright, XtChainRight);          iargs++;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    dialog = XtCreateManagedWidget("value",asciiTextWidgetClass,
				       dialogbox, args, iargs);

    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, buttonname[0] ); iargs++;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    okbutton=XtCreateManagedWidget("ok button",commandWidgetClass,
				   dialogbox,args,iargs);
    XtAddCallback(okbutton, XtNcallback,(XtCallbackProc)DialogOk ,
		  (XtPointer) dialog); 

    XtMyLoop(shell,dpy);
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
};


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
  ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines);
  free(str);/** allocated in DialogOK **/
}
