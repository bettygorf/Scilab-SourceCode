      subroutine scilab(nos)
      character*100  bu1
      integer  nc,nos,ierr
      common /comnos/ nos1,mem
c     ----------
c     initialize 
c     ----------
      call inisci(-1,mem, ierr)
      if(ierr.gt.0) return
c     ----------------------------------------
c     get startup instruction and start parser
c     ----------------------------------------
      if(nos1.eq.0) then
c     .  get initial instruction  if required
         bu1=' '
         call inffic( 2, bu1,nc)
         nc=max ( 1 , nc )
      else
         bu1=' '
         nc=1
      endif
      call scirun(bu1(1:nc))
c     --------
c     cleaning 
c     --------
      call sciquit
      return
      end
