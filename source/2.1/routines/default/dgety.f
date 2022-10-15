C/MEMBR ADD NAME=DGETY,SSI=0
      subroutine dgety(y, incr, istart)
c!
c sous programme d'interface entre la fonction corr et un sous
c programme definissant les y
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
c pour interfacer d'autres simulateurs modifier les lignes (entre c+ )
c qui suivent en fonction du nom de la ou des routines a appeler.
c+
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.namey) goto 1001
cc sun unix
      call dyncall(it1-1,y,incr,istart)
cc fin
      return
c
 2000 iero=1
      buf=namey
      return
c
      end
