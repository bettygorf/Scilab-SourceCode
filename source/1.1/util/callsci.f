      program callsci
c
c      CHECK COMPATIBILITY WITH routines/stack.h
c
      integer csiz,bsiz,isiz,psiz,nsiz,lsiz,vsiz,nlgh
      parameter (csiz=60,bsiz=256,isiz=512,psiz=128,nsiz=2,lsiz=4096)
      parameter (nlgh=8,vsiz=80000)
      double precision stk(vsiz)
      integer bot,top,idstk(nsiz,isiz),lstk(isiz),istk(2*vsiz),adr
      integer ids(nsiz,psiz),pstk(psiz),rstk(psiz),pt,niv,macr,paus
      integer ddt,err,lct(7),lin(lsiz),lpt(6),hio,rio,wio,rte,wte
      integer sym,syn(nsiz),char,fin,fun,lhs,rhs,ran(2),comp(2)
      character alfa(csiz)*1,alfb(csiz)*1,buf*(bsiz)
      common /stack/ stk
      common /vstk/ bot,top,idstk,lstk,leps
      common /recu/ ids,pstk,rstk,pt,niv,macr,paus
      common /iop/ ddt,err,lct,lin,lpt,hio,rio,wio,rte,wte
      common /com/ sym,syn,char,fin,fun,lhs,rhs,ran,comp
      common /char/ alfa,alfb,buf
      equivalence (istk(1),stk(1))
c*------------------------------------------------------------------
c      calling scilab from fortran
c      the file example.bas is a file of Scilab commands
c      possible content of the file example.bas:
c               (uncomment and duplicate if necessary)
c//<x>=exemple(a,b)
c//computation of x such that a*x=b  (a and b real matrices)
c  x=a\b
c  quit
c     here a,b and x  Scilab variables.
c
      dimension a(2,2),b(2),x(2),y(2)
      double precision a,b,x,y
      character*80 text
c
c     on definit a et b
c
      a(1,1)=1.d0
      a(2,1)=2.d0
      a(1,2)=3.d0
      a(2,2)=4.d0
      b(1)=1.d0
      b(2)=0.d0
c
c     first call to Scilab (main pgm is matlab) for initializations
c
      text=' '
      call matlab(-1,text)
c
c       fortran variables sent to Scilab.
c       2nd argument of matz not referenced here.
c       3rd argument is the first dimension of the transmitted 
c       variable (here dimension a(2,.) )
c       arguments #3 and 4 represent the number of rows and columns
c       respectively
c       argument #5 is a character string name of the scilab variable
c       argument #6 (here job=1) means direction fortran--->scilab
c
      call matz(a,a,2,2,2,'a',1)
      call matz(b,b,2,2,1,'b',1)
c
      text='exec(''exemple.bas'',-1)'
      call matlab(-2,text)
c      other possible call 
c      open(unit=10,file='exemple.bas',form='formatted')
c      call matlab(10,' ')
c
c     Scilab x ---> fortran x.
c     the numbers m and n (dimensions of x) are here given
c     by scilab .Don't give numerical values to arguments
c     4 and 5 of matz here.
c     last argument (job=0) means:   scilab --->fortran
      call matz(x,x,2,m,n,'x',0)
      write(6,100) x(1),x(2)
 100  format(2x,f10.5,2x,f10.5)
      text='y=a*x-b;quit'
      call matlab(-2,text)
      call matz(y,y,2,m,n,'y',0)
      write(6,100) y(1),y(2)
      stop
      end
