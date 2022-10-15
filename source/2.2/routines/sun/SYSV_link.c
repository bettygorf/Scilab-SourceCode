
#include <stdio.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <dlfcn.h>

#ifdef sun
#include <sys/vnode.h>
#include <archives.h>
#endif

#ifdef linux 
#include <unistd.h>
#include <sys/wait.h>
#endif 

#ifndef linux
#include <sys/mode.h>
#endif 

#ifdef __alpha
#include <c_asm.h>
#endif

#ifdef sgi
#define vfork fork
#endif

#if defined  __alpha || defined sgi
#include <a.out.h>
#endif

#include <string.h>

caddr_t endv[22],wh;

#define round(x,s) (((x) + ((s)-1)) & ~((s)-1))

extern char *strchr();

static unsigned long epoints[20];
static unsigned long  hd[20];
int maxlinked={0};


F2C(dynload)(ii,ename1,loaded_files,err)
     int *ii;
     char ename1[], loaded_files[];
     int *err;

{
   char str[1000] , tmp_file[80],*libs,*getenv();
   int  readsize, totalsize, diff, n, p, i, nalloc=0,last;
   caddr_t end;
   long op1, op2, r, results[2],op[2];

   libs=getenv("SYSLIBS");

   sprintf (str,"\nlinking %s defined in %s with Scilab \n",ename1,loaded_files);
   Scistring(str);
   strcpy (tmp_file, "/tmp/SCILABXXXXXX");
   mktemp(tmp_file);

   {
        int pid, status, wpid, i;
        char *s;
        static char *argv[24] = {
           /*   0        1         2    3  4   */
#ifdef sun
        "/usr/ucb/ld", "-r", "-o", 0, 0
#else
#ifdef linux
         "/usr/bin/ld", "-shared", "-o", 0, 0  
#else
        "/bin/ld", "-shared", "-o", 0, 0  
#endif
#endif
#define TAILARG 4
	    };
        argv[3] = tmp_file;

        for (i = TAILARG, s = loaded_files; i < 99; ++i) {
                argv[i] = s;
               if (s = strchr(s, ' ')) {
                        *s = 0;
                        while (*++s == ' ');
                } else
                        break;
                if (*s == 0)
                        break;
        }
        if (libs) for (i = i+1, s = libs; i < 99; ++i) {
                argv[i] = s;
                if (s = strchr(s, ' ')) {
                        *s = 0;
                        while (*++s == ' ');
                } else
                        break;
                if (*s == 0)
                        break;
        }
        if ((pid = vfork()) == 0) {
                execv(argv[0], argv);
                _exit(1);
	      }
        if (pid < 0) {
		sprintf (str,"can't create new process: \n");
		Scistring(str);
		*err=1;
		return;
	      }
        while ((wpid = wait(&status)) != pid)
                if (wpid < 0) {
		  sprintf (str,"no child !\n");
		  Scistring(str);
		  *err=1;
		  return;
		      }
        if (status != 0) {
                sprintf (str,"ld returned bad status: %x\n", status);
		Scistring(str);
		*err=1;
		return;
	      }
      }

   {   
   void *hd1 = (void *) 0;
   int (*fptr)(void);
   static FILE *log = (FILE *) NULL;
   /* this will load the shared library */
   hd1 = dlopen(tmp_file, RTLD_NOW);

   if ( hd1 == (void *) NULL || hd1 < (void *) 0 ) {
     sprintf (str,"%s\n",dlerror());
     Scistring(str);
     *err=1;
     return;
   }
   /* lookup the address of the function to be called */
   epoints[*ii] = (unsigned long) dlsym(hd1, ename1);

   if ( (unsigned long) dlsym(hd1, ename1) == 0 ){
     sprintf (str,"not an entry point \n");
     Scistring(str);
     *err=1;
     return; 
   }
   if (*ii != maxlinked) {
     dlclose((void *)(hd[*ii])); 
     return;
   }
   else
     maxlinked=maxlinked+1;
   hd[*ii]=(unsigned long)hd1;
   }
   return;
}

F2C(dyncall)(i,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
           y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,
           z0,z1,z2,z3,z4,z5,z6,z7,z8,z9)

int *i;
int *x0,*x1,*x2,*x3,*x4,*x5,*x6,*x7,*x8,*x9;
int *y0,*y1,*y2,*y3,*y4,*y5,*y6,*y7,*y8,*y9;
int *z0,*z1,*z2,*z3,*z4,*z5,*z6,*z7,*z8,*z9;
{
   int (*epoint) ();
   epoint = (int (*)())(epoints[*i]);
   (*epoint)(x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
             y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,
             z0,z1,z2,z3,z4,z5,z6,z7,z8,z9);
   return;
 }

getpath(name)

char name[];
{
struct stat stbuf;
short unsigned mode;
char *searchpath, buf[200];
char *getenv();
int kd, kf, j, i ,ok, km;

ok=kd=kf=0;

while (ok == 0) {
  /* recherche de la fin d'une regle (: ou fin de chaine) */
  while ((searchpath[kf] != ':')&&(searchpath[kf++] !='\0'))
   ;
  if (searchpath[kf-1]=='\0') {
   ok=1; 
   kf--;
 }

  /* recopie de cette regle en debut de buf */
  j=0;
  for (i=kd; i<kf; ) {
       buf[j++]=searchpath[i++];
     }

  /* concatenation de la regle avec le nom du fichier */
  buf[j++]='/';
  i=0;
  while ((name[i] != ' ')&& (name[i] != '\0')) {
      buf[j++]=name[i++] ;
      buf[j]='\0';
    }

  /* test d'existence du fichier deisgne par le path fourni par la
     regle de recherche */
  if (stat(buf,&stbuf) != -1) {
    mode=stbuf.st_mode;

  /* les tests suivants permettent de savoir si le fichier designe
      par buf est executable ou non */

    mode=mode-(128*(mode/128));
    km=mode/16;
    if (km != 2*(km/2)) {
       strcpy(name,buf);
       return;
     }
    mode=mode-16*km;
    km=mode/8;
    if (km != 2*(km/2)) {
       strcpy(name,buf);
       return;
     }
    km=mode-8*km;
    if (km != 2*(km/2)) {
       strcpy(name,buf);
       return;
     }
  }
  kf++;
  kd=kf;
  }
return;
}
