#include <signal.h>
#include "Math.h"
#include <X11/Xlib.h>

extern int get_is_reading();
extern void set_echo_mode();

/* 
send asynchronous command to scilab 
Commands are neither echoed  nor memorized.
*/

void asynchron(str)
     char * str;
{
  int isok,ntfy,mode;
  int inter=SIGINT;
  
  C2F(gtsync)(&isok);
  C2F(gtntfy)(&ntfy);
  if ((isok==1) && (ntfy==1)) { /* no asynchronous command working */
    
    isok=0;
    C2F(stsync)(&isok);
    ntfy=0;
    C2F(stntfy)(&ntfy);
    /* disable echo and prompt. they will be automatically re-enabled 
       just after command has been taken into account */
    set_echo_mode(False);
    /* disable next prompt */
    C2F(getem)(&mode);
    mode = -mode-11;
    C2F(setem)(&mode);
    if (!get_is_reading()) 
      {/* scilab is working */
	C2F(sigbas)(&inter); /* ask scilab to interrupt its work */
	(void) strcat(str,";notify(1);return\n");
	write_scilab(str);
      }
    else
      {
	(void) strcat(str,"notify(1);\n");
	write_scilab(str);
      }
  }
}
