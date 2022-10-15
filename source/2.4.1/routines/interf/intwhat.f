      subroutine intwhat(fname)
c     
c     Copyright INRIA
      include '../stack.h'
c     
      character*(*) fname
      logical checklhs,checkrhs
      integer iadr

      integer cmdl,id(nsiz)
      parameter (cmdl = 22)
      integer cmd(nsiz,cmdl)
      common/cmds/cmd


      iadr(l)=l+l-1
c
      rhs=max(0,rhs)
c
      if(.not.checklhs(fname,1,1)) return
      if(.not.checkrhs(fname,0,0)) return
c
      call funtab(id,0,0)
c     comandes
      fin = 1
      call msgs(41,0)
      call prntid(cmd,cmdl,wte)
c     
      top=top+1
      il = iadr(lstk(top))
      istk(il) = 0
      lstk(top+1) = lstk(top) + 1
      end
