c SCILAB function : foubare, fin = 1
      subroutine intsfoubare(fname)
      character*(*) fname
      logical getrhsvar, createvar,  putlhsvar
      include '../../routines/stack.h'
c
       nbvars=0
       minrhs=4
       maxrhs=4
       minlhs=1
       maxlhs=5
c
       if(.not.((rhs.ge.minrhs).and.(rhs.le.maxrhs))) then
          call erro('wrong number of rhs arguments')
       endif
       if(.not.((lhs.ge.minlhs).and.(lhs.le.maxlhs))) then
          call erro('wrong number of lhs arguments')
       endif
c
       if(.not.getrhsvar(1,'c',m1,n1,l1)) return
       if(.not.getrhsvar(2,'i',m2,n2,l2)) return
       if(.not.getrhsvar(3,'r',m3,n3,l3)) return
       if(.not.getrhsvar(4,'d',m4,n4,l4)) return
c
       if(.not.createvar(5,'d',m4,n4,l5)) return
       if(.not.createvar(6,'d',m4,n4,l6)) return
c
       call foubare2f(cstk(l1:l1+m1*n1),istk(l2),n2*m2,sstk(l3),n3*m3,
     $      stk(l4),m4,n4,stk(l5),stk(l6),ierr)
       if(ierr .gt. 0) then 
        buf = 'Internal Error in' 
        call error(9999)
        return
       endif
c
       lhsvar(1)=5
       lhsvar(2)=4
       lhsvar(3)=3
       lhsvar(4)=2
       lhsvar(5)=1
       if(.not.putlhsvar()) return
c
       end


c  interface function 
c   ********************
       subroutine foobar
       include '../../routines/stack.h'
       rhs = max(0,rhs)
c
       goto (1) fin
       return
 1     call intsfoubare('foubare')
       return
       end




