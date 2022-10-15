      subroutine vvtosci(x,nx)
c     fortran var2vec  to scilab
c     x is supposed to be a fortran image of var2vec result
c 
c     Copyright INRIA
      double precision x(*)
c 
      integer  l
c 
      external dcopy, error
      include "../stack.h"
c 
      if (top .ge. bot) then
        call error(18)
      else
        top = top + 1
        l=lstk(top)
        err = l + nx - lstk(bot)
        if (err .gt. 0) then
          call error(17)
          return
       endif
       call dcopy(nx,x,1,stk(l),1)
       lstk(top+1) = l + nx
      endif
      end 
