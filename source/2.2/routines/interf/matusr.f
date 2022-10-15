      subroutine matusr.f
c
      include '../stack.h'
c
      integer iadr, sadr

      iadr(l)=l+l-1
      sadr(l)=(l/2)+1
      rhs = max(0,rhs)
c
      return
      end
