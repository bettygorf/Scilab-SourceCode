      subroutine fex (neq, t, y, ydot)
      double precision t, y, ydot
      dimension y(3), ydot(3)
c     ode example
c     ode([1;0;0],0,[0.4,4],'fex'
c     must return --> y(3,2)=9.4440d-2
      ydot(1) = -.0400d+0*y(1) + 1.0d+4*y(2)*y(3)
      ydot(3) = 3.0d+7*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      return
      end
