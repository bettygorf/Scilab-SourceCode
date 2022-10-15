
c*------------------------------------------------------------------
c csiz  definit la taille des deux tables alf(a b) de codage des caracteres
c bsiz  definit la taille de la chaine buuf (buffer interne de scilab)
c       peut etre augmentee uniquement dans le sous programme matlab
c isiz  definit le nombre maximal de variables scilab pouvant etre crees
c psiz  definit la taille des tableaux lies a la recursion
c lsiz  definit la taille du vecteur contenant la ligne d'instruction en
c       cours d'analyse
c vsiz  definit la taille de la "pile" des variables
c       peut etre augmentee uniquement dans le sous programme matlab
c nlgh  definit le nombre maximum de caracteres pris en compte pour les noms
c       de variables
c nftn  nombre de  caracteres maximum autorises pour un nom de sous programme
c       (link dynamique) peut etre augmentee uniquement dans le sous programme
c       matlab
c maxlnk nombre de  caracteres maximum autorises pour un nom de sous programme
c       (link dynamique) peut etre augmentee uniquement dans le sous programme
c        matlab

      integer   csiz,bsiz,isiz,psiz,nsiz,lsiz
      parameter (csiz=63,bsiz=4096,isiz=500,psiz=128,nsiz=2,lsiz=4096)
      integer   nlgh,vsiz
      parameter (nlgh=8,vsiz=300000)
      integer   nftn,maxlnk
      parameter (nftn=20,maxlnk=50)
      integer   maxdb,maxbpt
      parameter (maxdb=20,maxbpt=100)
c
      double precision stk(vsiz)
      common /stack/ stk
      integer istk(2*vsiz)
      equivalence (istk(1),stk(1))

      integer bot,top,idstk(nsiz,isiz),lstk(isiz),leps,bbot,bot0
      common /vstk/ bot,top,idstk,lstk,leps,bbot,bot0

      integer ids(nsiz,psiz),pstk(psiz),rstk(psiz),pt,niv,macr,paus
      integer icall
      common /recu/ ids,pstk,rstk,pt,niv,macr,paus,icall

      integer ddt,err,lct(8),lin(lsiz),lpt(6),hio,rio,wio,rte,wte
      common /iop/ ddt,err,lct,lin,lpt,hio,rio,wio,rte,wte

      integer err1,err2,errct,toperr
      common /errgst/ err1,err2,errct,toperr

      integer sym,syn(nsiz),char1,fin,fun,lhs,rhs,ran(2),comp(2)
      common /com/ sym,syn,char1,fin,fun,lhs,rhs,ran,comp

      character alfa(csiz)*1,alfb(csiz)*1,buf*(bsiz)
      common /cha1/ alfa,alfb,buf

      integer nlink
      common /link1/ nlink

      character*(nftn) tablin(maxlnk)
      common /link2/ tablin

      integer wmac,lcntr,nmacs,macnms(nsiz,maxdb),lgptrs(maxdb+1)
      integer bptlg(maxbpt)
      common /dbg/ wmac,lcntr,nmacs,macnms,lgptrs,bptlg


c*------------------------------------------------------------------
