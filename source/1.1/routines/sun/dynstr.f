      subroutine dynstr(nlink,namefi,n,namepr,ln,err)
c              appel du linker dynamique
c
c ====================================================================
c
c entree : namefi  nom du fichier
c          namepr  nom du programme a linker
c          nlink   numero du programme ( 0 -> non deja linke )
c          n       nombre de caracteres de namefi
c          ln      nombre de caracteres de namepr
c
c
c sortie : err    code d'erreur
c
c
c reference externe : dynstrc
c ================================== ( Inria    ) =============
c
      integer       err,n,ln,nlink
      character*(*) namefi,namepr
c
c unix
c ----
      call dynstrc(nlink,namefi,n,namepr,ln,err)
      goto 100
c
c autre
c -----
c     err=900
c     goto 100
c
c fin
c ---
  100 continue
      end
