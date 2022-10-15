      double precision function ffeval(nn,x1,x2,xres,itype,name) 
c!
c subroutine d interface avec la commande scilab feval. Dans le cas
c de sous programmes lies dynamiquement (link) la liste d'appel doit
c etre subroutine XXXXXX(n,x1,x2,xres)
c!
      include '../stack.h'

c      implicit undefined (a-z)
      double precision x1,x2 
      double precision xres(2)
c
      integer it1,itype,nn
c
      character*6     name,nam1
      integer         iero
      common /ierfeval/ iero
c
      ffeval=0.0d0
      iero=0
      call majmin(6,name,nam1)
c
c pour interfacer d'autres simulateurs modifier les lignes entre c+
c qui suivent   en fonction du nom de la ou des routines a appeler.
c la chaine de caracteres name contient le nom du sous programme a
c appeler.
c     nn=1 ou 2 suivant le nombre d'arguments attendus par f 
c     x1 et x2 sont les deux arguments a  transmettre
C     valeur renvoyee xres(2) et itype
C     itype vaut 1 si le resultat est complexe et itype =0 s'il est reel
c     xres(1) = partie reele du resultat xres(2) partie imaginaire
c+
      if(nam1.eq.'parab') then
         if (nn.eq.1) then 
            xres(1)=x1**2
            itype=0
         else
            xres(1)=x1**2+x2**2
            itype=0
         endif
       return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,nn,x1,x2,xres)
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
