/*
-------------------------------------------
PROGRAMMES   C  POUR  LE  LINK  DYNAMIQUE  
-------------------------------------------
*/
/* Editeur de liens dynamique pour UNIX.
   permet de rajouter des points d'entrees a un programme en
   cours d'execution. Attention on ne peut par ce moyen remplacer
   un sous-programme lie lors de l'edition de liens initiale.

En  entree :
------------
 ename : chaine de caracteres contenant le nom du point d'entree a rajouter
 loaded_file : chaine de caracteres contenant les noms de fichiers
               necessaires a la definition de ename (Il n'est pas necessaire
               d'ajouter la definition des sous programmes inclus dans
               l'executable initial.
 ii : numero d'ordre du point d'entree . Ce peut etre le numero d'ordre+1
      du dernier point d'entree lie dynamiquement, ou son numero d'ordre
      (au quel cas ce dernier point d'entree est detruit et remplace par
      ename), ou 0 si ename est le premier sous programme a etre lie.

En sortie:
----------
 err : indicateur d'erreur :
       0 si ok
       >0 sinon
 epoints : tableau statique contenant l'adresse de chacun des points
           d'entrees lies dynamiquement. Peut etre utlise par dyncall
           pour faire executer les sous programmes ainsi lies.

Origine: Michael Fan (Andre Tits)

*/

#include "../machine.h"

#if defined(sun) || defined(mips)

#include <string.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <a.out.h>
#define round(x,s) (((x) + ((s)-1)) & ~((s)-1))

unsigned long epoints[20];
caddr_t endv[22],wh;
int lastlink={0};
caddr_t sbrk();   /* memory allocation */
extern char *index();


dynload_(ii,ename,loaded_files,err)

