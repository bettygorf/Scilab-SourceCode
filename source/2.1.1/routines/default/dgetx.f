C/MEMBR ADD NAME=DGETX,SSI=0
      subroutine dgetx(x, incr, istart)
c!
c sous programme d'interface entre la fonction corr et un sous
c programme definissant les x
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
c pour interfacer d'autres simulateurs modifier les lignes (entre c+ )
c qui suivent en fonction du nom de la ou des routines a appeler.
c+
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.namex) goto 1001
cc sun unix
      call dyncall(it1-1,x,incr,istart)
cc fin
      return
c
 2000 iero=1
      buf=namex
      return
c
      end
