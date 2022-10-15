      subroutine fres(ny,t,y,s,r,ires)
c!
c    user interface for impl function
c
c    subroutine must calculate vector r=g(t,y)-a(t,y)*s
c
c inputs : t    time
c          y    y at time t
c          s    dy/dt at time t
c          ny   size of y
c          ires can be ignored
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
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c The routine resid is an example: it is called when the
c string 'resid' is given as a parameter 
c in the calling sequence of scilab's impl built-in
c function 
c+
      if(nam1.eq.'resid') then
       call resid(ny,t,y,s,r,ires)
       return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
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

      subroutine resid(neq, t, y, s, r, ires)
c example
      double precision r, s, t, y
      dimension y(3), s(3), r(3)
      r(1) = -.040d+0*y(1) + 1.0d+4*y(2)*y(3) - s(1)
      r(2) =  .040d+0*y(1) - 1.0d+4*y(2)*y(3) - 3.0d+7*y(2)*y(2) - s(2)
      r(3) = y(1) + y(2) + y(3) - 1.0d+0
      return
      end
