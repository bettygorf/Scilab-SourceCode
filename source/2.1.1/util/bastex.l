alphabet [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]
alphabet1 [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0-9_]
%START MACROS
%{
#include <string.h>
#include <ctype.h>
#include <malloc.h>
int Mflag1 = 0 ;
int MaxKey = 144 ;
#define FALSE 0 
int G_create = 1;

%}

%%


^"//"[ ]*"<".*          { if (Mflag1==0)
			    {Mflag1=1;
			     printMacro(yytext,yyleng);
			     debutcode();
                             REJECT ;
                             }
                            else 
			     { REJECT;} ; };
^"//"[ ]*/\n |
^"//"[ ]*[^<\n].*         {if (isend(yytext))
                             {Mflag1=0;
			      printf("%s",yytext);
			      endcode();}
			 else 
                           {printf("\\verb@");
			    printf1(yytext,yyleng);
			    printf("@");}
		       };

\n                      {if (Mflag1==1) 
                           printf("\\\\ \n\\cmarg ");
                         else printf("\n");};

\t                      {printf("\\hspace{%dcm}",2);};

^[ ]*                   {printf("\\hspace{%.1fcm}",strlen(yytext)*0.25);};


{alphabet1}+        { CheckKey(yytext,MaxKey);   };

"\\"      { printf("$\\backslash$");   };

"*"        {printf("$\\star$"); };


"/"      { printf("/");};
"~" |
"^"      { printf("\\verb+%s+",yytext);};

"&" |
"#" |
"{" |
"}" |
"%" |
"_"      { printf("\\%s",yytext); };

"["  |
"]"  |
"-"  |
"|"  |
"<"  |
">"      { printf("$%s$",yytext); };

"Bold{"{alphabet1}+"}" 
         {/* add the word in tabkey */
          AddInKey(yytext,yyleng);};

%%

/*-------------------Sessions---------*/

Begin()
{printf("\n\\documentstyle{article}");
 printf("\n\\textheight=660pt ");
 printf("\n\\textwidth=470pt ");
 printf("\n\\topmargin=-27pt ");
 printf("\n\\oddsidemargin=0pt ");
 printf("\n\\evensidemargin=0pt ");
 printf("\n\\begin{document}\n ");
 cmargdef();
};

End()
{
 printf("\n\\end{document}\n ");
};

debutcode()
{ 
 printf ("\n\\begin{flushleft}\n{\\sl \n\\cmarg ");}


endcode()
{printf("}\n\\end{flushleft}}\n");};


#define KEYTABMAX 200

char *Keytab[KEYTABMAX]={
	"if" ,"else" ,"for" ,"while" ,"end" ,"select" ,"case",
	"quit" ,"exit" ,"return" ,"help" ,"what" ,"who" ,"why",
	"semi" ,"pause" ,"clear" ,"resume" ,"pdes" ,"then" ,"do",
	"abs" ,"amell" ,"argn" ,"arl2" ,"atan" ,"bdiag" ,"bezout",
	"char" ,"chol" ,"coeff" ,"comp" ,"cond" ,"conj" ,"contr",
	"corr" ,"cos" ,"debug" ,"deco" ,"deff" ,"degre" ,"delip",
	"det" ,"diag" ,"diary" ,"disp" ,"ent" ,"error" ,"exec",
	"exists" ,"exp" ,"eye" ,"ffir" ,"fft" ,"fiir" ,"file",
	"format" ,"fort" ,"freq" ,"getf" ,"gschur" ,"gspec" ,"hermite",
	"hess" ,"imag" ,"impl" ,"interp" ,"intg" ,"inv" ,"ldiv",
	"length" ,"lib" ,"lines" ,"link" ,"list" ,"load" ,"locate",
	"log" ,"ltitr" ,"lu" ,"lufact" ,"lusolve" ,"lyap" ,"macsyma",
	"matrix" ,"maxi" ,"mini" ,"mode" ,"norm" ,"ode" ,"ones",
	"optim" ,"orth" ,"padic" ,"part" ,"pdiv" ,"pinv" ,"plot",
	"poly" ,"ppol" ,"print" ,"prod" ,"qr" ,"rand" ,"rank",
	"rat" ,"rcond" ,"read" ,"real" ,"remez" ,"residu" ,"resume",
	"ricc" ,"roots" ,"round" ,"routh" ,"rpem" ,"rref" ,"rtitr",
	"save" ,"schur" ,"sfact" ,"simp" ,"sin" ,"size" ,"sort",
	"spec" ,"splin" ,"sqrt" ,"stabl" ,"string" ,"sum" ,"sva",
	"svd" ,"sylv" ,"syredi" ,"tild" ,"tr_zeros" ,"tril" ,"triu",
	"type" ,"user" ,"varn" ,"write"
      };



