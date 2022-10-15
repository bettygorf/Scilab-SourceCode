C/MEMBR ADD NAME=JACL2R,SSI=0
      subroutine jacl2r(neq,t,q,ml,mu,pd,nrowpd)
c!but
c     De meme que la precedente, cette procedure n'est utilisee que
c     dans le cadre de la recherche des maximums de degre 1. Elle
c     correspond au calcul du hessien et est identique, au signe pres,
c     a la procedure Fjacob.
c!
      implicit double precision (a-h,o-y)
      dimension q(0:*),pd(nrowpd,*),
     &          hessd(20),hessl(90)
c
      call hessl2(neq,q,hessl,hessd)
c
      do 110 i=0,neq-1
         pd(i+1,i+1)= hessd(i+1)
 110  continue
c
      do 120 i=1,neq-1
      do 119 j=0,i-1
         pd(i+1,j+1)= hessl( i*(i-1)/2 + j+1 )
         pd(j+1,i+1)=pd(i+1,j+1)
 119  continue
 120  continue
c
      return
      end
