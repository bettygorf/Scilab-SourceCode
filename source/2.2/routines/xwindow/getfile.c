
#include "scilab_d.h"

extern XtAppContext app_con;  
extern void ShellFormCreate();
extern void C2F(cvstr)();
extern int ok_Flag_sci; 
void GetFileWindow();
extern Widget file_popup;
extern Boolean	file_msg_is_popped;
extern Widget	file_msg_popup;

extern Cursor      cur_wf_cursor,arrow_wf_cursor,wait_wf_cursor;
static char *str = (char *) 0;
     
/* interface with scilab */

/* 
   interface pour intersci on a ensuite un peu modifie le 
   code genere ( rajout de ierr )

*/
     
void C2F(xgetfile)(filemask,dirname,res,ires,ierr,rhs)
     char *filemask,**res,*dirname;
     integer *ierr,*ires,*rhs;
{
  int flag=0;
  *ierr = 0;
  if ( *rhs == 2) flag =1 ;
  GetFileWindow(filemask,dirname,flag);
  if ( ok_Flag_sci == -1 ) 
    {
      /* Cancel */
      *ires = 0 ;
      return;
    }
  if ( str == (char *) 0) 
    {
      /* BUG */
      *ires = 0;
      *ierr = 1;
      return;
    }
  *res = (char *) MALLOC((strlen(str)+1)*sizeof(char));
  if (*res == (char *) 0) 
    {
      Scistring("Malloc : No more place");
      *ierr = 1;
      return ;
    }
  strcpy(*res,str);
  *ires=strlen(str);
}

/* test function */

TestGetFile() 
{
  static String init ="*.sci";
  GetFileWindow(init,".",0);
}

/** Really Ugly I'm ashamed **/

void   GetFileWindow(filemask,dirname,flag)
     char *filemask,*dirname;
     int flag;
{
  int err=0;
  static Display *dpy = (Display *) NULL;
  static  Widget toplevel,toplevel1;
  getMenuBut0(&toplevel);
  DisplayInit("",&dpy,&toplevel1);
  if ( toplevel == (Widget) 0) 
    {
      /* we are in scilab -nw */
      toplevel = toplevel1;
    }
  popup_file_panel1(toplevel);
  ok_prep(filemask,dirname,flag,&err);
  if ( err != 1 )   XtSpecialLoop();
  ok_end();
  XtSetSensitive(toplevel,True);
}

XtSpecialLoop()
{
  XEvent event;
  ok_Flag_sci= 0;
  for (;;) {
    XtAppNextEvent(app_con,&event);
    XtDispatchEvent(&event);
    if (ok_Flag_sci != 0) break;
  }
}

/* The cancel command callback */

cancel_getfile() 
{ 
  ok_Flag_sci = -1;
}

/* Activated when file is choosed */

write_getfile(dir,file)
     char dir[],file[];
{
  str = (char *) MALLOC( (strlen(dir)+strlen(file)+2)*(sizeof(char)));
  if (str != 0)
    { 
      int ind ;
      sprintf(str,"%s/%s",dir,file);
      ind = strlen(str) - 1 ;
      if (str[ind] == '\n') str[ind] = '\0' ;
    }
  else 
    Scistring("Malloc : No more place");
  ok_Flag_sci= 1;
}

popup_file_panel1(w)
    Widget	    w;
{
    extern Atom     wm_delete_window;
    w_init(w);
    set_temp_wf_cursor(wait_wf_cursor);
    XtSetSensitive(w, False);
    if (!file_popup)
	create_file_panel(w);
    else
      Rescan((Widget) 0, (XEvent*) 0, (String*) 0, (Cardinal*) 0);

    XtPopup(file_popup, XtGrabNonexclusive);
    (void) XSetWMProtocols(XtDisplay(file_popup), XtWindow(file_popup),
			   &wm_delete_window, 1);
    if (file_msg_is_popped)
	XtAddGrab(file_msg_popup, False, False);
    reset_wf_cursor();
}





