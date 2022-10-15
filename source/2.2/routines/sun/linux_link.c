#include <stdio.h>
#include "../dld/dld.h"

typedef void (*function) ();
typedef char Name[256];

static function epoints[20];
static Name nom_functions[20];
static int lastlink=0;
#if defined(__STDC__)
extern void getpro_(char *,long int);
extern char * dld_strerror(int code);
#else 
extern void getpro_();
extern char * dld_strerror();
#endif 


#define DLDLINK

int dyninit_()
{
  static int err=0;
  static int initialised=0;
  char str[1000];
  /* required initialization. */
  if (!initialised) 
    {
      char prog[200];
      getpro_(prog,sizeof(prog)-1);
      sciprint("Link Initialisation");
      err =  dld_init (dld_find_executable(prog));
      sciprint(" %s\n",dld_find_executable(prog));
      if(!err) 
	initialised=1;
      else {
	  sciprint("dld_init error %s\n",dld_strerror(err));
	  
      }
    };
  return err;
}

/* print out all the undefined symbols */

void list_undefined () {
    char str[1000];
    char **list = dld_list_undefined_sym ();
    if (list) {
	register int i;
	sciprint("There are a total of %d undefined symbols:\n",
		dld_undefined_sym_count);
	
	for (i = 0; i < dld_undefined_sym_count; i++)
	    sciprint("%d: %s\n", i+1, list[i]);
    } else
	sciprint("No undefined symbols\n");
}

#define MAXCHAR 256
#if defined(__STDC__)
int dynload_(int *ii,char ename1[],char loaded_files[],int *err)
#else 
int dynload_(ii,ename1,loaded_files,err)
     int *ii;char ename1[],loaded_files[];int *err;
#endif
{
  function func;
  char current_object_file[MAXCHAR];
  int i,j;
  char current_char;

#ifdef DEBUG
  sciprint("ename1 [%s]\r\n",ename1);
  sciprint("lastlink %d, entry=%d\n",lastlink,*ii);
#endif

  sciprint("linking  \"%s\" defined in \"%s\"\n", ename1,loaded_files);
  
  *err = 0;
  if ( (*err = dyninit_())) return; /* Error on init */
  /* on scane et on charge the objects files */
  /* unloading if necessary */
  i = 0;j=0;
  while (1){
      current_char = loaded_files[i];
      if((current_char == ' ') || (current_char == '\0') || (i == strlen(loaded_files)))
	{
	  current_object_file[j] = '\0';
	  if(strlen(current_object_file)>0){
	    /** if this file was previously linked i must unlink it **/
	    if ( *ii < lastlink )
	      {
		dld_unlink_by_file (current_object_file,1);
#ifdef DEBUG
		sciprint("unloading : \"%s\"\r\n",current_object_file);
#endif
	      };
	  };
	  j = -1;
	  if(loaded_files[i] == '\0')   break;
	} 
      else 
	{ 
	  current_object_file[j] = loaded_files[i];
	}
      i++;j++;
      if ( j > MAXCHAR ) 
	{
	  *err=1 ;
	  sciprint("filename too long");
	};
    };

  /* loading */
  i = 0;j=0;
  while (1){
      current_char = loaded_files[i];
      if((current_char == ' ') || (current_char == '\0') || (i == strlen(loaded_files)))
	{
	  current_object_file[j] = '\0';
	  if(strlen(current_object_file)>0){
#ifdef DEBUG
	    sciprint("loading : \"%s\"\r\n",current_object_file);
#endif
	    *err = dld_link (current_object_file);
	    if(*err){
	      sciprint("problem when loading : \"%s\"\n",current_object_file);
	      sciprint("dld_link error %s \n",dld_strerror (*err));
	      return;
	    };
	  };
	  j = -1;
	  if(loaded_files[i] == '\0')   break;
      } 
      else 
	{ 
	  current_object_file[j] = loaded_files[i];
	}
      i++;j++;
      if ( j > MAXCHAR ) 
	{
	  *err=1 ;
	  sciprint("filename too long");
	  
	};
    };
  
    /* grap the entry point for function "ename"  */
  if (dld_function_executable_p (ename1))
      {
        func = (function) dld_get_func (ename1);
        if ( func  == (function) 0)
	  {
	    sciprint("error when finding \"%s\" in \"%s\"\n",ename1,loaded_files);
	    
	    sciprint("dld_get_func error %s\n",dld_strerror (*err));
	    
	    *err=1;
	    return;
	  };
#ifdef DEBUG
	sciprint("procedure numero %d \"%s\" located in \"%s\"\r\n",*ii,ename1,loaded_files);
#endif
	epoints[*ii] = func;
	strcpy(nom_functions[*ii],ename1);
	lastlink=lastlink+1;
      }
    else 
      {
	sciprint("error [%s] not executable \n",ename1);
	
	list_undefined ();
	*err=1;
      };
  };


/*
  Lancement dynamique de l'execution d'un sous programme liee
  par dynload
  i : numero d'ordre du point d'entree a executer
  xi,yi,zi : parametres formels (il n'est pas necessaire de tous les
             satisfaire).
 Origine S. Steer INRIA 1988
*/

void dyncall_(i,
              x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
              y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,
              z0,z1,z2,z3,z4,z5,z6,z7,z8,z9)
     int *i;
     int *x0,*x1,*x2,*x3,*x4,*x5,*x6,*x7,*x8,*x9;
     int *y0,*y1,*y2,*y3,*y4,*y5,*y6,*y7,*y8,*y9;
     int *z0,*z1,*z2,*z3,*z4,*z5,*z6,*z7,*z8,*z9;
{
#ifdef DEBUG
  sciprint("début procedure numero %d : %s\r\n",*i,nom_functions[*i]);
#endif
  (epoints[*i])(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
		y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,
		z0,z1,z2,z3,z4,z5,z6,z7,z8,z9);
#ifdef DEBUG
  sciprint("fin de procedure %s\r\n",nom_functions[*i]);  
#endif
  return;
}




