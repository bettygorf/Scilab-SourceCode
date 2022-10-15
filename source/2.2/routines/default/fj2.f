      subroutine fj2(ny,t,y,s,ml,mu,p,nrowp)
c!
c    user interface for impl
c    the called routine must return in p jacobian of
c    fynction res=g(t,y)-a(t,y)*s
c    p(i,j)=d res(i)/dy(j)
c
      include '../stack.h'
      integer ml,mu,nrowp,ny
      double precision p(nrowp,*),s(*),t,y(*)
c
      character*6   name,nam1
      common /cjac/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine dgbydy is an example: it is called when the
c string 'dgbydy' is given as a parameter 
c in the calling sequence of scilab's impl built-in
c function 
c+
      if(nam1.eq.'dgbydy') then
        call dgbydy(ny,t,y,s,ml,mu,p,nrowp)
        return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,ny,t,y,s,ml,mu,p,nrowp)
cc fin
      return
 2000 iero=1
      buf=name
      call error(50)
      return
      end

      subroutine dgbydy(neq, t, y, s, ml, mu, p, nrowp)
      double precision s, t, p, y
      dimension y(3), s(3), p(nrowp,3)
      p(1,1) = -.040d+0
      p(1,2) = 1.0d+4*y(3)
      p(1,3) = 1.0d+4*y(2)
      p(2,1) = .040d+0
      p(2,2) = -1.0d+4*y(3) - 6.0d+7*y(2)
      p(2,3) = -1.0d+4*y(2)
      p(3,1) = 1.0d+0
      p(3,2) = 1.0d+0
      p(3,3) = 1.0d+0
      return
      end
