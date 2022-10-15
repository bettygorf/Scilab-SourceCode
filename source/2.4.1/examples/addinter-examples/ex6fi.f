       subroutine intstr1f(fname)
c      --------------------------
c     Copyright INRIA
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, getrhsvar
c     
       nbvars = 0
       minrhs = 1
       maxrhs = 1
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       if(.not.getrhsvar(1,'c',m,n,l1)) return
       call as2osf(cstk(l1:l1+m*n-1))
       
c     
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       return 
       end
c

       subroutine intstr2f(fname)
c      --------------------------
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, cmatptr,createvar
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       if(.not.cmatptr('param'//char(0),m,n,lp)) return 
       if(.not.createvar(1,'d',m,n,lo1)) return
c     
       call dcopy(m*n,stk(lp),1,stk(lo1),1)
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       return
       end
c

c  interface function 
c   ********************
       subroutine intex6f
       include '../../routines/stack.h'
       rhs=max(rhs,0)
c
       goto (1,2) fin
       return
 1     call intstr1f('modstr')
       return
 2     call intstr2f('stacc')
       return
       end




