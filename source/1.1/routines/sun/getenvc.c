/* returns setenv defined variable when getenv fails */
#include <stdio.h>
#include "../machine.h"
void C2F(getenvc)(var,cont)
char *var ;
char *cont;
{
   char *getenv(),*local;
   /* JPC : ne pas faire un strcpy qui plante si pas de getenv */
   if ( (local=getenv(var)) == 0)
     {
       printf("You must define the environment variable %s\n",var);
       exit(1);
     }
   else   strcpy(cont,local);
   return;
}
