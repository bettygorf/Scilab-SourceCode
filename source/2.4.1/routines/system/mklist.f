      subroutine mklist(n)
c     form the list built with last n variables stored in top-n+1:top
c      positions of the stack
c!
c     Copyright INRIA
      include '../stack.h'
      integer n,srhs,slhs,sfin
c
      srhs=rhs
      slhs=lhs
      sfin=fin
c
      rhs=n
      fin=1
      lhs=1
      call ref2val
      call lstelm
      rhs=srhs
      lhs=slhs
      fin=sfin
      return
      end
