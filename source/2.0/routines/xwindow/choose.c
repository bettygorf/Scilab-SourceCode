#include "scilab_d.h"
#include "../machine.h"

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2
#define X 147
#define Y 33

static  Widget toplevel;
extern XtAppContext app_con;
extern int ok_Flag_sci;
static int numChoix ;

static void CancelChoose(w,shell,callData)
     Widget w;
     caddr_t shell,callData;
{
  ok_Flag_sci = CANCEL;
}

static void DoChoose(widget,shell,callData)
     Widget widget;
     caddr_t shell,callData;
{
  XawListReturnStruct* item;
  item = (XawListReturnStruct*)callData;
  numChoix = item->list_index ;
  ok_Flag_sci = CHOOSE;
}

static void  ExposeChooseWindow(strings,description,buttonname)
     char **strings;
     char *description;
     char **buttonname;
{
    Widget choosebox,wid,list,shell,chooseport,chooselabel;
    Arg args[10];
    int iargs = 0;
    int width,i,height;
    XFontStruct *font;
    static Display *dpy = (Display *) NULL;

    DisplayInit("",&dpy,&toplevel);
    font = XLoadQueryFont(dpy,XWMENUFONT);
    height=font->ascent+font->descent;

    XtSetArg(args[iargs], XtNx, X + 10); iargs++;
    XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT + 10); iargs++;
    shell = XtCreatePopupShell("chooseshell",transientShellWidgetClass,toplevel,
			       args,iargs);
    choosebox = XtCreateManagedWidget("choosebox",boxWidgetClass,
				      shell,(Arg *) NULL,(int)ZERO);


    iargs = 0;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    XtSetArg(args[iargs], XtNlabel, description); iargs++;
    chooselabel = XtCreateManagedWidget("labelchoose",labelWidgetClass,
					choosebox,args,iargs);
    iargs = 0;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    XtSetArg(args[iargs], XtNlabel, buttonname[0]); iargs++;
    wid=XtCreateManagedWidget("cancelcommand",commandWidgetClass,
			      choosebox,args,iargs);
    XtAddCallback(wid, XtNcallback,(XtCallbackProc)CancelChoose , NULL);  


    width = 0; i = 0;
    while(strings[i] != NULL) {
	width = Max(width,XTextWidth(font,strings[i],strlen(strings[i])));
	i++;
    }
    width = width + 20;
    height=Min(i+2,30)*(height+1);
    
    iargs = 0;
    XtSetArg(args[iargs], XtNallowVert, TRUE); iargs++;
    XtSetArg(args[iargs], XtNheight, height); iargs++;
    XtSetArg(args[iargs], XtNwidth, width); iargs++;
    XtSetArg(args[iargs], XtNfromHoriz, NULL); iargs++;
    XtSetArg(args[iargs], XtNfromVert, chooselabel); iargs++;
    XtSetArg(args[iargs], XtNtop, XtChainTop); iargs++;
    chooseport = XtCreateManagedWidget("chooseport",viewportWidgetClass,
				       choosebox,args,iargs);
    
    iargs = 0;
    XtSetArg(args[iargs], XtNfont, font); iargs++;
    XtSetArg(args[iargs], XtNlist, strings); iargs++;
    XtSetArg(args[iargs], XtNcolumnSpacing, 0); iargs++;
    XtSetArg(args[iargs], XtNdefaultColumns, 1); iargs++;
    
    list=XtCreateManagedWidget("choose",listWidgetClass,chooseport,args,iargs);
    XtAddCallback(list, XtNcallback,(XtCallbackProc)DoChoose , NULL);  
    
    XtMyLoop(shell,dpy);
}

void C2F(xchoose)(desc,ptrdesc,nd,basstrings,nstring,ptrstrings,btn,ptrbtn,nb,nrep,ierr)
     int *desc,*ptrdesc,*nd,*basstrings,*nstring,*ptrstrings,*btn,*nb,*ptrbtn,*nrep,*ierr;
{ 
  void C2F(cvstr)(), ExposeChooseWindow();
  int i;
  char **strings, *description,**buttonname;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(btn,nb,ptrbtn,&buttonname,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(basstrings,nstring,ptrstrings,&strings,ierr);
  ExposeChooseWindow(strings,description,buttonname);
  for (i=0 ; i < *nstring ; i++ ) free((char*)strings[i]);
  free((char*)strings); 
  free(description);
  for (i=0 ; i < *nb ; i++ )free((char*)buttonname[i]);
  free(buttonname);
  if ( ok_Flag_sci == CHOOSE) 
    *nrep=(1+numChoix);
  else *nrep=0;
};

