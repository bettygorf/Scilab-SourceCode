      subroutine fsurf(ny, t, y, ng, gout) 
c!
c interface de calcul d'un second membre pour la commande scilab ode.
c la subroutine apellee evalue ydot=f(t,y).
c n est la taile du systeme
c!
      include '../stack.h'
      double precision t,y(ny),gout(ng)
c
      integer it1
c
      character*6    name,nam1
      common /cydot/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c+

c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,ny,t,y,ng,gout) 
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
