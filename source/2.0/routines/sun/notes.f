      subroutine stsync(n)
c     ===============================================================
c       positionne la valeur du drapeau de synchronisation
c     ===============================================================
c
c common pour la synchronisation
      integer isok
      common /syncro/ isok
c
      isok=0
      if(n.ne.0) isok=1
      return
      end
      subroutine gtsync(n)
c     ===============================================================
c       retourne la valeur du drapeau de synchronisation
c     ===============================================================
c
c common pour la synchronisation
      integer isok
      common /syncro/ isok
c
      n=isok
      return
      end
