      subroutine dgety(y, incr, istart)
c!
c user interface for corr function
c!
c reference externe : dyncall
c!
      include '../stack.h'

      integer incr,istart
      double precision y(*)
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
c
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine myownx is an example: it is called when the
c string 'myowny' is given as a parameter 
c in the calling sequence of scilab's corr built-in
c function 
c+
c       call myowny(x, incr, istart)
c+
c sous programmes lies dynamiquement.
      call tlink(namey,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,y,incr,istart)
cc fin
      return
c
 2000 iero=1
      buf=namey
      return
c
      end
