C/MEMBR ADD NAME=FADDA,SSI=0
      subroutine fadda(ny,t,y,ml,mu,p,nrowp)
c!
c interface pour les systemes implicites.
c
c le common /cadd/ contient le nom du programme a appeler tel qu il
c est donne dans la commande scilab impl.
c la routine appelee doit faire p=p+a, ou a=a(t,y) matrice ny par ny
c telle que a(t,y)*ydot=g(t,y)
c!
c parametres d'entree t,y,p
c parametres de sortie p
c nrowp=leading dimension de p
c!
      include '../stack.h'

      integer ml,mu,nrowp,ny
      double precision p(nrowp,*),t,y(*)
c
      integer it1
c
      character*6   name,nam1
      common /cadd/ name
      integer         iero
      common /ierode/ iero
c
      iero=0
      call majmin(6,name,nam1)
c
c pour interfacer d'autres simulateurs modifier les lignes entre c+
c qui suivent en fonction du nom de la ou des routines a appeler.
c+
      if(nam1.eq.'aplusp') then
        call aplusp(ny,t,y,ml,mu,p,nrowp)
        return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.name) goto 1001
cc sun unix
      call dyncall(it1-1,ny,t,y,ml,mu,p,nrowp)
cc fin
      return
c
 2000 iero=1
      buf=name
      call error(50)
      return
      end
