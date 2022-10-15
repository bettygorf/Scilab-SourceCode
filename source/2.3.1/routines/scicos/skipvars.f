      subroutine skipvars(n)
c     decrease top by n . So n latest variables at the top of stack are
c     skipped 
      include '../stack.h'
      integer n
c
      top=top-n
      return
      end
