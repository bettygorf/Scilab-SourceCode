      subroutine jacl2(neq,t,q,ml,mu,pd,nrowpd)
c!but
c     jacl2 cree la matrice  jacobienne necessaire a Lsoda,
c     qui correspond en fait a la hessienne du probleme
c     d'approximation L2.
c!liste d'appel
c     entree :
c     - neq. est le degre du polynome q.
c     - t est une variable parametrique necessaire a Lsoda.
c     - q. contient les coefficients du polynome
c     - ml et mu sont les parametres du stockage par bande
c        de la matrice qui n a pas lieu ici ,ils donc ignores.
c
c     sortie :
c     - pd. est le tableau ou l on range la matrice pleine
c       dont les elements sont etablis par la sub. Hessien,
c       il est lu par Lsoda colonne par colonne et est charge
c       en une seule colonne.
c     - nrowpd. est le nombre de ligne du tableau pd, ne
c       sert qu a Lsoda.
c!
      implicit double precision (a-h,o-y)
      dimension q(0:*),pd(nrowpd,*), hessd(20),hessl(90)
c
      call hessl2(neq,q,hessl,hessd)
c
      do 110 i=0,neq-1
         pd(i+1,i+1)=-hessd(i+1)
 110  continue
c
      do 120 i=1,neq-1
         do 119 j=0,i-1
            pd(i+1,j+1)=-hessl( i*(i-1)/2 + j+1 )
            pd(j+1,i+1)=pd(i+1,j+1)
 119     continue
 120  continue
c
      return
      end
