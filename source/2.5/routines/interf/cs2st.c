/*      Copyright ENPC (Jean-Philippe Chancelier)  */

#include "../machine.h" 

int C2F(cs2st)(i,ires)
     integer *i,*ires;
{
  unsigned int ui;
  ui = (unsigned int) *i;
  ui = (ui/4)+1;
  *ires = (ui/2)+1;
  return 0;
}
