      subroutine intex8(fname)
      character*(*) fname
C     --------------------------------------------
c     Copyright INRIA
      include '../../routines/stack.h'
      logical getrhsvar,putlhsvar,createvar,scifunction
      logical checklhs,checkrhs
      common/  ierfeval / iero

      nbvars=0 
      if(.not.checkrhs(fname,3,3)) return
      if(.not.checklhs(fname,1,3)) return
c
c     Scilab:-->geval(x1,x2,a_function)
c     x1<->1
c     x2<->2
c     a_function<->3
      if (.not.getrhsvar(1,'d',m1,n1,l1))  return
      if (.not.getrhsvar(2,'d',m2,n2,l2))  return
c     lf is the adress of a_function 
      if (.not.getrhsvar(3,'f',mlhs,mrhs,lf))  return

      if(mrhs.ne.2) then
         buf='invalid rhs for Scilab function'
         call error(998)
         return
      endif
c
c     just creating mrhs=2 input variables at positions 4 and 5
c     for scilab function lf (a_function=myfunction).

      if(.not.createvar(3+1,'d',m1,n1,l4)) return
      call dcopy(m1*n1,stk(l1),1,stk(l4),1)
c      ....
      if(.not.createvar(3+mrhs,'d',m2,n2,l5)) return
      call dcopy(m2*n2,stk(l2),1,stk(l5),1)
c
c     input variable 4 and 5 transformed to output variables
c     of function lf: since this function has number 3
c     in getrhsvar,
c     its inputs must be at positions 3+1=4,...,3+mrhs=5
c     variables will be created if mlhs>mrhs.

      if(.not.scifunction(3+1,lf,mlhs,mrhs)) return
c     output variables: 4 and 5 (created by a_function) and possibly 6
c                       if a_function has 3 output parameters
      lhsvar(1)=4
      lhsvar(2)=5
      if(mlhs.eq.3) lhsvar(3)=6
      if(.not.putlhsvar()) return
      return
      end
       
      subroutine entrypt
      include '../../routines/stack.h'
       rhs = max(0,rhs)
c
c      To each fin corresponds one interface and one scilab function
c
       goto (1) fin
       return
 1     call intex8('geval')
       end


