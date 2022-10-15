      subroutine mrknmd()
      INCLUDE '../stack.h'
      logical compil,c
c      integer iadr,sadr

      if(lhs.le.0) return
      if(comp(1).eq.0) then
         infstk(top)=1
         call putid(idstk(1,top),ids(1,pt))
         pt=pt-1
      else
         c=compil(18,ids(1,pt),0,0,0)
         pt=pt-1
      endif
      return
      end
