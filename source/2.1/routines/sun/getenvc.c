/* returns setenv defined variable when getenv fails */
#include <stdio.h>
#include "../machine.h"
void C2F(getenvc)(ierr,var,cont)
char *var ;
char *cont;
int  *ierr;
{
   char *getenv(),*local;
   *ierr=0;
   /* JPC : ne pas faire un strcpy qui plante si pas de getenv */
   if ( (local=getenv(var)) == 0)
     {
       printf("You must define the environment variable %s\n",var);
       *ierr=1;
       return;
     }
   else   strcpy(cont,local);
   return;
}
