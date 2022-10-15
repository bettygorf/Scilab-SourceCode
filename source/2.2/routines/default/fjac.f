      subroutine fjac (neq, t, y, ml, mu, pd, nrpd)
c!
c  user interface for scilab built-in function ode
c  jacobian evaluation
c!
      include '../stack.h'

      integer ml,mu,neq,nrpd
      double precision pd(nrpd,*),t,y(*)
c
      integer it1
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
c The routine jex is an example: it is called when the
c string 'jex' is given as a parameter 
c in the calling sequence of scilab's ode built-in
c function 
c+
      if(nam1.eq.'jex') then
       call jex(neq,t,y,ml,mu,pd,nrpd)
       return
      endif
c+
c     dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,neq,t,y,ml,mu,pd,nrpd)
cc fin
      return
c
 2000 iero=1
      buf=name
      return
      end

      subroutine jex (neq, t, y, ml, mu, pd, nrpd)
      double precision pd, t, y
      dimension y(3), pd(nrpd,3)
c     jacobian routine jex
c     scilab ode
c     ode([1;0;0],0,[0.4,4],'fex','jex')
      pd(1,1) = -.040d+0
      pd(1,2) = 1.0d+4*y(3)
      pd(1,3) = 1.0d+4*y(2)
      pd(2,1) = .040d+0
      pd(2,3) = -pd(1,3)
      pd(3,2) = 6.0d+7*y(2)
      pd(2,2) = -pd(1,2) - pd(3,2)
      return
      end
