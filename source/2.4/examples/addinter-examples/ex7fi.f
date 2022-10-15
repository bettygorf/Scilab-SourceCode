c SCILAB function : foubare, fin = 1
c     Copyright INRIA
      subroutine intgabs(fname)
      character*(*) fname
      logical getrhsvar, putlhsvar
      logical checklhs,checkrhs
      include '../../routines/stack.h'
c
       nbvars=0
       minrhs=1
       maxrhs=1
       minlhs=1
       maxlhs=1
c
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,minlhs,maxlhs)) return
c
       if(.not.getrhsvar(1,'d',m1,n1,l1)) return
c     variable 1 is a m1 x n1 matrix
c     Scilab function g_abs is executed
       call callscifun('g_abs')
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
c
       end

c   interface   function 
c   ********************
      subroutine intex7
c
      INCLUDE '../../routines/stack.h'
      rhs = max(0,rhs)
c
      goto (1) fin
      return
 1    call intgabs('pipo')
      return
      end


