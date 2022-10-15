      subroutine setfunnam(id,fct,nf)
c     Copyright INRIA
      INCLUDE '../stack.h'
      integer id(nsiz)
      character*(*) fct
      integer name(nlgh),name1(nlgh)

      n1=min(nf,24)
      call cvstr(n1,name,fct,0)
      call namstr(id,name,n1,0)
      return
      end
