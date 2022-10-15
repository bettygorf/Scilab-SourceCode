#include "scilab_d.h"

extern void ShellFormCreate();

static char **str;
static void mDialogWindow();

/* Interface with Scilab */

void C2F(xmdial)(label,ptrlab,nlab,value,ptrv,desc,ptrdesc,nv,res,ptrres,ierr)
     int *label,*ptrlab,*nlab,*value,*ptrv,*desc,*ptrdesc,*nv,*res,*ptrres,*ierr;
{
  int i,nr,nv1,ni;
  char **description,**valueinit,*labels;
  /** int  maxchars= *ierr; Il faudrait utiliser maxchars **/
  *ierr=0;
  /* conversion of scilab characters into strings */
  ScilabMStr2C(label,nlab,ptrlab,&labels,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(desc,nv,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(value,nv,ptrv,&valueinit,ierr);
  if ( *ierr == 1) return;
  str=(char **) MALLOC( (*nv+1)*sizeof(char *));
  if ( str == ( char **) 0)  {      *ierr = 1; return;}
  nv1= *nv;
  mDialogWindow(labels,description,valueinit,nv);
  FREE(labels);
  for (i=0;i< nv1;i++) FREE(valueinit[i]); FREE(valueinit);
  for (i=0;i< nv1;i++) FREE(description[i]); FREE(description);
  if (*nv!=0)
    {
      int job=0;
      nr=0;
      ptrres[0]=1;
      for (i=1;i<*nv+1;i++) {
	ni=strlen(str[i-1]);
	ptrres[nr+1]=ptrres[nr]+ni;
	nr=nr+1;
	F2C(cvstr)(&ni,res,str[i-1],&job,(long int) 0);
	res+=ni;
	FREE(str[i-1]);
      }
      FREE(str);
    }
}

/* X Window Part */

static Widget  *dialoglist;
extern int ok_Flag_sci;

static XtCallbackProc
mDialogOk(w,nv,callData)
     Widget w;
     caddr_t callData;
     int nv;
{ int ind,i,ns;
  Arg args[2];
  Cardinal iargs;
  String str1,p;
  for (i=0;i<nv;i++) {
    iargs=0;
    XtSetArg(args[iargs], XtNstring, &str1); iargs++ ;
    XtGetValues(dialoglist[i],args,iargs);
    ns=strlen(str1);
    p=(char *) MALLOC((ns+1)*sizeof(char));
    if (p == 0) { Scistring("Malloc : No more place");return;}
    strcpy(p,str1);
    ind = ns - 1 ;
    if (p[ind] == '\n' ) p[ind] = '\0' ;
    str[i]=p;
  }
  FREE(dialoglist);
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
     char **description, **valueinit;
     char *labels;
     int *nv;
{
  Arg args[10];
  Cardinal iargs = 0;
  Dimension maxh1,maxw1,maxw2,maxh2,w1,w2,h1,h2;
  int i,mxdesc,mxini,siz;
  Widget shell,label,kform; 
  Widget lviewport, dviewport,dform1,dform,ok,cancel,cform;
  static Display *dpy = (Display *) NULL;

  /* Top shell with a form inside */

  ShellFormCreate("mdialogShell",&shell,&dform,&dpy);

  /* Create a Viewport+Label and resize it */

  ViewpLabelCreate(dform,&label,&lviewport,labels);

  iargs=0;
  dviewport = XtCreateManagedWidget("dViewport",viewportWidgetClass,
				      dform, args, iargs);
  iargs=0;
  dform1 = XtCreateManagedWidget("form",formWidgetClass,
				      dviewport, args, iargs);

  /* Allocate an array of Widgets */
  dialoglist=(Widget *)MALLOC( (*nv)*sizeof(Widget));
  if ( dialoglist == (Widget *) NULL) 
    {
      Scistring("Malloc : No more place");
      /** Warning : ierr is not realy used up to now 	ierr=1; **/
      return;
    }
  
  /* Compute common sizes for ascii and labels  */

  mxdesc=5;
  mxini=5;
  for (i=0 ; i<*nv ; i++) 
    {
      siz=strlen(description[i]);mxdesc=Max(siz,mxdesc);
      siz=strlen(valueinit[i]);  mxini=Max(siz,mxini);
    }
  mxini=Min(mxini+10,60);

  /* Widgets creation */
  kform = (Widget)0;
  for (i=0 ; i<*nv ; i++) 
      {
	iargs=0;
	XtSetArg(args[iargs], XtNfromVert,kform);iargs++;
	kform=XtCreateManagedWidget("kForm",formWidgetClass,dform1,
				      args,iargs);
	iargs=0;
	label=XtCreateManagedWidget("kLabel",labelWidgetClass,kform,
				    args,iargs);
	iargs=0;
	XtSetArg(args[iargs], XtNfromHoriz ,label) ; iargs++;
	dialoglist[i]=XtCreateManagedWidget("kAscii",asciiTextWidgetClass,
					    kform,args,iargs);
	if (i==0) 
	  {
	    /* chaque label sera mis a (w1,h1) 
	       et chaque ascii sera mis a (w2,h2) 
	       on regarde aussi la taille global prise par 
	       un label+un ascii de 60 caracteres pour limiter ensuite 
	       la fenetre globale
	       */
	    LabelSize(label,mxdesc+1,1,&w1,&h1);
	    AsciiSize(dialoglist[0],mxini,1,&w2,&h2);
	    h1=Max(h1,h2);
	    LabelSize(label,60,1,&maxw1,&maxh1);
	    AsciiSize(dialoglist[0],60,1,&maxw2,&maxh2);
	    maxw1=Max(maxw1,maxw2);
	    maxh1=Max(maxh1,maxh2);
	  }
	SetLabel(label,description[i],w1,h1);
	SetAscii(dialoglist[i],valueinit[i],w2,h1);
      }

  /* Buttons */
  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,dform,args,iargs);
  
  ButtonCreate(cform,&ok,(XtCallbackProc)mDialogOk,(XtPointer) *nv,"Ok","ok");
  ButtonCreate(cform,&cancel,(XtCallbackProc)mDialogCancel,(XtPointer) *nv,"Cancel","cancel");

  XtMyLoop(shell,dpy);
  if (ok_Flag_sci == -1) *nv=0;
}

/* A test function */

TestmDialogWindow()
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
  str=(char **) MALLOC( (nv+1)*sizeof(char *));
  mDialogWindow(labels,description,valueinit,&nv);
}

