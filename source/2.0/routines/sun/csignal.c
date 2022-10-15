
#include "../machine.h"
#include <signal.h>

controlC_handler (sig)
     int sig;
{
  int j;
  j = SIGINT;
  C2F(sigbas)(&j);
}

C2F(csignal)()
{
  signal (SIGINT, controlC_handler);
}
