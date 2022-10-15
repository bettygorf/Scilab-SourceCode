      subroutine lsdisc (f, neq, y, t, tout, rwork,lrw,istate )
      external f
      integer neq,  lrw
      double precision y(neq), t, tout,  rwork(lrw)
c!purpose
c
c  Simulation of non linear recurrence equations of type 
c  x_{t+1}=f(x_{t},t)
c
c!summary of usage.
c
c La philosophie d'utilisation est la meme que pour lsoda 
c a. first provide a subroutine of the form..
c               subroutine f (neq, t, y, ydot)
c               dimension y(neq), ydot(neq)
c which supplies the vector function f by loading ydot(i) with f(i).
c
c b. write a main program which calls subroutine lsoda once for
c each point at which answers are desired.  this should also provide
c for possible use of logical unit 6 for output of error messages
c by lsoda.  on the first call to lsoda, supply arguments as follows..
c f      = name of subroutine for right-hand side vector f.
c          this name must be declared external in calling program.
c neq    = number of first order ode-s.
c y      = array of initial values, of length neq.
c t      = the initial value of the independent variable.
c tout   = first point where output is desired (.ne. t).
c istate = 2  if lsdisc was successful, negative otherwise.
c!
c-----------------------------------------------------------------------
      integer         iero
      common /ierode/ iero
c
      iero=0	
      call f (neq, t, y, rwork)
      if(iero.gt.0) return
      call dcopy(neq,rwork,1,y,1)
      t=tout
      istate=2
      return
      end
