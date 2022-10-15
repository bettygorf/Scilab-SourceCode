      subroutine warn(n,ierr)
      include '../stack.h'
c     
      call  basout(io,wte,'WARNING:')
c     
c     le warning de numero n correspond a l'etiquette logique 100+n
c     
      goto(101,102,103,104,105,106,107,108,109,110,
     &     111,112,113,114,115,116,117,118,119,120),n
 101  continue
      call basout(io,wte,'  Non convergence in the QZ algorithm.')
      if(ierr.gt.0)then 
         write(buf(1:4),'(i4)') ierr
         call basout(io,wte,'  The top'//buf(1:4)//' x'//buf(1:4)//
     +        ' blocks may not be in generalized Schur form.')
      endif
      goto 9999
 102  continue
      call basout(io,wte,'  Non convergence in QR steps.')
      if(ierr.gt.0)then 
         write(buf(1:4),'(i4)') ierr
         call basout(io,wte,'  The top'//buf(1:4)//' x'//buf(1:4)//
     +        ' block may not be in Schur form.')
      endif
      goto 9999
 103  continue
      call basout(io,wte,'  Non convergence in QR steps.')
      if(ierr.gt.0)then 
         write(buf(1:4),'(i4)') ierr
         call basout(io,wte,'  The first '//buf(1:4)//
     +        ' singular values may be incorrect.')
      endif
      goto 9999 
 104  continue
      call basout(io,wte,'  Non convergence in ODE.')
      goto 9999
 105  continue
      call basout('Not enought memory, no simplification performed')
      goto 9999
 106  continue
      goto 9999
 107  continue
      goto 9999
 108  continue
      goto 9999
 109  continue
      goto 9999
 110  continue
      goto 9999
 111  continue
      goto 9999
 112  continue
      goto 9999
 113  continue
      goto 9999 
 114  continue
      goto 9999
 115  continue
      goto 9999
 116  continue
      goto 9999
 117  continue
      goto 9999
 118  continue
      goto 9999
 119  continue
      goto 9999
 120  continue
      goto 9999
      
c     
 9999 continue
      call basout(io,wte,' ')
      return
      end
