#include "../machine.h"

extern void C2F(erro)();

#define STRLEN 4096

void cerro(format,a1,a2,a3,a4,a5,a6,a7)
char *format;
{
  char str[STRLEN];
  int l;
  sprintf(str,format,a1,a2,a3,a4,a5,a6,a7);
  l = strlen(str) + 1;
  C2F(erro)(str,l);
}
