      subroutine intdgemm(fname)
c***************************************************************************
c     Example of interface: dgemm.f  (BLAS3)
c   usage: 
c   addinter(['ex4fi.o'],'dgemmentry','dgemm')
c
c   C=dgemm(alfa,A,B,beta,C)
c
c************************************************************************

c     Copyright INRIA
      include '../../routines/stack.h'
      logical getrhsvar,putlhsvar
      logical checklhs,checkrhs
      character fname*(*)
c
       nbvars=0
c*****************************************************
c      0-Check number of rhs and lhs arguments
c*****************************************************       
       minrhs=5
       maxrhs=5
       minlhs=1
       maxlhs=1
c
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,minlhs,maxlhs)) return

c*****************************************************
c      1-Get rhs parameters
c*****************************************************
c      alpha
       if(.not.getrhsvar(1,'d', m1,n1, lalfa))return
c      A
       if(.not.getrhsvar(2,'d', mA,nA, lA)) return
c      B
       if(.not.getrhsvar(3,'d', mB,nB, lB)) return
c      beta
       if(.not.getrhsvar(4,'d', m4,n4, lbeta)) return
c      C
       if(.not.getrhsvar(5,'d', mC,nC, lC)) return
       m=mA
       n=nB
       if((nA.ne.mB).or.((m1*n1*m4*n4).ne.1)) then
            call erro("Bad call to dgemm")
            return
       endif
       if((mA.ne.mC).or.(nB.ne.nC)) then
            call erro("invalid matrix dims in "//fname(1:6))
            return
       endif
c
       k=nA
       call dgemm('n','n',m ,n ,k,stk(lalfa),
     $      stk(lA),mA ,stk(lB),mB ,stk(lbeta) ,stk(lC),mC)

c      Return C (#5)
       lhsvar(1)=5
       if(.not.putlhsvar()) return
c
       end

c  interface function 
c   ********************
       subroutine fdgemmentry
       include '../../routines/stack.h'
       rhs = max(0,rhs)
c
c      To each fin corresponds one interface and one scilab function
c
       goto (1) fin
       return
 1     call intdgemm('dgemm')
       return
       end




