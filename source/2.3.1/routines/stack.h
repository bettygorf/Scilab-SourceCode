
c*------------------------------------------------------------------
c vsiz  size of internal scilab stack 
c
c bsiz  size of internal chain buf 
c
c isiz  maximum number of scilab variables
c psiz  defines recursion size
c lsiz  dim. of vector containing the command line
c nlgh  length of variable names
c csiz  used for character coding
c*-------------------------------------------------------------------
      integer   csiz,bsiz,isiz,psiz,nsiz,lsiz
      parameter (csiz=63,bsiz=4096,isiz=1024,psiz=256,nsiz=6,lsiz=16384)
      integer   nlgh,vsiz
      parameter (nlgh=nsiz*4,vsiz=2)
      integer   maxdb,maxbpt
      parameter (maxdb=20,maxbpt=100)
c
      double precision stk(vsiz)
      common /stack/ stk
      integer istk(2*vsiz)
      equivalence (istk(1),stk(1))

      real sstk(2*vsiz)
      equivalence (sstk(1),stk(1))
       
      character cstk*(4*vsiz)
      equivalence (cstk,stk(1))

      integer bot,top,idstk(nsiz,isiz),lstk(isiz),leps,bbot,bot0
      integer infstk(isiz)
      common /vstk/ bot,top,idstk,lstk,leps,bbot,bot0,infstk

      integer ids(nsiz,psiz),pstk(psiz),rstk(psiz),pt,niv,macr,paus
      integer icall
      common /recu/ ids,pstk,rstk,pt,niv,macr,paus,icall

      integer ddt,err,lct(8),lin(lsiz),lpt(6),hio,rio,wio,rte,wte
      common /iop/ ddt,err,lct,lin,lpt,hio,rio,wio,rte,wte

      integer err1,err2,errct,toperr,errpt
      common /errgst/ err1,err2,errct,toperr,errpt

      integer sym,syn(nsiz),char1,fin,fun,lhs,rhs,ran(2),comp(3)
      common /com/ sym,syn,char1,fin,fun,lhs,rhs,ran,comp

      character alfa(csiz)*1,alfb(csiz)*1,buf*(bsiz)
      common /cha1/ alfa,alfb,buf

      integer wmac,lcntr,nmacs,macnms(nsiz,maxdb),lgptrs(maxdb+1)
      integer bptlg(maxbpt)
      common /dbg/ wmac,lcntr,nmacs,macnms,lgptrs,bptlg

      common/adre/lbot,ie,is,ipal,nbarg,ladr(30)
      common/intersci/nbvars,nbrows(30),nbcols(30),ntypes(30),
     $      lad(30),lhsvar(30)

c*------------------------------------------------------------------