char ename[], loaded_files[];
int *ii;
long int *err;
{
   unsigned long epoint;
   char str[1000] , tmp_file[80], prog[200],*libs,*getenv();
   char *ename1;

   int readsize, totalsize, diff, n, p, i, nalloc,last;
   float x;
   int kk;
#ifdef mips
   struct  filehdr filehdr;
   struct  aouthdr aouthdr;
#else
   struct exec header;
#endif
   caddr_t end;


   libs=getenv("SYSLIBS");
#ifdef mips
   ename1 = ename+1;
#else
   ename1 = ename;
#endif

   strcpy(prog,"");
   getpath(prog);/* prog est le pathname du fichier executable*/
   printf ("\nlinking  %s defined in %s with %s \n", ename,loaded_files,prog);

   strcpy (tmp_file, "/tmp/SCILABXXXXXX");
   mktemp(tmp_file);

   if ((*ii != lastlink) && (*ii != lastlink-1)) {
     printf("\ncannot (re)define this link \n");
     return;
   }

   if (lastlink==*ii) {
      n = (int)(end = sbrk(0));
      diff = round (n,1024) - n;

      if (diff != 0) {
         end = sbrk(diff);
         if ((int)end <= 0) {
              printf ("sbrk failed\n");
              *err=4;
            return;
            }
         end = sbrk(0);
         }
      nalloc=0;
      if (lastlink==0) {
        endv[0]=end;
        endv[1]=end;
      }
    }
    else {
      end = endv[*ii];
     /* recuperation d'espace   eventuellement libere */
      nalloc=((int) endv[lastlink])-((int) endv[*ii]);
      lastlink=lastlink-1;
    }
#if 0
   if ( libs != NULL)
     sprintf (str,"/bin/ld -N -x -A %s -T %x -o %s -e %s %s %s",
               prog,end,tmp_file,ename1,loaded_files,libs);
   else
     sprintf (str,"/bin/ld -N -x -A %s -T %x -o %s -e %s %s ",
              prog,end,tmp_file,ename1,loaded_files);
   if (system(str) != 0) {
#else
    {
        extern char *sys_errlist[];
        extern errno;
        int pid, status, wpid, i;
        char *s;
        char hexentry[10];        static char *argv[14] = {
                "/bin/ld", "-N", "-x","-A", 0, "-T", 0, "-o", 0, "-e", 0, 0, 0,
0
        };
        argv[4] = prog;
        sprintf(hexentry, "%x", end);
        argv[6] = hexentry;
        argv[8] = tmp_file;
        argv[10] = ename1;
        for (i = 11, s = loaded_files; i < 99; ++i) {
                argv[i] = s;
                if (s = index(s, ' ')) {
                        *s = 0;
                        while (*++s == ' ');
                } else
                        break;
                if (*s == 0)
                        break;
        }
        if (libs) for (i = i+1, s = libs; i < 99; ++i) {
                argv[i] = s;
                if (s = index(s, ' ')) {
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
                printf ("can't create new process: %s\n", sys_errlist[errno]);
                goto bad;
        }
        while ((wpid = wait(&status)) != pid)
                if (wpid < 0) {
                        printf ("no child !\n");
                        goto bad;
                }
        if (status != 0) {

                printf ("ld returned bad status: %x\n", status);
bad:
#endif
     printf ("loading error\n");
     unlink(tmp_file);
     *err=1;
     return;
   }

#if 1
   }
#endif
   if ((p = open(tmp_file, O_RDONLY)) < 0) {
        printf ("Cannot open %s\n", tmp_file);
        *err=2;
      return;
      }

   /* read the a.out header and find out how much room to allocate */

#ifdef mips
   if (read(p, &filehdr, sizeof filehdr) != sizeof filehdr) {
           printf ("Cannot read filehdr from %s\n", tmp_file);
           *err=3;
           return;
   }
   if (read(p, &aouthdr, filehdr.f_opthdr) != filehdr.f_opthdr) {
           printf ("Cannot read aouthdr from %s\n", tmp_file);
           *err=3;
           return;
   }

   readsize = round(aouthdr.tsize, 4) + round(aouthdr.dsize, 4);
   totalsize = readsize + aouthdr.bsize;
   i = lseek(p, sizeof filehdr + filehdr.f_opthdr +
                filehdr.f_nscns*sizeof (struct scnhdr), 0);
#else
   if (sizeof(header) != read(p, (char *)&header,sizeof(header))) {
        printf ("Cannot read header from %s\n", tmp_file);
        *err=3;
      return;
      }

   /* calculate  sizes */

   readsize = round(header.a_text, 4) + round(header.a_data, 4);
   totalsize = readsize + header.a_bss;
#endif
   totalsize = round(totalsize, 1024);   /* round up a bit */

   /* allocate more memory, using sbrk */
   wh = sbrk(totalsize-nalloc);
   if ( (int)wh <= 0 ) {
     printf ("sbrk failed to allocate\n");
     *err=4;
     return;
   }
   endv[*ii+1]=sbrk(0);

   /* now read in the function */
   i=read(p, (char *)end, readsize);
   if (readsize != i) {
      printf ("Cannot read %s\n", tmp_file);
      *err=5;
      return;
      }

   /* set the first entry up to the header value */

#ifdef mips
   epoints[*ii] = aouthdr.entry?aouthdr.entry:aouthdr.text_start;
#include <mips/cachectl.h>
   cacheflush(end, totalsize, BCACHE);
#else
   epoints[*ii] = header.a_entry;
#endif
   unlink(tmp_file);
   lastlink=lastlink+1;
   close(p);
   return(0);
 }
/*
 Appel de dynload a partir de fortran .
 i : numero d'ordre du point d'entree a definir
 fname  : chaime de caracteres fortran contenant la liste des fichiers
          necessaires a l'edition de liens.
 lf : taille de lf
 spname : chaine de caracteres fortran contenant le nom du point d'entree
 ls : longueur de spname
 err : indicateur d'erreur

 Origine: S Steer INRIA 1988
*/
dynstrc_(i,fname,lf,spname,ls,err)
char fname[], spname[];
int *lf, *ls, *i;
long int err;
{
  fname[*lf]='\0';
  spname[*ls]='\0';
  dynload_(i,spname,fname,err) ;
  return;
}
/*
  Lancement dynamique de l'execution d'un sous programme liee
  par dynload
  i : numero d'ordre du point d'entree a executer
  xi,yi,zi : parametres formels (il n'est pas necessaire de tous les
             satisfaire).

 Origine S. Steer INRIA 1988
*/
dyncall_(i,x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,
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

/*
Etant donne le "nom" du fichier executable getpath retourne son pathname
en utilisant les regles de recherches definies par la variable
d'environnement PATH.
Si en entree name contient au moins un caractere "/" il est considere
que name est un pathname (et non un nom) et retourne tel que

origine S Steer INRIA 1988
*/
getpath(name)

char name[];
{
struct stat stbuf;
short unsigned mode;
char *searchpath, buf[200],prog[200];
char *getenv();
int kd, kf, j, i ,ok, km;

F2C(getpro)(prog,sizeof(prog)-1);
     strcpy(name,prog);

if ( (index(name,'/')) != 0)
     return;

/* on recupere la regle de recherche */
if ( (searchpath=getenv("PATH")) == NULL)
  {
    printf("variable PATH not defined\n");
    return;
  }

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

#else
C2F(dynload)() {cerro("Dynamic link not implemented");}
C2F(dynstrc)() {cerro("Dynamic link not implemented");}
C2F(dyncall)() {cerro("Dynamic link not implemented");}
#endif
