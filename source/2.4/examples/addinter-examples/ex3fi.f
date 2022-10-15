       subroutine intfce1(fname)
c      --------------------------
c     Copyright INRIA
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
c
       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(998)
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
c      --------------------------
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
        call error(998)
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
c      --------------------------
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
        call error(998)
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
c      --------------------------
       character*(*) fname
       logical checkrhs,checklhs
       include '../../routines/stack.h'
       logical putlhsvar, createvarfromptr
       double precision l1,l2,l3
c     
       nbvars = 0
       minrhs = 0
       maxrhs = 0
       maxlhs = 3
c     
       if(.not.checkrhs(fname,minrhs,maxrhs)) return
       if(.not.checklhs(fname,1,maxlhs)) return
c     
       call crestr(l1,m,err)
       call intarray(l2,me2,ne2,err)
       call dblearray(l3,me3,ne3,err)       
       if(err .gt. 0) then 
        buf = fname // 'Internal Error' 
        call error(998)
        return
       endif
c
       if(.not.createvarfromptr(maxrhs+1,'c',m,1,l1)) return
       if(.not.createvarfromptr(maxrhs+2,'i',me2,ne2,l2)) return
       if(.not.createvarfromptr(maxrhs+3,'d',me3,ne3,l3)) return
       call freeptr(l1)
       call freeptr(l2)
       call freeptr(l3)
c
       lhsvar(1)=1
       lhsvar(2)=2
       lhsvar(3)=3
       if(.not.putlhsvar()) return
       end


c  interface function 
c   ********************
       subroutine testfentry3
       include '../../routines/stack.h'
       rhs=max(rhs,0)
c
       goto (1,2,3,4) fin
       return
 1     call intfce1('funcf1')
       return
 2     call intfce2('funcf2')
       return
 3     call intfce3('funcf3')
       return
 4     call intfce4('funcf4')
       return
       end




