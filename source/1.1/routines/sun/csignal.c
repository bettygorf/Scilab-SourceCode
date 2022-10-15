#include "../machine.h"
#include <signal.h>

controlC_handler (sig)
     int sig;
{
  int j;
  j = SIGINT;
  C2F(sigbas)(&j);
  signal (SIGINT, controlC_handler);
}

C2F(csignal)()
{
  signal (SIGINT, controlC_handler);
}
