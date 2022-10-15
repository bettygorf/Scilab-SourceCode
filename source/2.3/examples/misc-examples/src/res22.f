      subroutine res22(t,y,ydot,delta,ires,rpar,ipar)
      double precision t,y,ydot,delta,rpar
      integer neq,ipar
c
      dimension y(*), ydot(*), delta(*)
      neq=2
      call f2(neq,t,y,delta)
      do 10 i = 1,neq
         delta(i) = ydot(i) - delta(i)
 10   continue
      end

      subroutine f2 (neq, t, y, ydot)
      double precision t,y,ydot
      integer neq
c
      dimension y(*), ydot(*)
      ydot(1) = y(2)
      ydot(2) = 100.0d0*(1.0d0 - y(1)*y(1))*y(2) - y(1)
      end

