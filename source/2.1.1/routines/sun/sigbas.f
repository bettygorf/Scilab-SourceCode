      subroutine sigbas(n)
c ====================================================================
c
c recuperation du break ou de l'erreur fortran
c
c ====================================================================
c
c traitement de l'erreur fortran ou du break
c
      integer  n
      include '../stack.h'
      integer adr
      logical         iflag
      common /basbrk/ iflag
      integer  ilk,k,l,lunit,nc
      if(ddt.eq.4) then
         write(buf(1:5),'(i5)') n
         call basout(io,wte,'signal :'//buf(1:5))
      endif
      if ( n.eq.2 ) then
         iflag=.true.
      elseif (n.eq.11 ) then
         call error(68)
         goto 10
      elseif (n.eq.8 ) then
      call msgstxt('Floating point exception !')
      else
         iflag=.false.
      endif
      goto 99
c
c erreur fatale : sauvegarde de la pile avant le stop
c -------------
c
   10 continue
c
c ouverture du fichier
c
      err  =0
      lunit=0
      call inffic( 5, buf, nc)
      nc = max ( 1 , nc )
      call inffic( 5, buf, nc)
      call clunit( lunit, buf(1:nc), 103)
      if ( err.gt.0 ) call error(err)
      if ( err.gt.0 ) goto 90
c
      call error(68)
      err=0
c
c sauvegarde
c
   30 k = isiz-6
      if (k .lt. bot) k = isiz
   32 continue
      l=k
      ilk=adr(lstk(k),0)
      if(istk(ilk).lt.0) l=istk(ilk+1)
      call savlod(lunit,idstk(1,k),0,l)
      k = k-1
      if(k.ge.bot) goto 32
c
      call clunit( -lunit, buf, 103)
 90   stop
c
c fin
c ---
c
 99   continue
      end

