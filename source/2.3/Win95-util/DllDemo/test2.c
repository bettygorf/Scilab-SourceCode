/*-----------------------------------------------------------
  test with explicit load of a dll
  -----------------------------------------------------------*/
#include <windows.h>

typedef int (WINAPI *DLLTEST)(int);

int test(char *dll)
{
  DLLTEST foo;
  static HINSTANCE  hLibrary = NULL;
  if ((hLibrary = LoadLibraryEx (dll, NULL,LOAD_WITH_ALTERED_SEARCH_PATH )) == NULL)
    {
      printf("Unable to load library %s\r\n",dll);
      return 0 ;
    }
  if ( (foo = (DLLTEST) GetProcAddress (hLibrary,"doit")) == NULL) 
    {
      printf("Unable to find doit \r\n");
      return 0 ;
    }
  foo(10);
  printf("doit(5) returns %d\n", foo(5));
  if (hLibrary)
    FreeLibrary (hLibrary) ;
}

int main()
{
  test("libtdll.dll");
}
