      subroutine interface1(fname)
c***************************************************************************
c     Template of Scilab Fortran interface
c   usage:
c
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
c     global nbvars must be initialized to 0.
c
       nbvars=0
c*****************************************************
c      0-Check number of rhs and lhs arguments
c*****************************************************       
       minrhs=?
       maxrhs=?
       minlhs=?
       maxlhs=?
c

       if(.not.((rhs.ge.minrhs).and.(rhs.le.maxrhs))) then
          call erro('wrong number of rhs arguments')
       endif
       if(.not.((lhs.ge.minlhs).and.(lhs.le.maxlhs))) then
          call erro('wrong number of lhs arguments')
       endif

c*******************************************************
c      1-Get rhs parameters and set their Fortran types
c*******************************************************
       if(.not.getrhsvar(1,'?',m1,n1,l1)) return
       if(.not.getrhsvar(2,'?',m2,n2,l2)) return
       if(.not.getrhsvar(3,'?',m3,n3,l3)) return
       .
       .
       .
       if(.not.getrhsvar(maxrhs,'?',m_maxrhs,n_maxrhs,l_maxrhs)) return

c*****************************************************
c      2-If necessary, create additional variables 
c          (working arrays, default values, ...)
c*****************************************************

       k=maxrhs+1
       if(.not.createvar(k,'?',?,?,l_k)) return
       if(.not.createvar(k+1,'?',?,?,l_(k+1))) return
       .
       .
       .
c******************************************************
c      3-Routine call
c      stk  <-> double
c      sstk <-> real
c      istk <-> integer
c      cstk <-> character

       call fortroutine1(...,stk(l?),..., cstk(l?:l?+?),...,istk(l?),....
     $      ...,sstk(l?),...,ierr)

c******************************************************
c      4-Display error message(s)
c******************************************************
       if(ierr .gt. 0) then 
        call erro('Error in ...')
       endif
c
c******************************************************
c      5- Set lhs parameters
c******************************************************
       lhsvar(1)=?
       lhsvar(2)=?
       lhsvar(3)=?
       .
       .
       lhsvar(maxlhs)=?
c******************************************************
c      6-Sending lhs variables to Scilab
c******************************************************
       if(.not.putlhsvar()) return
c
       end



subroutine interface2(fname)
.
.
.


c  interface function 
c *********************
c
       subroutine entrypointroutine
       include 'SCIDIR/routines/stack.h'
       rhs = max(0,rhs)
c
c      To each fin corresponds one interface and one scilab function
c
       goto (1,2,...) fin
       return
 1     call interface1('scilabfunctionname1')
       return
 2     call interface2('scilabfunctionname2')
       return
       .
       .
       end




