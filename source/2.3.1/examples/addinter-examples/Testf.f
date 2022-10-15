       subroutine intfce1(fname)
c
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, createvarfromptr
       double precision l1
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       call dblearray(l1,me1,ne1,err)

       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
        return
       endif
c
       if(.not.createvarfromptr(maxrhs+1,'d',me1,ne1,l1)) return
       call freeptr(l1)
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       end
c
       subroutine intfce2(fname)
c
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, createvarfromptr
       double precision l1
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       call intarray(l1,me1,ne1,err)

       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
        return
       endif
c
       if(.not.createvarfromptr(maxrhs+1,'i',me1,ne1,l1)) return
       call freeptr(l1)
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       end
c
       subroutine intfce3(fname)
c
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, createvarfromptr
       double precision l1
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       call crestr(l1,m,err)

       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
        return
       endif
c
       if(.not.createvarfromptr(maxrhs+1,'c',m,1,l1)) return
       call freeptr(l1)
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       end


       subroutine intfce4(fname)
c
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, getrhsvar
       integer l1
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
       call as2os(cstk(l1:l1+m*n-1))

       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
        return
       endif
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       end

       subroutine intfce5(fname)
c
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, createvar
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 1
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c    Reading scilab variable "param" 
       call matptr('param',m,n,lp)
c
       if(.not.createvar(1,'d',m,n,l1)) return
       call dcopy(m*n,stk(lp),1,stk(l1),1)

       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(999)
        return
       endif
c
       lhsvar(1)=1
       if(.not.putlhsvar()) return
       end


c  interface function 
c   ********************
       subroutine testfentry
       include '../../routines/stack.h'
       rhs=max(rhs,0)
c
       goto (1,2,3,4,5) fin
       return
 1     call intfce1('funcf1')
       return
 2     call intfce2('funcf2')
       return
 3     call intfce3('funcf3')
       return
 4     call intfce4('funcf4')
       return
 5     call intfce5('funcf5')
       end




