	
#include <string.h>
#include <sys/types.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/file.h>

#if defined mips || defined __alpha || defined hppa
#define COFF
#endif


#if defined(sun) ||  defined mips || defined __alpha || defined hppa
#include <a.out.h>

caddr_t endv[22],wh;

#ifndef _SYS_UNISTD_INCLUDED
caddr_t sbrk();   /* memory allocation */
#endif

#define round(x,s) (((x) + ((s)-1)) & ~((s)-1))
#ifndef hppa
#define RNDVAL1 4
#define RNDVAL2 1024
#else
#define RNDVAL1 0x1000
#define RNDVAL2 0x1000
#endif /* hppa */
extern char *index();

#endif	/* sun || mips || hppa */


static unsigned long epoints[20];
int lastlink={0};


F2C(dynload)(ii,ename1,loaded_files,err)
     char ename1[], loaded_files[];
     int *ii;
     int *err;
{
   unsigned long epoint;
   char str[1000] , tmp_file[80], prog[200],*libs,*getenv();

   int readsize, totalsize, diff, n, p, i, nalloc,last;
   float x;
   int kk;
#ifndef _IBMR2
#if defined mips || defined __alpha
   struct  filehdr filehdr;
   struct  aouthdr aouthdr;
#endif
#ifdef hppa
   struct header filehdr;
   struct  som_exec_auxhdr aouthdr;
#endif /* hppa */
#ifndef COFF
   struct exec header;
#endif /* COFF */
   caddr_t end;
#endif /* _IBMR2 */
   extern char *sys_errlist[];
   extern errno;

#ifdef DEBUG
  sciprint("ename1 [%s]\r\n",ename1);
  sprintf(str,"lastlink %d, entry=%d\n",lastlink,*ii);Scistring(str);
#endif

   libs=getenv("SYSLIBS");

   strcpy(prog,"");
   getpath(prog);/* prog est le pathname du fichier executable*/
   
   sprintf (str,"\nlinking %s defined in %s with %s \n",ename1,loaded_files,prog);
   Scistring(str);

   strcpy (tmp_file, "/tmp/SCILABXXXXXX");
   mktemp(tmp_file);

   if ((*ii != lastlink) && (*ii != lastlink-1)) {
     sprintf(str,"cannot (re)define this link \n");
     Scistring(str);
     return;
   }

#ifndef _IBMR2
   if (lastlink==*ii) {
      n = (int)(end = sbrk(0));
      diff = round (n,RNDVAL2) - n;

      if (diff != 0) {
         end = sbrk(diff);
         if ((int)end <= 0) {
              sprintf (str,"sbrk failed\n");
	      Scistring(str);
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
#else /* _IBMR2 */
#define vfork fork
    lastlink = *ii;
#endif /* _IBMR2 */
    {
        int pid, status, wpid, i;
        char *s;

        static char *argv[] = {
#ifndef _IBMR2

#ifdef hppa
#define TOPT "-R"
#endif /* hppa */
#ifdef mips
#define LD 0
#define LDARG1 "-r"
#define TOPT "-G", "0", "-T"
#define ARGTOPT 8
#define TAILARG 13
#endif /* mips */

#ifndef TOPT
#define TOPT "-T"
#endif /* TOPT */

#ifndef AARG
#define AARG "-A", 0, 
#endif

#ifndef LD
#define LD "/bin/ld"
#endif

#ifndef LDARG1
#define LDARG1  "-N"
#endif

#ifndef ARGTOPT
#define ARGTOPT 6
#endif
	    LD, LDARG1, "-x", AARG TOPT, 0, "-o", 0, "-e", 0, 0, 0, 0
#ifndef TAILARG
#define TAILARG 11
#endif /* TAILARG */
#else /* _IBMR2 */
	    "/bin/ld", 0 /* -bI:prog.exp */,"-K","-o", 0, "-e", 0, 0, 0, 0
#define TAILARG 7
#endif /* _IBMR2 */
        };

#ifndef _IBMR2
        char hexentry[10];
        argv[4] = prog;
#ifdef mips
	strcpy(str, prog);
	if (s = rindex(str,'/'))
	    strcpy(s+1, "dold");
	else
	    strcpy(str, "dold");
	argv[0] = str;
#endif /* mips */
        sprintf(hexentry, "%lx", end);
        argv[ARGTOPT] = hexentry;
#else /* _IBMR2 */
	sprintf(str, "-bI:%s.exp", prog);
	argv[1] = str;
#endif /* _IBMR2 */
        argv[TAILARG - 3] = tmp_file;
        argv[TAILARG - 1] = ename1;
        for (i = TAILARG, s = loaded_files; i < 99; ++i) {
                argv[i] = s;
                if (s = index(s, ' ')) {
                        *s = 0;
                        while (*++s == ' ');
                } else
                        break;
                if (*s == 0)
                        break;
        }
#ifdef hppa
	argv[++i] = "/lib/dyncall.o";
#endif /* hppa */
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
                sprintf (str,"can't create new process: %s\n", sys_errlist[errno]);
		Scistring(str);
                goto bad;
        }
        while ((wpid = wait(&status)) != pid)
                if (wpid < 0) {
                        sprintf (str,"no child !\n");
			Scistring(str);
                        goto bad;
                }
        if (status != 0) {

                sprintf (str,"ld returned bad status: %x\n", status);
		Scistring(str);
bad:
/*		printf ("loading error\n");*/
		*err=1;
		goto badunlink;
	}

   }

#ifndef _IBMR2
   if ((p = open(tmp_file, O_RDONLY)) < 0) {
        sprintf (str,"Cannot open %s\n", tmp_file);
	Scistring(str);
        *err=2;
        goto badclose;
      }

   /* read the a.out header and find out how much room to allocate */

#ifdef COFF
   if (read(p, &filehdr, sizeof filehdr) != sizeof filehdr) {
           sprintf (str,"Cannot read filehdr from %s\n", tmp_file);
	   Scistring(str);
           *err=3;
           goto badclose;
   }
#ifdef hppa
#define tsize exec_tsize
#define dsize exec_dsize
#define bsize exec_bsize
#define entry exec_entry
#define text_start exec_tmem
#define TEXTBEGIN aouthdr.exec_tfile
   lseek(p, filehdr.aux_header_location, 0);
#else
#ifdef N_TXTOFF
#define TEXTBEGIN N_TXTOFF(filehdr, aouthdr)
#else
#define TEXTBEGIN sizeof filehdr + filehdr.f_opthdr + \
		filehdr.f_nscns*sizeof (struct scnhdr)
#endif
#endif /* hppa */
   if (read(p, &aouthdr, sizeof aouthdr) != sizeof aouthdr) {
           sprintf (str,"Cannot read auxhdr from %s\n", tmp_file);
	   Scistring(str);
           *err=3;
           goto badclose;
   }

   readsize = round(aouthdr.tsize, RNDVAL1) + round(aouthdr.dsize, RNDVAL1);
   totalsize = readsize + aouthdr.bsize;
   i = lseek(p, TEXTBEGIN, 0);
#else /* ! COFF */
   if (sizeof(header) != read(p, (char *)&header,sizeof(header))) {
        sprintf (str,"Cannot read header from %s\n", tmp_file);
	Scistring(str);
        *err=3;
      goto badclose;
      }

   /* calculate  sizes */

   readsize = round(header.a_text, RNDVAL1) + round(header.a_data, RNDVAL1);
   totalsize = readsize + header.a_bss;
#endif /* COFF */
   totalsize = round(totalsize, RNDVAL2);   /* round up a bit */

   /* allocate more memory, using sbrk */
   wh = sbrk(totalsize-nalloc);
   if ( (int)wh <= 0 ) {
     sprintf (str,"sbrk failed to allocate\n");
     Scistring(str);
     *err=4;
     goto badclose;
   }
   endv[*ii+1]=sbrk(0);

   /* now read in the function */
   i=read(p, (char *)end, readsize);
   if (readsize != i) {
      sprintf (str,"Cannot read %s\n", tmp_file);
      Scistring(str);
      *err=5;
      goto badclose;
      }
#ifdef __alpha
  {
#include <sys/mman.h>
   i = mprotect(end, readsize, PROT_READ|PROT_WRITE|PROT_EXEC);
   if (i < 0) {
     perror("mprotect");
     *err = errno;
     return;
   }
  }
#endif

   /* set the first entry up to the header value */

#ifdef COFF
   epoints[*ii] = aouthdr.entry?aouthdr.entry:aouthdr.text_start;
#if defined mips
#include <mips/cachectl.h>
   cacheflush(end, totalsize, BCACHE);
#endif /* mips */
#else
   epoints[*ii] = header.a_entry;

#endif /* COFF */
   lastlink=lastlink+1;
badclose:
   close(p);
#else /* _IBMR2 */
   epoints[*ii] = load(tmp_file,1, "");
   if (epoints[*ii] == 0) {
	   sprintf (str,"ibm load routine failed: %s\n", sys_errlist[errno]);
	   Scistring(str);
	   *err = 6;
   }
#endif /* _IBMR2 */
badunlink:
   unlink(tmp_file);
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

#ifdef hppa
int
F2C(getpro)(s, l)
char *s;
int l;
{
  extern char *__data_start[];
  strncpy (s,__data_start[0], l);
}
#endif
