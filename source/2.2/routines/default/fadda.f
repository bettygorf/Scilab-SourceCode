      subroutine fadda(ny,t,y,ml,mu,p,nrowp)
c!
c  user interface for impl
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
c 
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine aplusp is an example: it is called when the
c string 'aplusp' is given as a parameter 
c in the calling sequence of scilab's impl built-in
c function 
c+
      if(nam1.eq.'aplusp') then
        call aplusp(ny,t,y,ml,mu,p,nrowp)
        return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000

      call dyncall(it1-1,ny,t,y,ml,mu,p,nrowp)
cc end
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end

      subroutine aplusp(neq, t, y, ml, mu, p, nrowp)
c example of routine called by impl
      double precision p, t, y
      dimension y(3), p(nrowp,3)
      p(1,1) = p(1,1) + 1.0d+0
      p(2,2) = p(2,2) + 1.0d+0
      return
      end
