C/MEMBR ADD NAME=ROOTGP,SSI=0
      subroutine rootgp(ngp,gpp,nbeta,beta,ierr,w)
c
c
c     Entree : - gpp. est le tableau contenant les coeff du polynome
c              gpp(z) et dont le degre est ngp.
c              - ngp. est le degre de gp(z).
c
c     Sortie : - beta. est le tableau contenant les racines du
c              polynome gpp(z) reelles comprises entre -2 et 2.
c              - nbeta. est le nombre de ces racines.
c
c!
      implicit double precision (a-h,o-z)
      dimension gpp(0:*),beta(0:*),pol(100),zeror(100),zeroi(100)
      logical fail
      integer ierr
      common /arl2c/ info,i1
c
      do 101 j=0,ngp
         pol(ngp+1-j)=gpp(j)
 101  continue
      call rpoly(pol,ngp,zeror,zeroi,fail)
      nbeta=0
      do 110 j=1,ngp
         if (zeroi(j).eq.0.0d+0.and.abs(zeror(j)).le.2.0d+0) then
         nbeta=nbeta+1
         beta(nbeta)=zeror(j)
         endif
 110  continue
      if (nbeta.eq.0) then
         if(info.ge.2) then
         print*,' PB... On ne trouve \pas de valeur de Beta possible'
         print*,' ARRET DE L EXECUTION IMMEDIAT ...'
         endif
         ierr=4
         return
      endif
      return
      end
