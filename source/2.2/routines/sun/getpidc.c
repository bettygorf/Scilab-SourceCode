#include "../machine.h"

C2F(getpidc)(id1)
int *id1;
{
  *id1=getpid();
  return ;
}
