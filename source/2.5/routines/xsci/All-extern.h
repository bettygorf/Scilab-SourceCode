

#ifdef __STDC__
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		paramlist
#endif
#else	
#ifndef  _PARAMS
#define  _PARAMS(paramlist)		()
#endif
#endif

/*** elsewhere **/

extern int C2F (scilab) _PARAMS((int *nostartup));  
extern int C2F (scilines) _PARAMS((int *nl, int *nc));  
extern int C2F (sciquit) _PARAMS((void));  
extern void C2F(setfbutn)  _PARAMS((char *name,int *rep));

/*  "h_help-n.c.X1"*/
  extern void initHelpActions  _PARAMS((XtAppContext appContext));  
  extern void popupHelpPanel _PARAMS((void));  
  extern void changeHelpList  _PARAMS((int i));  
  extern void setHelpShellState  _PARAMS((int state));  
  extern char *getWidgetString  _PARAMS((Widget widget));  

/*  "jpc_SGraph-n.c.X1"*/

  extern int PushClickQueue _PARAMS((int,int ,int y,int ibut));
  extern int CheckClickQueue  _PARAMS((integer *,integer *x, integer *y, integer *ibut));  
  extern int ClearClickQueue  _PARAMS((integer));  

  extern int C2F (deletewin) _PARAMS((integer *number));  
  extern void SGDeleteWindow  _PARAMS((Widget w, XEvent *event, String *params, Cardinal *num_params));  

  extern void ChangeBandF  _PARAMS((int win_num, Pixel fg, Pixel bg));  
  extern int C2F (delbtn) _PARAMS((integer *win_num, char *button_name));  
  extern void AddMenu  _PARAMS((integer *win_num, char *button_name, char **entries, integer *ne, integer *typ, char *fname, integer *ierr));  
  extern int C2F (addmen) _PARAMS((integer *win_num, char *button_name, integer *entries, integer *ptrentries, integer *ne, integer *typ, char *fname, integer *ierr));  
  extern int C2F (setmen) _PARAMS((integer *win_num, char *button_name, integer *entries, integer *ptrentries, integer *ne, integer *ierr));  
  extern int C2F (unsmen) _PARAMS((integer *win_num, char *button_name, integer *entries, integer *ptrentries, integer *ne, integer *ierr));  

/*  "jpc_Xloop-n.c.X1"*/

  extern void SetXsciOn  _PARAMS((void));  
  extern int C2F (xscion) _PARAMS((int *i));  
  extern void DisplayInit  _PARAMS((char *string, Display **dpy, Widget *toplevel));  
  extern int Xorgetchar  _PARAMS((void));  
  extern int C2F (sxevents) _PARAMS((void));  
  extern int StoreCommand  _PARAMS((char *command));  
  extern void GetCommand  _PARAMS((char *str));  
  extern integer C2F (ismenu) _PARAMS((void));  
  extern int C2F (getmen) _PARAMS((char *btn_cmd, integer *lb, integer *entry));  
/*  "jpc_coloredit-n.c.X1"*/
  extern void popup_choice_panel  _PARAMS((Widget tool));  
  extern void create_color_panel  _PARAMS((Widget form, Widget cancel));  
  extern void cancel_color_popup  _PARAMS((Widget w, XtPointer dum1, XtPointer dum2));  
/*  "jpc_command-n.c.X1"*/
  extern void FileG1  _PARAMS((Widget w, XtPointer closure, caddr_t call_data));  
  extern void getMenuBut0  _PARAMS((Widget *w));  
  extern void MenuFixCurrentWin  _PARAMS((int ivalue));  
  extern void CreateCommandPanel  _PARAMS((Widget parent));  
/*  "jpc_inter-n.c.X1"*/
  extern void write_scilab  _PARAMS((char *s));  
/*  "jpc_utils-n.c.X1"*/
  extern void DisableWindowResize  _PARAMS((Widget w));  
  extern void bell  _PARAMS((int volume));  
  extern char *concat  _PARAMS((char *s1, char *s2));  

/*  "jpc_windows-n.c.X1"*/

  extern void DefaultMessageWindow  _PARAMS((void));  
