      double precision function fintg(x)
c!
c  CALLING SEQUENCE: subroutine XXXXXX(x,f)
c!
      include '../stack.h'

C      implicit undefined (a-z)
      double precision x,pi,y
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
c     if(nam1.eq.myfunc') then
c     fintg=myfunc(x)
c     endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,x,y)
      fintg=y
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end

c      subroutine foo(x,tt)
c test example (see SCIDIR/tests/intg.tst)
c      double precision x,pi,tt
c      pi=3.1415926524897932
c      tt=x*sin(30*x)/sqrt(1.0d0-((x/(2*pi))**2))
c      return
c      end
