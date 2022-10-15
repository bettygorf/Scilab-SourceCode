      subroutine fadda(ny,t,y,ml,mu,p,nrowp)
c!
c interface pour les systemes implicites.
c
c  common /cadd/ name of routine to be called by impl
c  this routine makes p=p+a, where a=a(t,y) is a ny x ny matrix
c  and  a(t,y)*ydot=g(t,y)
c!
c inputs t,y,p
c outputs p
c nrowp=leading dimension of p
c!
      include '../stack.h'

      integer ml,mu,nrowp,ny
      double precision p(nrowp,*),t,y(*)
c
      integer it1
c
      character*6   name,nam1
      common /cadd/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c below insert your routine
c+
      if(nam1.eq.'aplusp') then
        call aplusp(ny,t,y,ml,mu,p,nrowp)
        return
      endif
c+
c dynamic link
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc unix
      call dyncall(it1-1,ny,t,y,ml,mu,p,nrowp)
cc end
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
