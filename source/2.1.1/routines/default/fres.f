C/MEMBR ADD NAME=FRES,SSI=0
      subroutine fres(ny,t,y,s,r,ires)
c!
c    interface d'appel pour les sytemes implicites fonction impl
c
c    la subroutine appelee doit charger le vecteur r=g(t,y)-a(t,y)*s
c
c entree : t    temps
c          y    approximation de la solution au temps t
c          s    approximation de la derivee dy/dt
c          ny   taille de y
c          ires peut etre ignore
c!
      include '../stack.h'

      integer ires,ny
      double precision r(*),s(*),t,y(*)
c
      integer it1
c
      character*6   name,nam1
      common /cres/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c pour interfacer d'autres simulateurs modifier les lignes entre c+
c qui suivent   en fonction du nom de la ou des routines a appeler.
c ce nom est donne dans la variable name.
c+
      if(nam1.eq.'resid') then
       call resid(ny,t,y,s,r,ires)
       return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,ny,t,y,s,r,ires)
cc fin
      return
c
 2000 iero=1
      ires=2
      buf=name
      call error(50)
      return
      end
