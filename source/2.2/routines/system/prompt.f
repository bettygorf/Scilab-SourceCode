      subroutine prompt(pause)
c
c ====================================================================
c scilab . librairie system
c ====================================================================
c
c     issue prompt with optional pause
c
c ====================================================================
c
c ================================== ( Inria    ) =============
c
c
      include '../stack.h'
      integer pause
      character ch*3
c
c     Version standard
c     -----------------
      call basout(io,wte,' ')
      if(paus.eq.0) then
         call basou1(wte,'-->')
      else
         write(ch,'(i2)') paus
         i1=1
         if(ch(1:1).eq.' ') i1=2
         call basou1(wte,'-'//ch(i1:2)//'->')
      endif
c
C     Symbolics Version
C     ----------------
c      lispfunction nprompt 'cl-user::nprompt'  (integer)
c
c      if(paus.ne.0) then
c         call nprompt(0)
c         if (wio .ne. 0) call nprompt(0)
c      else
c         call nprompt(paus)
c         if(wio.ne.0) call nprompt(paus)
c      endif
c
c fin
c----
      if (pause .eq. 1) call basin(ierr,rte,buf,'*')
      return
      end
