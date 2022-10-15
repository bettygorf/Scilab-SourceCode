      subroutine dgetx(x, incr, istart)
c!
c user interface for corr 
c!
c reference externe : dyncall
c!
      include '../stack.h'
      integer incr,istart
      double precision x(*)
c
      integer   it1
c
      character*6   namex,namey
      common /pse2/ namex,namey
      integer         iero
      common /ierode/ iero
c
      iero=0
c
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine myownx is an example: it is called when the
c string 'myownx' is given as a parameter 
c in the calling sequence of scilab's corr built-in
c function 
c+
c       call myownx(x, incr, istart)
c+
c    dynamic link
      call tlink(namex,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,x,incr,istart)
cc fin
      return
c
 2000 iero=1
      buf=namex
      return
c
      end
