#include <strings.h>



#include "ptyx.h"
#include "Tekparse.h"
#include "data.h"


void write_scilab(s)
    char   *s;
{
  str_to_xterm(s,strlen(s));
}

str_to_xterm ( string, nbytes)
    register char *string;
    int nbytes;
{
    register TScreen *screen = &term->screen;
    StringInput(screen,string,strlen(string));
}


