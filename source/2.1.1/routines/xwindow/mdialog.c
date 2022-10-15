#include "scilab_d.h"
#include "../machine.h"
static char **str;

void C2F(cvstr)();

static void mDialogWindow();

void C2F(xmdial)(label,ptrlab,nlab,value,ptrv,desc,ptrdesc,nv,res,ptrres,ierr)
     int *label,*ptrlab,*nlab,*value,*ptrv,*desc,*ptrdesc,*nv,*res,*ptrres,*ierr;
{
  int i,ni,nr,maxchars,nv1;
  char **description,**valueinit,*labels;
  maxchars= *ierr;/** Il faudrait utiliser maxchars **/
  *ierr=0;
  /* conversion of scilab characters into strings */
  ScilabMStr2C(label,nlab,ptrlab,&labels,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(desc,nv,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(value,nv,ptrv,&valueinit,ierr);
  if ( *ierr == 1) return;
  str=(char **) malloc((unsigned) (*nv+1)*sizeof(char *));
  nv1= *nv;
  mDialogWindow(labels,description,valueinit,nv);
  free((char*)labels);
  for (i=0;i< nv1;i++) free((char*)valueinit[i]); free((char*)valueinit);
  for (i=0;i< nv1;i++) free((char*)description[i]); free((char*)description);
  if (*nv!=0)
    {
      int job=0;
      nr=0;
      ptrres[0]=1;
      for (i=1;i<*nv+1;i++) {
	ni=strlen(str[i-1]);
	ptrres[nr+1]=ptrres[nr]+ni;
	nr=nr+1;
	F2C(cvstr)(&ni,res,str[i-1],&job,ni);
	res+=ni;
	free((char*)str[i-1]);
      }
      free((char*)str);
    }
}

/* X Window Part */

static Widget toplevel;
extern XtAppContext app_con;

#define X 147
#define Y 33

static Widget  *dialoglist;
extern int ok_Flag_sci;

static XtCallbackProc
mDialogOk(w,nv,callData)
     Widget w;
     caddr_t callData;
     int nv;
{ int ind,i,ns;
  Arg args[2];
  int iargs;
  String str1,p;
  for (i=0;i<nv;i++) {
    iargs=0;
    XtSetArg(args[iargs], XtNstring, &str1); iargs++ ;
    XtGetValues(dialoglist[i],args,iargs);
    ns=strlen(str1);
    p=(char *) malloc((unsigned)(ns+1)*sizeof(char));
    if (p == 0) { Scistring("Malloc : No more place");return;}
    strcpy(p,str1);
    ind = ns - 1 ;
    if (p[ind] == '\n' ) p[ind] = '\0' ;
    str[i]=p;
  }
  free(dialoglist);
  ok_Flag_sci = 1;
}

static XtCallbackProc 
mDialogCancel(w,nv,callData)
     Widget w;
     caddr_t callData;
     int  nv;
{ 
  mDialogOk(w,nv,callData);
  ok_Flag_sci = -1;
}

static void 
mDialogWindow(labels,description,valueinit,nv)
     char ** description;
     char ** valueinit;
/*     char **buttonname;*/
     char *labels;
     int *nv;
  {
    Arg args[10];
    XFontStruct     *temp_font;
    int iargs = 0,i,ierr,mxdesc,mxini,siz,width;
    Widget shell,wid,form,box,label;
    Widget *w;
    static Display *dpy = (Display *) NULL;
    DisplayInit("",&dpy,&toplevel);

    iargs=0;
    shell = XtCreatePopupShell("mdialogShell",transientShellWidgetClass,
			       toplevel,args,iargs);
    form = XtCreateManagedWidget("mdForm",formWidgetClass,shell,args,iargs);

    iargs=0;
    XtSetArg(args[iargs], XtNlabel ,labels) ; iargs++;
    box=XtCreateManagedWidget("mdgLabel",labelWidgetClass,form,args,iargs);
    /* An array of Widgets */
    iargs=0;
    XtSetArg(args[0],XtNfont, &temp_font);  iargs++;
    XtGetValues(box, args, iargs);
    width =Max(char_width(temp_font),1);
    dialoglist=(Widget *)malloc((unsigned) (*nv)*sizeof(Widget));
    if ( dialoglist == (Widget *) NULL) 
      {
	Scistring("Malloc : No more place");
	/** Warning : ierr is not realy used up to now **/
	ierr=1; return;
      }
    mxdesc=5;
    mxini=5;
    for (i=0 ; i<*nv ; i++) 
      {
	siz=strlen(description[i]);mxdesc=Max(siz,mxdesc);
	siz=strlen(valueinit[i]);  mxini=Max(siz,mxini);
      }
    for (i=0 ; i<*nv ; i++) 
      {
	iargs=0;
	XtSetArg(args[iargs], XtNfromVert , box) ; iargs++;
	box=XtCreateManagedWidget("mdlForm",formWidgetClass,form,args,iargs);
	iargs=0;
	XtSetArg(args[iargs], XtNlabel ,description[i]) ; iargs++;
	XtSetArg(args[iargs], XtNwidth ,(mxdesc+1)*width) ; iargs++;
	label=XtCreateManagedWidget("mdlLabel",labelWidgetClass,box,args,iargs);
	iargs=0;
	XtSetArg(args[iargs], XtNfromHoriz ,label) ; iargs++;
	XtSetArg(args[iargs], XtNwidth ,(mxini+4)*width) ; iargs++;
	XtSetArg(args[iargs], XtNstring ,valueinit[i]) ; iargs++;
	dialoglist[i]=XtCreateManagedWidget("mdlAscii",asciiTextWidgetClass,
					    box,args,iargs);
      }
    iargs=0;
    XtSetArg(args[iargs], XtNfromVert , box) ; iargs++;
    box=XtCreateManagedWidget("lForm",formWidgetClass,form,args,iargs);
    iargs = 0;
/*    XtSetArg(args[iargs], XtNlabel, buttonname[0] ); iargs++;*/
    wid=XtCreateManagedWidget("okCommand",commandWidgetClass,box,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)mDialogOk ,(XtPointer) *nv);  
    iargs = 0;
/*    XtSetArg(args[iargs], XtNlabel, buttonname[1] ); iargs++;*/
    wid=XtCreateManagedWidget("cancelCommand",commandWidgetClass,
			      box,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)mDialogCancel ,(XtPointer) *nv);  
    /*    XtPopup(shell,XtGrabExclusive);*/
    XtMyLoop(shell,dpy);
    if (ok_Flag_sci == -1) *nv=0;
}

testmDialogWindow()
{
  int nv;
  static String labels = "LaBel";
  static String description[] = {
    "first list entry",
    "second list entry",
    "third list entry",
    "fourth list entry",
    NULL
    };
  static String valueinit[] = {
    "1","2","3","4",
    NULL
    };
  nv=4;
  str=(char **) malloc((unsigned) (nv+1)*sizeof(char *));
  mDialogWindow(labels,description,valueinit,&nv);
}
