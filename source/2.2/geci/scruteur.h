/*************************************************************************************/
/* GeCI
/*************************************************************************************/

#ifndef _SCRUTEUR_
#define _SCRUTEUR_

#ifdef aix
#include <sys/select.h>
#endif

extern fd_set readfds, writefds, exceptfds;
extern void Erreur_scruteur();
extern int socket_com;

#endif
