#include "scilab_d.h"
  
  extern void ShellFormCreate();
extern void C2F(cvstr)();
extern int ok_Flag_sci; 
void DialogWindow();

static char *str = (char *) 0;
     static XtCallbackProc DialogOk();
     static XtCallbackProc DialogCancel();
     
     
     /* interface with scilab */
     
     void C2F(xdialg)(value,ptrv,nv,desc,ptrdesc,nd,btn,ptrbtn,nb,res,ptrres,nr,ierr)
     int *value,*ptrv,*nv,*desc,*ptrdesc,*nd,*btn,*nb,*ptrbtn,*res,*ptrres,*nr,*ierr;
{
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
  FREE(description);
  FREE(valueinit);
  for (i=0 ; i < *nb ; i++ )FREE(buttonname[i]);
  FREE( buttonname);
  if (*nv==0)
    *nr=0;
  else {
    ScilabC2MStr2(res,nr,ptrres,str,ierr,maxchars,maxlines);
    FREE(str);/** allocated in DialogOK **/
  }
}
/* to open a dialog in a procedure */
void xdialg1(description,valueinit,buttonname,value,ok)
     char *description,*valueinit,**buttonname,*value;
     int *ok;
{
  int nd=0,nv;
  nv=1;
  DialogWindow(description,valueinit,&nd,&nv,buttonname);
  if (nv==0)
    *ok=0;
  else {
    *ok=1;
    strcpy(value,str);
    FREE(str);/** allocated in DialogOK **/
  }
}

/* test function */

TestDialog() 
{
  int i=0;
  static String description = "Dialog test";
  static String init ="Initial\nvalue";
  static String buttonname[] = {
    "LabelOK",
    "LabelCancel",
    NULL
    };
  DialogWindow(description,init,&i,&i,buttonname);
}

/* The dialog command callback */

static XtCallbackProc 
  DialogOk(w, client_data, call_data) 
Widget w;
XtPointer client_data, call_data;	
{ 
  Arg args[1];
  Cardinal iargs=0;
  Widget dialog = (Widget) client_data;
  char *lstr;
  iargs=0;
  XtSetArg(args[iargs], XtNstring, &lstr);iargs++;
  XtGetValues( dialog, args, iargs);
  str=(char *) MALLOC( (strlen(lstr)+1)*(sizeof(char)));
  if (str != 0)
    { int ind ;
      strcpy(str,lstr);
      ind = strlen(str) - 1 ;
      if (str[ind] == '\n') str[ind] = '\0' ;
    }
  else 
    Scistring("Malloc : No more place");
  ok_Flag_sci= 1;
}

/* The cancel command callback */

static XtCallbackProc 
  DialogCancel(w,client_data,callData)
Widget w;
XtPointer client_data, callData;	
{ 
  ok_Flag_sci = -1;
}

void 
  DialogWindow(description,valueinit,nd,nv,buttonname)
char *description, *valueinit, **buttonname;
int *nv, *nd;
{
  Arg args[10];
  Cardinal iargs = 0;
  Widget shell,dialog,dialogpanned,label,okbutton,wid,labelviewport,cform;
  static Display *dpy = (Display *) NULL;
  
  ShellFormCreate("dialogShell",&shell,&dialogpanned,&dpy);
  
  /* Create a Viewport+Label and resize it */
  
  ViewpLabelCreate(dialogpanned,&label,&labelviewport,description);
  
  iargs=0;
  XtSetArg(args[iargs], XtNstring ,valueinit) ; iargs++;
  dialog = XtCreateManagedWidget("ascii",asciiTextWidgetClass,dialogpanned, args, iargs);
  
  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,dialogpanned,args,iargs);
  
  ButtonCreate(cform,&okbutton,(XtCallbackProc)DialogOk,
	       (XtPointer) dialog,buttonname[0],"ok");
  ButtonCreate(cform,&wid,(XtCallbackProc)DialogCancel,
	       (XtPointer) NULL,buttonname[1],"cancel");
  
  XtMyLoop(shell,dpy);
  if (ok_Flag_sci == -1) *nv=0;
}

