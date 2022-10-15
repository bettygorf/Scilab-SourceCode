      subroutine inffic( iopt, name, nc)
c
c ====================================================================
c scilab . librairie vax
c ====================================================================
c
c noms des fichiers par defaut et nombre de caracteres de la chaine
c
c ====================================================================
c
c    iopt = 1  ->  help
c    iopt = 2  ->  start_up
c    iopt = 3  ->  parametres graphiques
c    iopt = 4  ->  sauvegarde des commandes tapees
c    iopt = 5  ->  sauvegarde de la pile en cas d'erreur
c    iopt = 6  ->  sortie graphique pour table tracante
c
c
      integer       iopt,nc
      character*(*) name
c
      integer ln,nm
      save nm
      data nm / 26 /
c
      ln = len ( name )
      if ( ln.lt.nm ) goto 99
      name = ' '
c
c cdc nos-ve
c ----------
c     if ( iopt.eq.1 ) then
c        name = 'sci.scilab_help'
c        nc   =  15
c     elseif ( iopt.eq.2 ) then
c        name = 'exec(''sci.scilab_star'',-1)'
c        nc   =  26
c     elseif ( iopt.eq.3 ) then
c        name = 'sci.scilab_dess'
c        nc   =  15
c     elseif ( iopt.eq.4 ) then
c        name = 'scilab_hist'
c        nc   =  11
c     elseif ( iopt.eq.5 ) then
c        name = 'home.scilab_save'
c        nc   =  16
c     elseif ( iopt.eq.6 ) then
c        name = 'home.scilab_graph'
c        nc   =  16
c     else
c        name = ' '
c        nc   = 0
c     endif
c
c ibm vm/cms
c ----------
c     if ( iopt.eq.1 ) then
c        name = 'scilab help'
c        nc   =  11
c     elseif ( iopt.eq.2 ) then
c        name = 'exec(''scilab star'',-1)'
c        nc   =  22
c     elseif ( iopt.eq.3 ) then
c        name = 'scilab dess'
c        nc   =  11
c     elseif ( iopt.eq.4 ) then
c        name = 'scilab hist'
c        nc   =  11
c     elseif ( iopt.eq.5 ) then
c        name = 'scilab save'
c        nc   =  11
c     elseif ( iopt.eq.6 ) then
c        name = 'scilab graph'
c        nc   =  11
c     else
c        name = ' '
c        nc   = 0
c     endif
c
c ibm mvs
c -------
c     if ( iopt.eq.1 ) then
c        name = 'sciihelp'
c        nc   =   8
c     elseif ( iopt.eq.2 ) then
c        name = 'exec(''sciistar'',-1)'
c        nc   =  19
c     elseif ( iopt.eq.3 ) then
c        name = 'sciidess'
c        nc   =   8
c     elseif ( iopt.eq.4 ) then
c        name = 'sciihist'
c        nc   =   8
c     elseif ( iopt.eq.5 ) then
c        name = 'sciisave'
c        nc   =   8
c     elseif ( iopt.eq.6 ) then
c        name = 'sciigraph'
c        nc   =   8
c     else
c        name = ' '
c        nc   = 0
c     endif
c
c vax
c ---
c     if ( iopt.eq.1 ) then
c        name = 'sci]scilab.help'
c        nc   =  15
c     elseif ( iopt.eq.2 ) then
c        name = 'exec(''sci]scilab.star'',-1)'
c        nc   =  26
c     elseif ( iopt.eq.3 ) then
c        name = 'sci]scilab.dess'
c        nc   =  15
c     elseif ( iopt.eq.4 ) then
c        name = 'scilab.hist'
c        nc   =  11
c     elseif ( iopt.eq.5 ) then
c        name = 'home]scilab.save'
c        nc   =  16
c     elseif ( iopt.eq.6 ) then
c        name = 'home]scilab.graph'
c        nc   =  16
c      else
c         name = ' '
c         nc   = 0
c      endif
c
c unix
c ----
      if ( iopt.eq.1 ) then
         name = 'sci/scilab.help'
         nc   =  15
      elseif ( iopt.eq.2 ) then
         name = 'exec(''sci/scilab.star'',-1)'
         nc   =  26
      elseif ( iopt.eq.3 ) then
         name = 'sci/scilab.dess'
         nc   =  15
      elseif ( iopt.eq.4 ) then
         name = 'home/scilab.hist'
         nc   =  16
      elseif ( iopt.eq.5 ) then
         name = 'home/scilab.save'
         nc   =  16
      elseif ( iopt.eq.6 ) then
         name = 'home/scilab.graph'
         nc   =  16
      else
         name = ' '
         nc   = 0
      endif
c
c pc 386
c ------
c     if ( iopt.eq.1 ) then
c        name = 'sci/scilab.hel'
c        nc   =  14
c     elseif ( iopt.eq.2 ) then
c        name = 'exec(''sci/scilab.sta'',-1)'
c        nc   =  25
c     elseif ( iopt.eq.3 ) then
c        name = 'sci/scilab.des'
c        nc   =  14
c     elseif ( iopt.eq.4 ) then
c        name = 'scilab.his'
c        nc   =  10
c     elseif ( iopt.eq.5 ) then
c        name = 'home/scilab.sav'
c        nc   =  14
c     elseif ( iopt.eq.6 ) then
c        name = 'home/scilab.grap'
c        nc   =  15
c     else
c        name = ' '
c        nc   = 0
c     endif
c
      goto 100
c
c erreur
c ------
c
   99 continue
      write(*,*) '%% inffic -->: too long file name'
      write(*,*) '                   iopt = ',iopt
      stop
c
c fin
c ---
c
  100 continue
      end
