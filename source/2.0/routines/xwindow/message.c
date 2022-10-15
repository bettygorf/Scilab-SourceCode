#include "scilab_d.h"
#include "../machine.h"

void C2F(xmsg)(basstrings,nstring,ptrstrings,ierr)
int *basstrings,*nstring,*ptrstrings,*ierr;
{
  void C2F(cvstr)(), ExposeMessageWindow();
  char *strings;
  *ierr=0;
  ScilabMStr2C(basstrings,nstring,ptrstrings,&strings,ierr);
  if ( *ierr == 1) return;
  ExposeMessageWindow(strings,nstring);
  free(strings);
}


static Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;



#define X 147
#define Y 33

void MessageOk(w,shell,callData)
     Widget w;
     caddr_t shell;
     caddr_t callData;
{
  ok_Flag_sci = 1;
}

void ExposeMessageWindow(string,nstring)
     char *string;
     int *nstring;
{
  Widget message,okbutton,shell,port;
  Arg args[10];
  int iargs = 0;
  int width,i,i1,height;
  XFontStruct *font;
  static Display *dpy = (Display *) NULL;
  DisplayInit("",&dpy,&toplevel);

  font = XLoadQueryFont(dpy,XWMENUFONT);
  height=font->ascent+font->descent;

  XtSetArg(args[iargs], XtNx, X + 10); iargs++;
  XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT + 10); iargs++;
  XtSetArg(args[iargs], XtNallowShellResize, True); iargs++;
  shell = XtCreatePopupShell("messageshell",transientShellWidgetClass,toplevel,
			     args,iargs);
  iargs = 0;
  message = XtCreateManagedWidget("message",boxWidgetClass,shell,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "OK" ); iargs++;
  okbutton=XtCreateManagedWidget("messagecommand",commandWidgetClass,
			message,args,iargs);
  XtAddCallback(okbutton, XtNcallback,(XtCallbackProc)MessageOk , NULL); 

  width = 0; i1 = 0;
  for (i=0;i<strlen(string);i++) {
      if (string[i] == '\n') {
	  width = Max(width,XTextWidth(font,&string[i1],i-i1));
	  i1=i+1;
      }
  }
  width = width + 20;

  height=Min(*nstring+2,30)*(height+1);
    
  iargs = 0;
  XtSetArg(args[iargs], XtNallowVert, TRUE); iargs++;
  XtSetArg(args[iargs], XtNheight, height); iargs++;
  XtSetArg(args[iargs], XtNwidth, width); iargs++;
  XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
  XtSetArg(args[iargs], XtNfromVert, okbutton); iargs++;
  XtSetArg(args[iargs], XtNtop, XtChainTop); iargs++;
  XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
  port = XtCreateManagedWidget("port",viewportWidgetClass,
				     message,args,iargs);
 
  iargs=0;
  XtSetArg(args[iargs], XtNfont, font); iargs++;
  XtSetArg(args[iargs], XtNlabel,  string); iargs++; 
  XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
  XtCreateManagedWidget("labelmessage",labelWidgetClass,port,args,
			iargs);
  XtMyLoop(shell,dpy);
}


