      subroutine fydot(n,t,y,ydot)
c!
c interfce for ode.
c ydot=f(t,y).
c n = size of y
c!
      include '../stack.h'
      integer n
      double precision t,y(n),ydot(n)
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
c *****************************
c   INSERT YOUR ROUTINE HERE   (and re-make scilab for link)
c   example  ode(y0,t0,t1,'fex') --> if(nam1.eq.'fex') then ...
c   the fex subroutine is called here
c ******************************
c+
      if(nam1.eq.'fex') then
       call fex(n,t,y,ydot)
       return
      endif
      if(nam1.eq.'loren') then
      call loren(n,t,y,ydot)
      return
      endif
      if(nam1.eq.'arnol') then
      call arnol(n,t,y,ydot)
      return
      endif
      if(nam1.eq.'bcomp') then
      call bcomp(n,t,y,ydot)
      return
      endif
      if(nam1.eq.'lcomp') then
      call lcomp(n,t,y,ydot)
      return
      endif
c+
c      dynamic link
      call tlink(name,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,n,t,y,ydot) 
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end

      subroutine fex (neq, t, y, ydot)
      double precision t, y, ydot
      dimension y(3), ydot(3)
c     ode example
c     ode([1;0;0],0,[0.4,4],'fex')
c     must return --> y(3,2)=9.4440d-2
      ydot(1) = -.0400d+0*y(1) + 1.0d+4*y(2)*y(3)
      ydot(3) = 3.0d+7*y(2)*y(2)
      ydot(2) = -ydot(1) - ydot(3)
      return
      end
