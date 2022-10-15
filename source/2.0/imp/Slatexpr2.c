#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <malloc.h>
#include <stdio.h>

/*---------------------------------------------------------
  Blatexprs fileres file1 .... filen  
  fait une mise en page de n dessins scilab ou neoclo 
  genere le fichier postscript fileres.ps 
  associe ainsi  qu'un fichier TeX fileres.tex
-------------------------------------------------------------*/

char * UsageStr[]={
  "Usage  : Blatexpr2 fileres file1 file2  \n",
  "\tfile1, file2 : are 2 Postscript files produced by Scilab\n",
  "\tfileres : a file name for the result \n",
  "\tThis command will create fileres.ps and fileres.tex \n",
  "fin"};

char entete[160];

main(argc, argv)
int argc;
char *argv[];

{
  char *env;
  char filename1[255];
  float x,y,w,h,wt,ht;
  char buf[256];
  int i ;
  FILE *fd;
  FILE *fdo;
  if (argc !=4 ) { int i=0;
		   while (strcmp(UsageStr[i],"fin")!=0)
		     { 
		       fprintf(stderr,"%s",UsageStr[i]),i++;
		     }
		   exit(0);
		 };
  fdo=fopen(sprintf(filename1,"%s.ps",argv[1]),"w");
  if (fdo == 0 ) 
    {
      fprintf (stderr," Can't Create Output file <%s> \n",filename1);
      exit(0);
    };
  env = getenv("SCI");
  if (env == NULL) {
    fprintf(stderr,"Environment variable SCI must be defined\n");
    exit(0);
  }
  sprintf(entete,"%s/imp/NperiPos.ps",env);
  fd=fopen(entete,"r");
  if (fd != 0)
    { char c;
      while ( (c=getc(fd)) != EOF)
	{
	  putc(c,fdo);
	}
      fclose(fd);
    }
  else 
    {
      fprintf(stderr,"file %s not found ",entete);
      return;
    }
  for ( i = 2 ; i < argc-1 ; i++)
    { 
      ComputeSize(argc-2,i-1,&x,&y,&w,&h,&wt,&ht)      ;
      sprintf(buf,"gsave [1 0 0 -1 0 0] concat %5.2f %5.2f %5.2f %5.2f DesPosi"
	      ,x,y,w,h);
      Sed(argv[i],"[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div] concat",
	  buf," showpage","grestore",
	  " clear end saved restore","%clear end saved restore",fdo);
    };
  ComputeSize(argc-2,argc-2,&x,&y,&w,&h,&wt,&ht)      ;   
  sprintf(buf,"gsave [1 0 0 -1 0 0] concat %5.2f %5.2f %5.2f %5.2f DesPosi"
	  ,x,y,w,h);
  Sed(argv[argc-1],"[0.5 10 div 0 0 0.5 10 div neg  0 2120 10 div] concat",
      buf, " showpage"," grestore ",
      " clear end saved restore"," clear end saved restore",fdo);
  close(fdo);
  /** ecriture du fichier TeX associe **/
  WriteTeX(argv[1],wt,ht);
  return(0);
};

WriteTeX(filename,wide,height)
     float wide,height;
     char filename[];
{
  char filename1[255];
  double xs=1.0,ys=1.0;
  float x,y,w,h;
  int i ;
  FILE *fdo;
  fdo=fopen(sprintf(filename1,"%s.tex",filename),"w");
  if (fdo == 0 ) 
    {
      fprintf (stderr," Can't Create Output file <%s> \n",filename1);
      exit(0);
    };
  fprintf(fdo,"\\long\\def\\Checksifdef#1#2#3{\n");
  fprintf(fdo,"\\expandafter\\ifx\\csname #1\\endcsname\\relax#2\\else#3\\fi}\n");
  fprintf(fdo,"\\Checksifdef{Figdir}{\\gdef\\Figdir{}}{}\n");
  fprintf(fdo,"\\def\\dessin#1#2{\n");
  fprintf(fdo,"\\begin{figure}\n\\begin{center}\n");
  fprintf(fdo,"\\setlength{\\unitlength}{1cm}\n");
  fprintf(fdo,"\\fbox{\\begin{picture}(%.2f,%.2f)\n",wide,height);
  fprintf(fdo,"\\special{psfile=\\Figdir %s.ps}\n",
	  filename);
  fprintf(fdo,"\\end{picture}}\n");
  fprintf(fdo,"\\end{center}\n\\caption{\\label{#2}#1}\n\\end{figure}}");
  close(fdo);
  return(0);
};

/*---------------------------------------------------
 remplace strin<i> par strout<i> en lisant le contenu de 
 file et en ecrivant sur fdo
-------------------------------------------------------*/

Sed(file,strin1,strout1,strin2,strout2,strin3,strout3,fdo)
     FILE *fdo;
     char file[],strin1[],strout1[],strout3[];
     char strin2[],strout2[],strin3[];
{
  FILE *fd;
  fd=fopen(file,"r");
  if (fd != 0)
    { int stop=0;
      while ( stop != 1)
	{  char buff[512];
	   readOneLine (buff,&stop,fd); 
	   if (strncmp(buff,strin1,strlen(strin1))==0)
	     fprintf(fdo,"%s\n",strout1);
	   else
	     {
	       if (strncmp(buff,strin2,strlen(strin2))==0)
		 fprintf(fdo,"%s\n",strout2);
	       else 
		 {
		   if (strncmp(buff,strin3,strlen(strin3))==0)
		     fprintf(fdo,"%s\n",strout3);
		   else
		     fprintf(fdo,"%s",buff);
		 };
	     };
	 };
      fclose(fd);
    }
  else 
    {
      fprintf(stderr,"file %s not found ",file);
      return;
    }
};

/*-----------------------------------------------
  lit une ligne dans fd et la stocke dans buff
---------------------------------------------------*/

readOneLine(buff,stop,fd)
     char buff[];
     int *stop;
     FILE *fd;
{ int i ,c ;
  for ( i = 0 ;  (c =getc(fd)) !=  '\n' && c != EOF ; i++) buff[i]= c ;
  buff[i]='\n';buff[i+1]='\0';
  if ( c == EOF) {*stop = 1;};
} ;

/*-----------------------------------------------
  calcule la taille pour un dessin suivant le nombre de dessin a 
  placer dans la feuille 
  num est le nombre de dessins et i le numero du dessin 
  renvoit le point gauche dans (*x,*y) la largeur et le hauteur 
  dans (*w,*h)
  (*wt et *ht sont la hauteur totale et la argeur totale)
-----------------------------------------------------*/

ComputeSize(num,i,x,y,w,h,wt,ht)
     int num,i;
     float *x,*y,*w,*h,*wt,*ht;
{
  switch (num)
    {
    case 2 :
      *wt=15;*ht=5;
      /** 2 figures dans upleft(0,20,h=20,w=15) **/
      *x=(7.5)*(i-1);*y=(5);*h=5;*w=7.5;
      break;
    };
};

