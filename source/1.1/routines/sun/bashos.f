      subroutine bashos( ligne, n, nout, ierr)
c
c ================================== ( Inria    ) =============
c
      integer    ierr,n,nout
      character  ligne*(*)
c
      character*256 cmd
c
      nout=0
      ierr=0

      ln = len ( ligne )
      ln = min ( ln , n )

      if (ln.le.0) goto 100
      if(ligne(1:ln).eq.' ') goto 100
      cmd = ligne(1:ln)//char(0)
      call systemc( cmd(1:ln) )
  100 continue
      end
