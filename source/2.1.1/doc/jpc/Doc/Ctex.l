alphabet [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]
alphabet1 [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0-9_]

%START MACROS
%{
#include <string.h>
#include <malloc.h>
#include <ctype.h>
int Mflag =1 ;
int MaxKey = 28 ;

#define FALSE 0 
int G_create = 1;

%}

%%

^[ ]*"/*"-*"BEGIN"-*[ ]*\n    {Mflag=1; if ( G_create ==1 ) Begin();
				cmargdef() ; };

^[ ]*"/*"-*"END"-*"*/"[ ]*\n   {Mflag=0; endcode () ;
                                if ( G_create ==1 )End();
                                 Mflag=1;};
^"/*"-*[ ]*\n  		{Mflag=1;
                         endcode();};
^-*"*/"[ ]*\n               {Mflag=0;
                         debutcode();};

"/**"              {Mflag=1;printf("/$\\star$");};

"**/"                   {Mflag=0; REJECT;}

\n                      {if (Mflag==0) 
                           printf("\\\\ \n\\cmarg ");
                         else printf("\n");};

\t                      {if (Mflag==0) 
                           printf("\\hspace{%dcm}",2);
                         else printf("\t");};
^[ ]*                   {if (Mflag==0) 
                           printf("\\hspace{%.1fcm}",strlen(yytext)*0.25);
                         else printf("%s",yytext);};

{alphabet1}+           {if (Mflag==0) CheckKey(yytext);
                       else printf("%s",yytext); };

"\\"      {if (Mflag==0)
               printf("$\\backslash$");
           else printf("\\");};
"*"      {if (Mflag==0) 
             printf("$\\star$");
          else printf("%s",yytext);};
"~" |
"^"      {if (Mflag==0) 
             printf("\\verb+%s+",yytext);
          else printf("%s",yytext);};
"$" |
"&" |
"#" |
"{" |
"}" |
"%" |
"_"      {if (Mflag==0) 
                printf("\\%s",yytext);
          else  printf("%s",yytext);};
"-"  |
"|"  |
"<"  |
">"      {if (Mflag==0) 
             printf("$%s$",yytext);
          else printf("%s",yytext);};

"Bold{"{alphabet1}+"}" 
         {/* add the word in tabkey */
          AddInKey(yytext,yyleng);};

%%
Begin()
{printf("\n\\documentstyle{article}");
 printf("\n\\textheight=660pt ");
 printf("\n\\textwidth=470pt ");
 printf("\n\\topmargin=-27pt ");
 printf("\n\\oddsidemargin=0pt ");
 printf("\n\\evensidemargin=0pt ");
 printf("\n\\begin{document}\n ");
};

End()
{
 printf("\n\\end{document}\n ");
};


cmargdef()
{ 
  printf("\n\\def\\cmarg{\\hspace{1cm}}\n");
};

debutcode()
{ printf ("\n\\begin{flushleft}\n{\\sl \n\\cmarg ");}

endcode()
{printf("}\n\\end{flushleft}\n");};

#define KEYTABMAX 100

char *Keytab[KEYTABMAX]={
            "int","char","float",
            "double","struct","union",
            "long", "short", "unsigned", 
	    "auto","extern","register", 
	    "typedef", "static", "goto",
	    "return", "sizeof",  "break",
            "continue", "if","else", 
	    "for",  "do", "while",
	    "switch",  "case", "default", "entry" };

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
       

CheckKey(string)
   char string[];
{int i ;
 for (i =0 ;i < MaxKey ; i++ )
    { 
      if (strcmp(string,Keytab[i])==0) 
        {
         printf("{\\bf %s}",string);
         return(1);};
    };
 
 for (i = 0 ; i < yyleng ; i++ ) 
   {
    if ( yytext[i]  != '_' )
      printf("%c",yytext[i]);
    else printf("\\_");
  };
return(0);
};




main(argc, argv)
int argc;
char *argv[];

{
    struct stack_entry {  /* stack entry */
	int h, v, w, x, y, z;  /* what's on stack */
    };
    DecodeArgs( argc, argv );
    yylex();
    return(0);
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
	      default:
		++argind;
		printf("%c is not a legal flag\n", *tcp);
		break;
	      }
	else ++argind;
      };
    
  };

