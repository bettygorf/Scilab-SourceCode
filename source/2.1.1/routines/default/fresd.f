      subroutine fresd(X,Y,Ydot,res,IRES,RPAR,IPAR)
c!
c interface de calcul d'un second membre pour la commande  dassl
c la subroutine  evalue res=g(t,y,ydot).
c n est la taile du systeme
c!
      INCLUDE '../stack.h'
c
      integer ires,ipar(*)
      double precision x,y(*),ydot(*),res(*),rpar(*)
c
      integer it1
c
      character*6    namer,namej,nam1
      common /dassln/ namer,namej

      call majmin(6,namer,nam1)
c
c pour interfacer d'autres simulateurs modifier les lignes entre c+
c qui suivent en fonction du nom de la ou des routines a appeler.
c ce nom est donne dans la variable name.
c+

c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.nam1) goto 1001
cc sun unix
      call dyncall(it1-1,X,Y,Ydot,res,IRES,RPAR,IPAR)
cc fin
      return
c
 2000 ires=-2
      buf=namer
      call error(50)
      return
      end
