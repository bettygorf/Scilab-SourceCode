#include "scilab_d.h"

extern void ShellFormCreate();
extern void C2F(cvstr)();

static char **str;
static void MatrixDialogWindow();

void C2F(xmatdg)(label,ptrlab,nlab,value,ptrv,descv,ptrdescv,desch,ptrdesch,nl,nc,res,ptrres,ierr)
     int *label,*ptrlab,*nlab,*value,*ptrv,*descv,*ptrdescv,*desch,*ptrdesch,*nl,*nc,*res,*ptrres,*ierr;
{

  int i,ni,nr,nv,nl1,nc1;
  char **descriptionh, **descriptionv,**valueinit,*labels;
  /** int maxchars= *ierr; Il faudrait utiliser maxchars **/
  *ierr=0;
  nv = *nl*(*nc);
  /* conversion of scilab characters into strings */
  ScilabMStr2C(label,nlab,ptrlab,&labels,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(descv,nl,ptrdescv,&descriptionv,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(desch,nc,ptrdesch,&descriptionh,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(value,&nv,ptrv,&valueinit,ierr);
  if ( *ierr == 1) return;
  str=(char **) MALLOC( (nv+1)*sizeof(char *));
  if (str == (char **) 0) { Scistring("Malloc : No more place");*ierr=1;return;}
  nl1 = *nl;
  nc1 = *nc;
  MatrixDialogWindow(labels,descriptionv,descriptionh,valueinit,nl,nc);
  FREE(labels);
  for (i=0;i< nl1*nc1;i++) FREE(valueinit[i]); FREE(valueinit);
  for (i=0;i< nl1;i++) FREE(descriptionv[i]); FREE(descriptionv);
  for (i=0;i< nc1;i++) FREE(descriptionh[i]); FREE(descriptionh);
  if (*nl!=0)
    {
      int job=0;
      nr=0;
      ptrres[0]=1;
      for (i=1;i<nv+1;i++) {
	ni=strlen(str[i-1]);
	ptrres[nr+1]=ptrres[nr]+ni;
	nr=nr+1;
	F2C(cvstr)(&ni,res,str[i-1],&job,(long int)0);
	res+=ni;
	FREE(str[i-1]);
      }
      FREE(str);
    }
}


/* A test function */

TestMatrixDialogWindow()
{
  int nl=3,nc=2;
  static String labels = "LaBel";
  static String descriptionv[] = {
    "row 1","row 2","row 3",
    NULL
    };
  static String descriptionh[] = {
    "col 1","col 2",
    NULL
    };
  static String valueinit[] = {
    "1","2","3","4","5","6",
    NULL
    };
  str=(char **) MALLOC( (nl*nc+1)*sizeof(char *));
  if (str == (char **) 0) { Scistring("Malloc : No more place");return;}
  MatrixDialogWindow(labels,descriptionv,descriptionh,valueinit,&nl,&nc);
}



/* X Window Part */

static Widget  *dialoglist,*labellistH, *labellistV;
extern int ok_Flag_sci;

static XtCallbackProc
matDialogOk(w,nv,callData)
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
  FREE( dialoglist);
  FREE( labellistH);
  FREE( labellistV);
  ok_Flag_sci = 1;
}

static XtCallbackProc 
matDialogCancel(w,nv,callData)
     Widget w;
     caddr_t callData;
     int  nv;
{ 
  matDialogOk(w,nv,callData);
  ok_Flag_sci = -1;
}

#define MAXLINES 16
#define MAXWIDTH 900

static void 
MatrixDialogWindow(labels,descriptionv,descriptionh,valueinit,nl,nc)
     char **descriptionv,**descriptionh;
     char ** valueinit;
     char *labels;
     int *nl,*nc;
  {
    Dimension j_width,j_height;
    Arg args[12];
    Cardinal iargs=0;
    Dimension laij_width,laij_height;
    /* A revoir ce 500 inutile JPC */
    int i,j,mxdesc,smxini,mxini[500],siz, nv ;
    Widget shell,dform,label,rowi,ij,ij0,ok,cancel,lviewport,dviewport,form1,cform;
    static Display *dpy = (Display *) NULL;
    nv = *nl*(*nc);

    ShellFormCreate("mtdialogShell",&shell,&dform,&dpy);

    /* Create a Viewport+Label and resize it */
    
    ViewpLabelCreate(dform,&label,&lviewport,labels);

    iargs=0;
    dviewport = XtCreateManagedWidget("dViewport",viewportWidgetClass,
				      dform, args, iargs);
    iargs=0;
    form1 = XtCreateManagedWidget("form",formWidgetClass,
					  dviewport , args, iargs);

    /* Allocate an array of Widgets */
    dialoglist=(Widget *)MALLOC( (nv)*sizeof(Widget));
    labellistH=(Widget *)MALLOC( (*nc)*sizeof(Widget));
    labellistV=(Widget *)MALLOC( (*nl)*sizeof(Widget));
    if ( dialoglist == (Widget *) 0 || labellistH == (Widget *) 0 || labellistV == (Widget *) 0) 
      {
	/** Warning : ierr is not realy used up to now 
	  ierr=1; **/
	return;
      } 

    /* maximum sizes */

    mxdesc=0;
    for (i=0 ; i<*nl ; i++)
      {
        siz=strlen(descriptionv[i]);mxdesc=Max(siz,mxdesc);
      }
    smxini=0;
    for (j=0 ; j<*nc ; j++)
      {
        siz=strlen(descriptionh[j]);
        mxini[j]=siz;
        for (i=0 ; i<*nl ; i++)
          {
            siz=strlen(valueinit[i+j*(*nl)]);  mxini[j]=Max(siz,mxini[j]);
          }
        smxini=smxini+mxini[j];
      }

    /* The first row : a set of labels */

    iargs=0;
    rowi=XtCreateManagedWidget("rowi",formWidgetClass,form1,args,iargs);
    iargs=0;
    XtSetArg(args[iargs], XtNborderWidth,(Dimension) 0) ; iargs++;
    ij0=ij=XtCreateManagedWidget("label",labelWidgetClass,rowi,args,iargs);

    for (j=0 ; j<*nc ; j++)
      {
	iargs=0;
	XtSetArg(args[iargs], XtNfromHoriz,ij);iargs++;
	ij=labellistH[j]=XtCreateManagedWidget("label",labelWidgetClass,rowi,args,iargs);
      }

    /* The other rows */

    for (i=0 ; i<*nl ; i++) 
      {
	iargs=0;
	XtSetArg(args[iargs], XtNfromVert , rowi) ; iargs++;
	rowi=XtCreateManagedWidget("rowi",formWidgetClass,form1,args,iargs);
	iargs=0;
	ij=labellistV[i]=XtCreateManagedWidget("label",labelWidgetClass,rowi,args,iargs);
	for (j=0 ; j<*nc ; j++)
	  {
	    iargs=0;
	    XtSetArg(args[iargs], XtNfromHoriz ,ij) ; iargs++;
	    ij=XtCreateManagedWidget("ascii",asciiTextWidgetClass, rowi,args,iargs);
	    dialoglist[j*(*nl)+i]=ij;
	  }
      }
   
    /* resize `matrix' widget and fix init values */

    LabelSize(ij0,mxdesc+1,1,&laij_width,&laij_height);
    
    for (j=0 ; j<*nc ; j++)
      {
	AsciiSize(dialoglist[0],mxini[j],1,&j_width,&j_height);
	j_width=Max(j_width,laij_width);
	j_height=Max(j_height,laij_height);
	SetLabel(labellistH[j],descriptionh[j],j_width,j_height);
	for (i=0 ; i<*nl ; i++) 
	  SetAscii(dialoglist[j*(*nl)+i],valueinit[j*(*nl)+i],j_width,j_height);
      }
    SetLabel(ij0," ",laij_width,j_height);
    for (i=0 ; i<*nl ; i++) 
      SetLabel(labellistV[i],descriptionv[i],laij_width,j_height);

    /* The buttons */
    
    iargs=0;
    cform = XtCreateManagedWidget("cform",formWidgetClass,dform,args,iargs);

    ButtonCreate(cform,&ok,(XtCallbackProc)matDialogOk,(XtPointer) nv,
		 "Ok","ok");
    ButtonCreate(cform,&cancel,(XtCallbackProc)matDialogCancel,(XtPointer) nv,
		 "Cancel","cancel");

    XtMyLoop(shell,dpy);
    if (ok_Flag_sci == -1) *nl=0;
}

