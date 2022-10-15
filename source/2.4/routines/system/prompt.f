      subroutine prompt(pause)
c ====================================================================
c     issue prompt with optional pause
c ================================== ( Inria    ) =============
c     Copyright INRIA
      include '../stack.h'
      integer pause
      call basout(io,wte,' ')
      call setprlev(paus)
C     version with pause ( mode(7) )
      if (pause .eq. 1) then 
         call basin(ierr,rte,buf,'*')
      endif
      return
      end
