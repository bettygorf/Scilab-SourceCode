#include "scilab_d.h"
#include "../machine.h"
static char **str;

void C2F(cvstr)();
static void MatrixDialogWindow();

void C2F(xmatdg)(label,ptrlab,nlab,value,ptrv,descv,ptrdescv,desch,ptrdesch,nl,nc,res,ptrres,ierr)
     int *label,*ptrlab,*nlab,*value,*ptrv,*descv,*ptrdescv,*desch,*ptrdesch,*nl,*nc,*res,*ptrres,*ierr;
{

  int i,ni,nr,maxchars,nv,nl1,nc1;
  char **descriptionh, **descriptionv,**valueinit,*labels;
  maxchars= *ierr;/** Il faudrait utiliser maxchars **/
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
  str=(char **) malloc((unsigned) (nv+1)*sizeof(char *));
  nl1 = *nl;
  nc1 = *nc;
  MatrixDialogWindow(labels,descriptionv,descriptionh,valueinit,nl,nc);
  free((char*)labels);
  for (i=0;i< nl1*nc1;i++) free((char*)valueinit[i]); free((char*)valueinit);
  for (i=0;i< nl1;i++) free((char*)descriptionv[i]); free((char*)descriptionv);
  for (i=0;i< nc1;i++) free((char*)descriptionh[i]); free((char*)descriptionh);
  if (*nl!=0)
    {
      int job=0;
      nr=0;
      ptrres[0]=1;
      for (i=1;i<nv+1;i++) {
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
matDialogOk(w,nv,callData)
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
matDialogCancel(w,nv,callData)

     Widget w;
     caddr_t callData;
     int  nv;
{ 
  matDialogOk(w,nv,callData);
  ok_Flag_sci = -1;
}

static void MatrixDialogWindow(labels,descriptionv,descriptionh,valueinit,nl,nc)
     char **descriptionv,**descriptionh;
     char ** valueinit;
     char *labels;
     int *nl,*nc;
  {
    Arg args[12];
    XFontStruct *font;
    int fontwidth=9;
    int iargs = 0,i,j,ierr,mxdesc,smxini,mxini[500],siz;
    Widget shell,wid,form,box,label,label2;
    Widget *w;
    char dialName[9],boxName[9];
    int nv;
    static Display *dpy = (Display *) NULL;

    DisplayInit("",&dpy,&toplevel);
    font = XLoadQueryFont(dpy,XWMENUFONT);

    nv = *nl*(*nc);

    iargs=0;
    XtSetArg(args[iargs], XtNx, X + 10); iargs++ ;
    XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT +10); iargs++;
    XtSetArg(args[iargs], XtNallowShellResize, True); iargs++;
    XtSetArg(args[iargs], XtNvertDistance ,1) ; iargs++;
    shell = XtCreatePopupShell("dialogshell",transientShellWidgetClass,
			       toplevel,args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNresizable , TRUE) ; iargs++;
    form = XtCreateManagedWidget("message",formWidgetClass,shell,args,iargs);

    iargs=0;
    XtSetArg(args[iargs], XtNlabel ,labels) ; iargs++;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    box=XtCreateManagedWidget("text",labelWidgetClass,form,args,iargs);
    /* An array of Widgets */
    dialoglist=(Widget *)malloc((unsigned) (nv)*sizeof(Widget));
    if ( dialoglist == (Widget *) NULL) 
      {
	/** Warning : ierr is not realy used up to now **/
	ierr=1; return;
      }

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
    iargs=0;
    XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
    XtSetArg(args[iargs], XtNresizable ,TRUE) ; iargs++;
    XtSetArg(args[iargs], XtNorientation , "horizontal") ; iargs++;
    XtSetArg(args[iargs], XtNfromVert , box) ; iargs++;
    XtSetArg(args[iargs], XtNvertDistance ,1) ; iargs++;
/*    XtSetArg(args[iargs], XtNwidth ,(mxdesc+smxini+5)*fontwidth) ; iargs++;*/
    box=XtCreateManagedWidget(" ",formWidgetClass,form,args,iargs);
    iargs=0;
    XtSetArg(args[iargs], XtNlabel ," ") ; iargs++;
    XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
    XtSetArg(args[iargs], XtNwidth ,(mxdesc+1)*fontwidth) ; iargs++;
    XtSetArg(args[iargs], XtNright ,"left") ; iargs++;
    XtSetArg(args[iargs], XtNleft ,"left") ; iargs++;
    XtSetArg(args[iargs], XtNtop ,"top") ; iargs++;
    XtSetArg(args[iargs], XtNbottom ,"top") ; iargs++;
    label=XtCreateManagedWidget("text",labelWidgetClass,box,args,iargs);
    label2=label;
    for (j=0 ; j<*nc ; j++)
      {
	iargs=0;
	XtSetArg(args[iargs], XtNfromHoriz ,label2) ; iargs++;
	XtSetArg(args[iargs], XtNlabel ,descriptionh[j]) ; iargs++;
	XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
	XtSetArg(args[iargs], XtNwidth ,(mxini[j]+4)*fontwidth) ; iargs++;
	XtSetArg(args[iargs], XtNresize ,"both") ; iargs++;
	XtSetArg(args[iargs], XtNhorizDistance ,4) ; iargs++;
	XtSetArg(args[iargs], XtNresizable ,TRUE) ; iargs++;
	XtSetArg(args[iargs], XtNfont, font); iargs++;
	label2=XtCreateManagedWidget("text",labelWidgetClass,box,args,iargs);
      }
    
    for (i=0 ; i<*nl ; i++) 
      {
	sprintf(dialName,"dialog%d",i);
	sprintf(boxName,"box%d",i);
	iargs=0;
	XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
	XtSetArg(args[iargs], XtNresizable ,TRUE) ; iargs++;
	XtSetArg(args[iargs], XtNorientation , "horizontal") ; iargs++;
	XtSetArg(args[iargs], XtNfromVert , box) ; iargs++;
	XtSetArg(args[iargs], XtNvertDistance ,1) ; iargs++;
	box=XtCreateManagedWidget(boxName,formWidgetClass,form,args,iargs);
	iargs=0;
	XtSetArg(args[iargs], XtNlabel ,descriptionv[i]) ; iargs++;
	XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
	XtSetArg(args[iargs], XtNwidth ,(mxdesc+1)*fontwidth) ; iargs++;
	XtSetArg(args[iargs], XtNright ,"left") ; iargs++;
	XtSetArg(args[iargs], XtNleft ,"left") ; iargs++;
	XtSetArg(args[iargs], XtNtop ,"top") ; iargs++;
	XtSetArg(args[iargs], XtNbottom ,"top") ; iargs++;
	XtSetArg(args[iargs], XtNfont, font); iargs++;
	label=XtCreateManagedWidget("text",labelWidgetClass,box,args,iargs);
	label2=label;
	for (j=0 ; j<*nc ; j++)
	  {
	    iargs=0;
	    XtSetArg(args[iargs], XtNfromHoriz ,label2) ; iargs++;
	    XtSetArg(args[iargs], XtNstring ,valueinit[j*(*nl)+i]) ; iargs++;
	    XtSetArg(args[iargs], XtNwidth ,(mxini[j]+4)*fontwidth) ; iargs++;
	    XtSetArg(args[iargs], XtNeditType ,XawtextEdit) ; iargs++;
	    XtSetArg(args[iargs], XtNresize ,"both") ; iargs++;
	    XtSetArg(args[iargs], XtNhorizDistance ,4) ; iargs++;
	    XtSetArg(args[iargs], XtNresizable ,TRUE) ; iargs++;
	    XtSetArg(args[iargs], XtNfont, font); iargs++;
	    label2=XtCreateManagedWidget(dialName,
					asciiTextWidgetClass,box,args,iargs);
	    dialoglist[j*(*nl)+i]=label2;
	  }
      }
    iargs=0;
    XtSetArg(args[iargs], XtNborderWidth ,0) ; iargs++;
    XtSetArg(args[iargs], XtNorientation , "horizontal") ; iargs++;
    XtSetArg(args[iargs], XtNfromVert , box) ; iargs++;
    box=XtCreateManagedWidget(boxName,boxWidgetClass,form,args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, "Ok" ); iargs++;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    wid=XtCreateManagedWidget("okbutton",commandWidgetClass,
			      box,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)matDialogOk ,(XtPointer) nv);  
    iargs = 0;
    XtSetArg(args[iargs], XtNlabel, "Cancel" ); iargs++;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    wid=XtCreateManagedWidget("cancelbutton",commandWidgetClass,
			      box,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)matDialogCancel ,(XtPointer) nv);  
/*    XtPopup(shell,XtGrabExclusive);*/
    XtMyLoop(shell,dpy);
    if (ok_Flag_sci == -1) *nl=0;
}
