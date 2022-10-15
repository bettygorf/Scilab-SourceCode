
#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>

cvstr_(){};

main()
{
  inix_();
  test1();
  test2();
  test3();
  test4(); 
};


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
    };
  ExposeChooseWindow(strings,description);
  ExposeMessageWindow(description);
};

test2()
{
  void DialogWindow();
  static String description = "texte test2";
  static String init ="Initial";
  DialogWindow(description,init);
};

test3()
{
  static String description = "texte test2";
  static String strings[] = {
    "first list entry",
    "second list entry",
    "third list entry",
    "fourth list entry",
    NULL
    };
  ExposeChooseWindow(strings,description);
};


test4()
{
  static String description = "Message\nSur\nPluieurs lignes";
  ExposeMessageWindow(description);
  ExposeMessageWindow(description);
};