/*   extern XtermWidget CreateSubWindows  _PARAMS((Widget parent));   */
  extern void set_scilab_icon  _PARAMS((void));  
  extern XtEventHandler UseMessage  _PARAMS((Widget w, Widget child, XClientMessageEvent *e));  
  extern void AddAcceptMessage  _PARAMS((Widget parent));  
  extern void ReAcceptMessage  _PARAMS((void));  
/*  extern XtermWidget CreateTermWindow  _PARAMS((Widget parent));  */
  extern void UpdateFileLabel  _PARAMS((char *string));  
  extern void UpdateLineLabel  _PARAMS((Cardinal line));  
  extern void UpdateMessageWindow  _PARAMS((char *format, char *arg));  

/*  "jpc_xwidgets-n.c.X1"*/
  extern void AddNewMenu  _PARAMS((Widget parent, Widget drawbox));  
/*  "wf_e_edit-n.c.X1"*/
  extern int panel_set_value  _PARAMS((Widget widg, char *val));  
  extern char *panel_get_value  _PARAMS((Widget widg));  
  extern void clear_text_key  _PARAMS((Widget w));  
  extern void paste_panel_key  _PARAMS((Widget w, XKeyEvent *event));  

/*  "wf_f_read-n.c.X1"*/

  extern void file_msg  _PARAMS((char *format, char *arg1));  
  extern void clear_file_message  _PARAMS((Widget w, XButtonEvent *ev));  
  extern void popup_file_msg  _PARAMS((void));  

/*  "wf_f_util-n.c.X1"*/
  extern int emptyname  _PARAMS((char *name));  
  extern int emptyname_msg  _PARAMS((char *name, char *msg));  
  extern int change_directory  _PARAMS((char *path));  
  extern int get_directory  _PARAMS((void));  

/*  "wf_w_cursor-n.c.X1"*/

  extern void init_wf_cursor  _PARAMS((void));  
  extern void reset_wf_cursor  _PARAMS((void));  
  extern void set_temp_wf_cursor  _PARAMS((Cursor cursor));  
  extern void set_wf_cursor  _PARAMS((Cursor cursor));  

/*  "wf_w_dir-n.c.X1"*/

  extern  void parseuserpath _PARAMS((char *path,char *longpath));

/*  "wf_w_file-n.c.X1"*/

  extern int exec_file  _PARAMS((char *dir, char *file));  
  extern void do_exec  _PARAMS((Widget w, XButtonEvent *ev));  
  extern void ok_file  _PARAMS((char *dir, char *file));  
  extern void ok_end  _PARAMS((void));  
  extern void ok_prep  _PARAMS((char *filemask, char *dirname, char *title,int flag, int *err));  
  extern void parsescipath  _PARAMS((char *path, char *longpath));  
  extern void do_ok  _PARAMS((Widget w, XButtonEvent *ev));  
  extern int getfc_file  _PARAMS((char *dir, char *file));  
  extern void do_getfc  _PARAMS((Widget w));  
  extern int linkf_file  _PARAMS((char *dir, char *file));  
  extern void do_linkf  _PARAMS((Widget w));  
  extern int getf_file  _PARAMS((char *dir, char *file));  
  extern void do_getf  _PARAMS((Widget w));  
  extern int load_file  _PARAMS((char *dir, char *file));  
  extern void do_load  _PARAMS((Widget w));  
  extern void popup_file_panel  _PARAMS((Widget w,char *));  
  extern void create_file_panel  _PARAMS((Widget w,char *));  

/*  "wf_w_init-n.c.X1"*/

  extern void w_init  _PARAMS((Widget w));  

/*  "wf_w_msgpanel-n.c.X1"*/

  extern void init_msg  _PARAMS((Widget tool,Widget vert_w, int ch, char *filename));  
  extern void update_cur_filename  _PARAMS((char *newname));  
  extern void put_msg  _PARAMS((char *,...)); 
  extern void clear_message  _PARAMS((void));  
  extern void FOpAddInfoHandler  _PARAMS((Widget widget, char *message));  

/*  "wf_w_setup-n.c.X1"*/

  extern void setup_sizes  _PARAMS((int new_canv_wd, int new_canv_ht));  

/*  "wf_w_util-n.c.X1"*/

  extern void  app_flush  _PARAMS((void));  

