      subroutine fcalcint(fname)
c***************************************************************************
c     Template of Scilab Fortran interface
c   usage: 
c addinter(['template.o','fortroutine1.o','fortroutine2.o,...'],
c           'entrypointroutine',
c          ['scilabfunctionname1','scilabfunctionname2,...'])
c
c addinter(a set of object files (thisinterfaceroutine.o + yourobjectfiles.o),
c   one entry point (the name of interface function as it appears below) , 
c   the name of scilab functions)
c
c   [y1,y2,...y_maxlhs]=scilabfunctionname1(x1,x2,...,x_maxrhs)
c
c   [y1,y2,...y_      ]=scilabfunctionname2(x1,x2,...,x_      )
c
c************************************************************************

      include '../../routines/stack.h'
      character fname*(*)
      logical putlhsvar,getrhsvar,createvar
c
       nbvars=0
c*****************************************************
c      0-Check number of rhs and lhs arguments
c*****************************************************       
       minrhs=1
       maxrhs=1
       minlhs=1
       maxlhs=2
c

       if(.not.((rhs.ge.minrhs).and.(rhs.le.maxrhs))) then
          call erro('wrong number of rhs arguments')
       endif
       if(.not.((lhs.ge.minlhs).and.(lhs.le.maxlhs))) then
          call erro('wrong number of lhs arguments')
       endif

c*****************************************************
c      1-Get rhs parameters
c*****************************************************
       if(.not.getrhsvar(1,'c',m1,n1,l1)) return
c*****************************************************
c      2-If necessary, create additional variables 
c          (working arrays, default values, ...)
c*****************************************************

       k=maxrhs+1
       if(.not.createvar(k,'i',1,1,l2)) return
c******************************************************
c      3-Routine call
c      stk  <-> double
c      sstk <-> real
c      istk <-> integer
c      cstk <-> character
       call fcalc(cstk(l1:l1+m1*n1-1),istk(l2))
c******************************************************
c      4-Display error message(s)
c******************************************************
       if(err .gt. 0) then 
        call erro('Error in ...')
       endif
c
c******************************************************
c      5- Set lhs parameters
c******************************************************
       lhsvar(1)=2
c******************************************************
c      6-Sending lhs variables to Scilab
c******************************************************
       if(.not.putlhsvar()) return
c
       end

      subroutine fcalc2int(fname)
      include '../../routines/stack.h'
      character fname*(*)
      logical putlhsvar,getrhsvar,createvar
c
       nbvars=0
c*****************************************************
c      0-Check number of rhs and lhs arguments
c*****************************************************       
       minrhs=0
       maxrhs=0
       minlhs=1
       maxlhs=1
c

       if(.not.((rhs.ge.minrhs).and.(rhs.le.maxrhs))) then
          call erro('wrong number of rhs arguments')
       endif
       if(.not.((lhs.ge.minlhs).and.(lhs.le.maxlhs))) then
          call erro('wrong number of lhs arguments')
       endif

c*****************************************************
c      1-Get rhs parameters
c*****************************************************
c*****************************************************
c      2-If necessary, create additional variables 
c          (working arrays, default values, ...)
c*****************************************************
       k=maxrhs+1
       if(.not.createvar(k,'c',10,1,l1)) return
c******************************************************
c      3-Routine call
c      cstk <-> character
       call fcalc2(cstk(l1:l1+9))
c******************************************************
c      4-Display error message(s)
c******************************************************
       if(err .gt. 0) then 
        call erro('Error in ...')
       endif
c
c******************************************************
c      5- Set lhs parameters
c******************************************************
       lhsvar(1)=1
c******************************************************
c      6-Sending lhs variables to Scilab
c******************************************************
       if(.not.putlhsvar()) return
c
       end


       subroutine fcalcentry
       include '../../routines/stack.h'
       rhs = max(0,rhs)
c
c      To each fin corresponds one interface and one scilab function
c
       goto (1,2) fin
       return
 1     call fcalcint('calc')
       return
 2     call fcalc2int('calc2')
       end




