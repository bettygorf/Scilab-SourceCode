      subroutine getnum
c----------------------------------------------
c create a scalar variable
c x=stk(lstk(isiz)) ==> stored in data base 
c----------------------------------------------
      include '../stack.h'
      double precision x
      integer bl(nsiz),ix(2),lr,lc
      logical cremat,compil
      equivalence (x,ix(1))
      data bl/673720360,673720360/
      if (err1.gt.0) return
      x=stk(lstk(isiz))
      if (compil(2,6,ix(1),ix(2))) return
c     compilation getnum :<6 num>
      if(top.eq.0) lstk(1)=1
      if (top+2 .ge. bot) then
         call error(18)
         return
      endif
      top = top+1
      call putid(idstk(1,top),bl)
      if (.not.cremat(fname,top,0,1,1,lr,lc)) return  
      stk(lr)=x 
      return
      end
