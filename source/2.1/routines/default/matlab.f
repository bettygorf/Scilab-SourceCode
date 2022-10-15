      subroutine matlab( ini1, bu1 )
c
c ====================================================================
c
c                          S C I L A B
c
c ====================================================================
c
c
c ini1 =  0  for ordinary first entry
c         positive for subsequent entries
c      = -1  for silent initialization
c      = -2  for ordinary entry and startup
c      = -3  for initialization with use of X11 io
c
c
c bu1   Chaine de caracteres contenant les instructions scilab a execu-
c       tees. (ini1=-2) En particulier, l'execution de la STARTUP est
c       obtenue par :
c
c          CALL INFFIC( 1, BU1, NC)
c          CALL MATLAB(-2, BU1(1:NC))
c
c
c ====================================================================
c
c
      character*(*) bu1
      integer       ini1
c*------------------------------------------------------------------
c*------------------------------------------------------------------
      include '../stack.h'
c*------------------------------------------------------------------

c common unite logique
      integer         nunit,unit(20)
      common /units / nunit,unit
c*------------------------------------------------------------------
c
      integer  ierr,init,vsizr
c
c --------------
c initialisation
c --------------
c
      ierr  =  0
      init  = ini1
      nunit = 20
      vsizr = vsiz
      call inibas( init, bu1, vsizr, ierr)
      if(ierr.gt.0) goto 888
c
c ------------------------
c appel effectif de scilab
c ------------------------
c
      call matla0( init, bu1)
c
c ---
c fin
c ---
c
 888  continue
      end

