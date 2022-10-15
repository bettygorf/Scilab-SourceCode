      subroutine ftob(x,nx,topx)
      include '../stack.h'
      integer adr
c
c     fortran to scilab
      integer topx,hsize
      double precision x
      dimension x(*)
c
      ilx=adr(lstk(topx),0)
      hsize=4
      if(istk(ilx).eq.2) hsize=9+istk(ilx+1)*istk(ilx+2)
      if(top.ge.bot) then
         call error(18)
         return
      endif
      top=top+1
      il=adr(lstk(top),0)
      err=lstk(top)+adr(hsize,1)+nx-lstk(bot)
      if(err.gt.0) then
         call error(17)
         return
      endif
      call icopy(hsize,istk(ilx),1,istk(il),1)
      l=adr(il+hsize,1)
      call dcopy(nx,x,1,stk(l),1)
      lstk(top+1)=l+nx
      return
      end