/* rajoute un mot clef que l'on veut en gras */

AddInKey(yytext,yyleng)
  char yytext[];
  int yyleng;
{char *prov;
 int i,j,k  ;
 if (MaxKey <= KEYTABMAX)
  {
    prov= malloc((unsigned) yyleng); 
    for (i =0 ; yytext[i] != '{' ; i++);
    k= yyleng-i-2;
    for (j=0  ; j < k ; j++)
      prov[j]=yytext[j+i+1];
    prov[k]='\0';
    Keytab[MaxKey]=prov;
    MaxKey= MaxKey+1;
  };
};
       

CheckKey(string,MaxKey)
   char string[];
{int i ,ok=0;
 for (i =0 ;i < MaxKey ; i++ )
	if (strcmp(string,Keytab[i])==0) { ok = 1; break;}
 if ( ok) printf("{\\bf ");
  for (i =0 ; i < strlen(string) ; i++)
	 if ( string[i]=='_') printf("\\_");
	 else printf("%c",string[i]);
  if ( ok) printf("}");
};

isend (string)
  char *string;
  {int i = 2;
   if (string[i]=='e' & string[i+1]=='n' &string[i+2]=='d')
   return(1);
   else return(0); };


printMacro(yytext,yyleng)
    char yytext[];
    int yyleng;
{int i,j ;
 int iflag=0;
 i=0;
 printf("\n\\def\\M");
 while ( yytext[i] != '=') i++;
 for (j = i+1 ; j < yyleng && yytext[j] != '(' ; j++)
	{
	  switch (yytext[j])
	    {
	    case '%':
	    case '_':
	    case ' ': break;
	    case '1': printf("u");break;
	    case '2': printf("d");break;
	    case '3': printf("t");break;
	    case '4': printf("q");break;
	    case '5': printf("c");break;
	    case '6': printf("si");break;
	    case '7': printf("s");break;
	    case '8': printf("h");break;
	    case '9': printf("n");break;
	    case '0': printf("z");break;
	    default:  printf("%c",yytext[j]);
	    };
	}
 printf("{");
};

printf1(str,strl)
     char str[];
     int strl;
{
  int i;
  for ( i =0 ; i < strl ; i++)
    switch (str[i])
      {
      case '%' : 
      case '_' : 
      case '&' : 
      case '^' : 
            printf("\\%c",str[i]);break;
      case '\\' : 
             printf("\\ ");break;
	default  : printf("%c",str[i]);break;
      }

}

cmargdef()
{ 
  printf("\n\\def\\cmarg{\\hspace{1cm}}\n");
};


main(argc, argv)
int argc;
char *argv[];

{
    struct stack_entry {  /* stack entry */
	int h, v, w, x, y, z;  /* what's on stack */
    };
    DecodeArgs( argc, argv );
    if (G_create == 1)
       Begin();
    yylex();
    if (G_create == 1)
    End();
    exit(0);
  };


DecodeArgs( argc, argv )
int argc;
char *argv[];
{
    int argind;             /* argument index for flags              */
    char *tcp ;	    /* temporary character pointers	     */

    argind = 1;
    while (argind < argc) {
	tcp = argv[argind];
        if (*tcp == '-')
	    switch(isupper(*++tcp) ? (*tcp-'A')+'a' : *tcp) 
	      {
	      case 'n':       /* Dont' add latex Docstyle and end doc */
		G_create = FALSE;
		++argind;
		break;
	      case 'h':       /* Dont' add latex Docstyle and end doc */
	        printf("Usage : Bastex [-n] < filein > fileout\n");
		exit(1);
		break;
	      default:
		++argind;
		printf("%c is not a legal flag\n", *tcp);
		break;
	      }
	else ++argind;
      };
    
  };


