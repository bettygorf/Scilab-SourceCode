#include <string.h>
#include <stdio.h>
#include "../machine.h"


#define NSTRL 8

/** store in tabi[NSTRL/4] the string str[NSTRL] **/
/** Warning : size are not checked **/

C2F(putidn)(tabi,str,lxstr)
     int tabi[];
     char str[];
     int lxstr;
{
  int job=0;
  str2int(NSTRL,tabi,str,&job);
}

/** Fonction cvstr a virer des que peu **/

C2F(cvstrn)(n,tabi,str,job,lxstr)
     int *n,tabi[],lxstr,*job;
     char str[];
{
  int i ;
  if ( *job==0) 
    for ( i=0 ; i < *n ; i++) tabi[i]= (int) str[i];
  else 
    for ( i=0 ; i < *n ; i++) str[i]= (char) tabi[i];
};

/** Ce qui suit sert a regarder une chaine de caractere **/
/** soit comme un tableau de characteres soit comme un tableau d'entier **/
/** String to int conversions with copy **/
/** copy a string(n) into inttab(n/4) if *job=0 
/** or inttab(n/4) if *job=1 **/
/** sert a remplacer cvname **/
/** et cvstr qui doit disparaitre **/

C2F(cvnamen)(id,str,job,lxstr)
     int id[],lxstr,*job;
     char str[];
{
  str2int(lxstr,id,str,job);
};

str2int(n,inttab,str,job)
     int    str[],n;
     char  inttab[],*job;
{
  switch (*job)
    {
    case 0 : 
      {
	strncpy((char *) inttab,"        ",n);
	strncpy((char *) inttab,str,n);break;
      }
    case 1 : strncpy( str,(char *) inttab,n);break;
    }
};

#ifdef TEST
main()
{
  char cpipo[40];
  int  pipo[10],job,i;
  strcpy(cpipo,"1234567890");
  fprintf(stderr," pipo [%s],%d",cpipo,strlen(cpipo));
  str2int(strlen(cpipo),pipo,cpipo,(job=0,&job))  ;
  for (i =0 ; i < strlen(cpipo)/2; i++)
    fprintf(stderr,"%d,",pipo[i]);
  str2int(strlen(cpipo),pipo,cpipo,(job=1,&job))  ;
  fprintf(stderr," pipo [%s],%d",cpipo,strlen(cpipo));
};
#endif




