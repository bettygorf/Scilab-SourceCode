#include "scilab_d.h"

#define OK 1
#define CANCEL 2
#define MEMERR 3

extern int ok_Flag_sci;

static int numChoix=1 ;
static char *filename = (char *) 0;
static char **PList = (char **) 0;
static char *Pbuffer = (char *) 0;
static void  ExposePrintdialogWindow();
static int ns;

#include "choice.h"

static char *Formats[] = {
  "Postscript",
  "Postscript-Latex",
  "Xfig",
};

static int nF=3;

/* main routine */

prtdlg(flag,printer,colored,orientation,file,ok)
     integer *colored,*orientation,*flag,*ok;
     char printer[],file[];
{ 
  int i;
  *ok=1;
  ExposePrintdialogWindow((int) *flag,colored,orientation);
  if ( ok_Flag_sci == OK) 
    {
      strcpy(printer,PList[numChoix-1]);
      if (*flag==2) {strcpy(file,filename);FREE(filename);}
    }
  else 
    {
      *ok=0;
    }
  if (*flag==1) 
    {
      FREE(Pbuffer);
      FREE(PList);
    }
}

/* test Function */

TestPrintDlg()
{
  static char file[100],printer[20];
  integer flag,colored,orientation,ok;
  prtdlg(&flag,printer,&colored,&orientation,file,&ok);
}

void 
PrintDlgOk(w,client_data,callData)
     Widget w;
     caddr_t client_data;
     caddr_t callData;
{
  ok_Flag_sci = OK;
}

void
SaveDlgOk(w,client_data,callData)
     Widget w;
     caddr_t client_data;
     caddr_t callData;
{
  Arg args[1];
  Cardinal iargs =0 ;
  Widget dialog = (Widget) client_data;
  int * i,ind;
  char * str;
  iargs=0;
  XtSetArg(args[iargs], XtNstring, &str); iargs++;
  XtGetValues( dialog, args, iargs);
  filename= (char *) MALLOC( (strlen(str)+1)*(sizeof(char)));
  if (filename != 0)
    {
      strcpy(filename,str);
      ind = strlen(filename) - 1 ;
      if (filename[ind] == '\n') filename[ind] = '\0' ;
      ok_Flag_sci = OK;
    }
  else 
    {
      Scistring("Malloc : No more place");
      ok_Flag_sci = MEMERR;
    }

}


void 
PrintDlgCancel(w,client_data,callData)
     Widget w;
     caddr_t client_data;
     caddr_t callData;
{
  ok_Flag_sci = CANCEL;
}

static void 
DoChoosePrinter(widget,client_data,callData)
     Widget widget;
     caddr_t client_data,callData;
{
  XawListReturnStruct* item;
  item = (XawListReturnStruct*)callData;
  numChoix = (item->list_index)+1 ;
}

static int
SetList(flag)
     int flag;
{
  int n,i,npr;
  char *getenv(),*str,*p;
  if (flag == 1) 
    {
      /* searching for printers */

      if ( (str=getenv("PRINTERS")) == 0) str="lp";
      n=strlen(str);
      if (n==0) 
	{
	  str="lp";n=strlen(str);
	}
      /* counting number of printers */
      npr=1;
      for (i=0 ; str[i] != '\0' ;i++)
	if(str[i]==':' ) npr++;
      PList=(char **) MALLOC((npr)*sizeof(char *));
      Pbuffer=(char *) MALLOC( (strlen(str)+1)*sizeof(char));
      if ( Pbuffer != (char *) 0 && PList != (char **) 0)
	{
	  strcpy(Pbuffer,str);
	  ns=0;
	  while ( ns < npr ) 
	    {
	      p=(ns == 0) ? strtok(Pbuffer,":") : strtok((char *)0,":");
	      PList[ns]=p;
	      ns++;
	    }
	}
      else 
	{
	  sciprint("x_choices : No more place\r\n");
	  ok_Flag_sci = MEMERR;
	  return(MEMERR);
	}
    }
  else 
    {
      PList=Formats;
      ns=nF;
    }
  return(OK);
}

static void  
ExposePrintdialogWindow(flag,colored,orientation)
     int flag,*colored,*orientation;
{
  static Display *dpy = (Display *) NULL;
  Widget shell,dform,chooseviewport,cancel,ok,dpanned,cform,form;
  Widget chooselist,lbox, tbox,cbox,filedialog,fbox,w;
  int one = 1, two = 2,i;
  Arg args[10];
  Cardinal iargs = 0;
  static char* items[] = {
    "Type",    "color",    "black&white",
    NULL,
    "Orientation",    "landscape",    "portrait",
    NULL
    };
  static int defval[]={1,0};
  static int nitems= 2;

  /* computing list of printers or file type */

  if (SetList(flag)== MEMERR) return;

  /* top level shell */

  ShellFormCreate("printShell",&shell,&dpanned,&dpy);

  /* Window Label */
  iargs=0;
  form=XtCreateManagedWidget("form",formWidgetClass,dpanned,args,iargs);
  iargs = 0;
  XtSetArg(args[iargs], XtNlabel, (flag == 1) ? "Printer Selection" : "Format Selection"); iargs++;
  XtCreateManagedWidget("label",labelWidgetClass,form,args, iargs);

  iargs=0;
  XtSetArg(args[iargs], XtNlist, PList); iargs++;
  XtSetArg(args[iargs], XtNnumberStrings, ns); iargs++;
  chooselist=XtCreateManagedWidget("list",listWidgetClass,form,args,iargs);
  XtAddCallback(chooselist, XtNcallback,(XtCallbackProc)DoChoosePrinter , (XtPointer)0);
  XawListHighlight(chooselist,numChoix-1);
  
  /* Toggles */

  if ( SciChoiceCreate(items,defval,nitems) == 0) 
    {
      sciprint("x_choices : No more place\r\n");
      ok_Flag_sci = MEMERR;
      return;
    };
  iargs=0;
  form=XtCreateManagedWidget("choiceform",formWidgetClass,dpanned,args,iargs);
  (void) create_choices(form,(Widget) NULL);

  if (flag==2) 
    {
      /* create label widget */
      iargs=0;
      fbox=XtCreateManagedWidget("fileform",formWidgetClass,dpanned,args,iargs);
      XtCreateManagedWidget("filelabel",labelWidgetClass, fbox,args, iargs);
      filedialog = XtCreateManagedWidget("ascii",asciiTextWidgetClass,
				       fbox, args, iargs);
    }
  /* command widgets */

  iargs=0;
  cform = XtCreateManagedWidget("cform",formWidgetClass,dpanned,args,iargs);
  if ( flag == 1) 
    ButtonCreate(cform,&ok,(XtCallbackProc) PrintDlgOk , (XtPointer) 0,"Ok","ok");
  else 
    ButtonCreate(cform,&ok,(XtCallbackProc) SaveDlgOk, (XtPointer) filedialog,"Ok","ok");

  ButtonCreate(cform,&cancel,(XtCallbackProc) PrintDlgCancel,(XtPointer) NULL,"Cancel","cancel");

  XtMyLoop(shell,dpy);
  
  if (   ok_Flag_sci== OK ) 
    {
      *colored=defval[0] = Everything[0]->choice.default_toggle +1 ;
      *orientation=defval[1] = Everything[1]->choice.default_toggle +1;
    }
  SciChoiceFree(nitems);
}





