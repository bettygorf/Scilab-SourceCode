      subroutine mklist(n)
c     form the list built with last n varaibles stored in top-n+1:top
c      positions of the stack
c!
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
      call lstelm
      rhs=srhs
      lhs=slhs
      fin=sfin
      return
      end
