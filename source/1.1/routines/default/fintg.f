C/MEMBR ADD NAME=FINTG,SSI=0
      double precision function fintg(x)
c!
c  CALLING SEQUENCE: subroutine XXXXXX(x,f)
c!
      include '../stack.h'

C      implicit undefined (a-z)
      double precision x,pi
c
      integer it1
c
      character*6    name,nam1
      common /cintg/ name
      integer         iero
      common /ierode/ iero
c
      fintg=0.0d0
      iero=0
      call majmin(6,name,nam1)
c
c              EXAMPLE of FORTRAN CALL (nam1 is the chain
c                                       sent by intg)
c              SEE scilab/tests/intg.tst
c+
      if(nam1.eq.'toto') then
       pi=3.1415926520d+0
       fintg=x*sin(30.0d+0*x)/sqrt(1.0d+0-(x/(2.0d+0*pi))**2)
       return
      endif
c+
c 
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,x,fintg)
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
