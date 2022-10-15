
#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

main()
{
  test1();
  test2();
  testmDialogWindow();
}


test1()
{
  static String description = "Message test1 ";
  static String init ="Initial";
  static String strings[] = {
	"first list entry",
	"second list entry",
	"third list entry",
	"fourth list entry",
	NULL
    }
  static String buttonname[] = {
	"Button Label",
	NULL
    }
  ExposeChooseWindow(strings,description,buttonname);
  ExposeMessageWindow(description);
}

test2()
{
  int i=0;
  void DialogWindow();
  static String description = "texte test2";
  static String init ="Initial\nvalue";
  static String buttonname[] = {
	"Button Label",
	NULL
    }
  DialogWindow(description,init,&i,&i,buttonname);
}



test4()
{
  static String description = "Message\nSur\nPluieurs lignes";
  ExposeMessageWindow(description);
  ExposeMessageWindow(description);
}


#include "../machine.h"
#define PROMPT "-->"

F2C(scilab)(nostartup)
     int *nostartup;
{

}


C2F(sigbas)(i)
     int *i;
{
  fprintf(stderr,"CTRL_C activated \n");
}

#define IP0 (int *) 0

check_win()
{
  int verb=0,win,na,v;
  C2F(dr1)("xget","window",&verb,&win,&na,v,v,v,0,0);
  C2F(dr1)("xset","window",&win,IP0,IP0,IP0,IP0,IP0,0,0);
}


int C2F(scilines)(nl,nc)
     int *nl, *nc;
{}

int C2F(sciquit)(nl,nc)
     int *nl, *nc;
{return(1);}
     

void cerro(str)
char *str;
{
  fprintf(stderr,"%s",str);
}

void cout(str)
char *str;
{
  fprintf(stdout,"%s",str);
}

void cvstr_(){}
