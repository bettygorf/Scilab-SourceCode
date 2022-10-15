      subroutine basmsg(init)
      integer init
      include '../stack.h'
      integer io
      if(wte.le.0) then 
         init=abs(wte)
         call basout(io,init,' **********')
         call basout(io,init,' incorrect acces to scilab')
         call basout(io,init,' **********')
         init=-1
      endif
      return
      end
      
