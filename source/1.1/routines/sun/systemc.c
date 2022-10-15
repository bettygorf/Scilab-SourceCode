/*

  procedure chargee de lancer une commande systeme dans un
  environnement unix quand le call system pose probleme.

  version hp9000 sun unigraph
*/
#include<stdio.h>
#include "../machine.h"
C2F(systemc)(command)
char * command;
{
  int  system();
  int status;
  status=system(command);
  return;
}
