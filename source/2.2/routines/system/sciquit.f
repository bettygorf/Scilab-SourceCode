      subroutine sciquit
c!Purpose
c     execute scilab.quit file, quit parser remove temporary files, 
c     clean ieeeflags,deallocate memory
c!Syntax
c     call sciquit
c!
      integer nos1,vsiz1,quitf
      common /comnos/ nos1,vsiz1
      if(nos1.eq.0) then
         call scirun('exec(''SCI/scilab.quit'',-1);quit')
      endif
c     cleaning ieeefalgs and quit 
      quitf=0
      call clearexit(quit)
      return
      end
