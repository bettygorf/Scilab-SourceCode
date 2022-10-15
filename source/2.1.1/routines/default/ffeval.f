      subroutine ffeval(nn,x1,x2,xres,itype,name) 
c!
C     Interface function for the scilab feval primitive 
C     the external argument passed to ffeval 
c     can be defined in a Fortran or C file as follows
c     
c     feval external interface. For dynamic link,use
c      subroutine XXXXXX(nn,x1,x2,xres,itype)
C     
c        EXAMPLE
c    ---------------------------------------------------------
c    subroutine ftest(nn,x1,x2,xres,itype)
cc   For returning vector xres with xres(i)=f(x1(i)) (nn=1)
cc   or  matrix xres with xres(i,j)=f(x1(i),x2(j))   (nn<>1)
c      double precision x1,x2
c      double precision xres(2)
c      if (nn.eq.1) then
c      xres(1)=2.d0*x1+3.d0
c                   else
c      xres(1)=2.d0*x1+3.d0*x2
c      endif
Cc     set itype to 1 or 0 if you return real data or complex 
Cc     (i.e on value xres(1) or two values xres(1),xres(2) to 
CC     code a complex number 
C      itype=0
c      return
c      end
c    ---------------------------------------------------------
cc 
c
c Once compiled ("make ftest.o")  and  
c linked to SCILAB by the command link('ftest.o','ftest')
c ftest is dynamically called by e.g. the command:
c x=feval(1:5,'ftest')   (x is a vector with x(i)=2*i+3 i=1,..,5)
C     will call ftest with nn=1
c or
c x=feval(1:5,1:3,'ftest')   (x is a 5 x 3 matrix x(i,j)=2*i+3*j)
C     will call ftest with nn=2
C     
c!
      include '../stack.h'

c      implicit undefined (a-z)
      double precision x1,x2
      double precision xres(2)
c
      integer it1,itype,nn
c
      character*6     name,nam1
      integer         iero
      common /ierfeval/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c Below you can insert your own program (non dynamic link:
c       you must recompile ffeval.f et re-make Scilab)
c     nn=1 or 2 according to the number of parameters of f
c     x1 and x2 are the two arguments to be sent
C     output : xres(2) and itype
C     itype = 1 --> complex result
C     itype = 0 --> real result
c     xres(1) = real part ;  xres(2) imaginary part
c
c+
      if(nam1.eq.'parab') then
         if (nn.eq.1) then 
            xres(1)=x1**2
            itype=0
c            xres(2)=33.d0
c            itype=1
         else
            xres(1)=x1**2+x2**2
            itype=0
c            xres(2)=33.d0
c            itype=1
         endif
       return
      endif
c+
c
c dynamic link (for Unix)
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
      call dyncall(it1-1,nn,x1,x2,xres,itype)
cc 
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
