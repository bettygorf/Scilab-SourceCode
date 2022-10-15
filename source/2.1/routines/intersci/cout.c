#include "../machine.h"

extern void C2F(out)();

void cout(str)
char *str;
{
  int l;
  l = strlen(str) + 1;
  C2F(out)(str,l);
}
