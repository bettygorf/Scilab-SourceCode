      subroutine stsync(isok1)
c     ===============================================================
c       positionne la valeur du drapeau de synchronisation
c     ===============================================================
c
c common pour la synchronisation
      integer isok,ntfy,enabled(100)
      integer isok1
      common /syncro/ isok,ntfy,enabled
c
      isok=isok1
      return
      end
      subroutine gtsync(isok1)
c     ===============================================================
c       retourne la valeur du drapeau de synchronisation
c     ===============================================================
c
c common pour la synchronisation
      integer isok,ntfy,enabled(100)
      common /syncro/ isok,ntfy,enabled
c
      isok1=isok
      return
      end

      subroutine stntfy(ntfy1)
c common pour la synchronisation
      integer isok,ntfy,enabled(100)
      integer ntfy1
      common /syncro/ isok,ntfy,enabled
      ntfy=ntfy1
      if(ntfy1.eq.1) isok=0
      return
      end
      subroutine gtntfy(ntfy1)
c common pour la synchronisation
      integer isok,ntfy,enabled(100)
      integer ntfy1
      common /syncro/ isok,ntfy,enabled
      ntfy1=ntfy
      return
      end

      subroutine setem(n)
c     ===============================================================
c       positionne la valeur du mode d'echo des comandes 
c     k=0  : no echo, no prompt, no	stop.
c     k=-1 : nothing is printed.
c     k=1  : an echo is received after each	command	line.
c     k=2  : prompt	--> is printed.
c     k=3  : there are echoes, prompts, but	no stops.
c     k=4  : stops before each prompt and waits for	a new command line
c     k=7  : there are stops, prompts and echoes.

c     ===============================================================

      include '../stack.h'
      lct(4)=n
      return
      end
      subroutine getem(n)
c     ===============================================================
c       retourne la valeur du mode d'echo des comandes
c     ===============================================================

      include '../stack.h'
      n=lct(4)
      return
      end
      subroutine easync(n)
c     ===============================================================
c     active la gestion des evenements asynchrones sur la fenetre n
c     ===============================================================
      integer n
      integer isok,ntfy,enabled(100)
      common /syncro/ isok,ntfy,enabled
      if(n.gt.0.and.n.lt.100) enabled(n)=1
      end
      subroutine dasync(n)
c     ===============================================================
c     desactive la gestion des evenements asynchrones sur la fenetre n
c     ===============================================================
      integer n
      integer isok,ntfy,enabled(100)
      common /syncro/ isok,ntfy,enabled
      if(n.gt.0.and.n.lt.100) enabled(n)=0
      end
      subroutine gasync(n,mode)
c     ===============================================================
c     retourne le mode (actif/inactif) de  gestion des evenements 
c     asynchrones sur la fenetre n
c     ===============================================================
      integer n,mode
      integer isok,ntfy,enabled(100)
      common /syncro/ isok,ntfy,enabled
      if(n.gt.0.and.n.lt.100) mode=enabled(n)
      mode=1
      end
