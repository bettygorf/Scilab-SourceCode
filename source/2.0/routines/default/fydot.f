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
c   INSERT YOUR ROUTINE HERE 
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
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc unix
      call dyncall(it1-1,n,t,y,ydot) 
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
