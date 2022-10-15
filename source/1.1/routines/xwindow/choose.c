#include "scilab_d.h"
#include "../machine.h"

extern int ok_Flag_sci;
static int numChoix ;

#define NOCHOOSE 0
#define CHOOSE 1
#define CANCEL 2

void C2F(xchoose)(desc,ptrdesc,nd,basstrings,nstring,ptrstrings,nrep,ierr)
     int *desc,*ptrdesc,*nd,*basstrings,*nstring,*ptrstrings,*nrep,*ierr;
{ 
  void C2F(cvstr)(), ExposeChooseWindow();
  int i;
  char **strings, *description;
  *ierr=0;
  ScilabMStr2C(desc,nd,ptrdesc,&description,ierr);
  if ( *ierr == 1) return;
  ScilabMStr2CM(basstrings,nstring,ptrstrings,&strings,ierr);
  ExposeChooseWindow(strings,description);
  for (i=0 ; i < *nstring ; i++ ) free((char*)strings[i]);
  free((char*)strings); 
  free(description);
  if ( ok_Flag_sci == CHOOSE) 
    *nrep=(1+numChoix);
  else *nrep=0;
};

#define X 147
#define Y 33
extern Widget toplevel;
extern XtAppContext app_con;

void CancelChoose(w,shell,callData)
     Widget w;
     caddr_t shell,callData;
{
  ok_Flag_sci = CANCEL;
}

void DoChoose(widget,shell,callData)
     Widget widget;
     caddr_t shell,callData;
{
  XawListReturnStruct* item;
  item = (XawListReturnStruct*)callData;
  numChoix = item->list_index ;
  ok_Flag_sci = CHOOSE;
}

void   ExposeChooseWindow(strings,description)
     char **strings;
     char *description;
{
  Widget choosebox,wid,list,shell;
  Arg args[10];
  int iargs = 0;
  XtSetArg(args[iargs], XtNx, X + 10); iargs++;
  XtSetArg(args[iargs], XtNy, Y + DIALOGHEIGHT + 10); iargs++;
  shell = XtCreatePopupShell("chooseshell",transientShellWidgetClass,toplevel,
			     args,iargs);
  choosebox = XtCreateManagedWidget("choosebox",boxWidgetClass,
				    shell,(Arg *) NULL,(int)ZERO);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, description); iargs++;
  XtCreateManagedWidget("labelchoose",labelWidgetClass,choosebox,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlist, strings); iargs++;
  XtSetArg(args[iargs], XtNcolumnSpacing, 0); iargs++;
  XtSetArg(args[iargs], XtNdefaultColumns, 1); iargs++;
  list=XtCreateManagedWidget("choose",listWidgetClass,choosebox,args,iargs);
  XtAddCallback(list, XtNcallback,DoChoose , NULL);  
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, "cancel " ); iargs++;
  wid=XtCreateManagedWidget("cancelcommand",commandWidgetClass,
			choosebox,args,iargs);
  XtAddCallback(wid, XtNcallback,CancelChoose , NULL);  
  XtMyLoop(shell);
}



