      subroutine hessl2(nq,tq,hessl,hessd)
c!but
c     Elle etablit la valeur de la Hessl2ne, derivee
c       seconde de la fonction phi au point q .
c!liste d'appel
c     subroutine hessl2(nq,tq,hessl,hessd)
c     Entree :
c     - nq. est le degre du polynome tq (ou q).
c     - tq. est le tableau des coefficients du polynome.
c
c     Sortie :
c     - hessl est un vecteur colonne qui contient les elements
c        de la partie triangulaire inferieure de la matrice,
c        ranges ligne par ligne.
c     - hessd contient les elements diagonaux de la matrice.
c        (On rappelle que la matrice est symetrique).
c!
      parameter (npara=20,ncoeff=601)
      implicit double precision (a-h,o-y)
      dimension tq(0:*),hessl(*),hessd(*)
c
      dimension tlq(0:npara),tvq(0:ncoeff),
     &     tp(0:npara+ncoeff),tv(0:npara+ncoeff),tw(0:npara+ncoeff),
     &     tij(0:ncoeff),d1aux(0:ncoeff,0:npara),
     $     d2aux(0:npara,0:npara,0:ncoeff)
      integer maxnv(0:npara),maxnw(0:npara,0:npara)
      common/foncg/tg(0:ncoeff)/degreg/ng
c
c     --- Calcul des derivees premieres de 'vq' ---
c
      do 199 i=0,nq-1
c
         if (i.eq.0) then
c
            do 109 j=0,nq-1
               tp(j)=0.0d+0
 109        continue
            do 110 j=0,ng
               tp(j+nq)=tg(j)
 110        continue
c
            np=ng+nq
            call dpodiv(tp,tq,np,nq)
c
            nv1=ng
c
            call lq(nq,tq,tlq,tvq)
c
            do 140 j=0,ng
               tv(j)=tvq(j)
 140        continue
            do 141 j=ng+1,ng+nq
               tv(j)=0.0d+0
 141        continue
c
c     call divpol(ng,tv,nq,tq)
            call dpodiv(tv,tq,ng,nq)
c
            nv2=ng-nq
c
         else
c
            ichoi1=1
            call dzdivq(ichoi1,nv1,tp,nq,tq)
            ichoi2=2
            call mzdivq(ichoi2,nv2,tv,nq,tq)
c
         endif
c
         if (nv1.gt.nv2) then
            maxnv(i)=nv1
         else
            maxnv(i)=nv2
         endif
c
         do 170 j=0,maxnv(i)
            d1aux(j,i)= tp(nq+j)-tv(nq+j)
 170     continue
c
 199  continue
c
c     --- Calcul des derivees secondes de 'vq' ---
c
      do 299 i=0,nq-1
c
         do 210 k=0,ng+nq
            tw(k)=0.0d+0
 210     continue
c
         do 298 j=nq-1,0,-1
c
            if (j.eq.(nq-1)) then
c
               do 220 k=0,maxnv(i)
                  tw(k+nq-1)=d1aux(k,i)
 220           continue
               nw=maxnv(i)+nq-1
c
c     call divpol(nw,tw,nq,tq)
               call dpodiv(tw,tq,nw,nq)
c
               nw=nw-nq
c
            else
c
               ichoix=1
               call dzdivq(ichoix,nw,tw,nq,tq)
c
            endif
c
            do 260 k=0,nw
               d2aux(i,j,k)=tw(nq+k)
 260        continue
            maxnw(i,j)=nw
c
 298     continue
 299  continue
c
c     --- Conclusion des calculs sur la hessienne ---
c
      do 399 i=0,nq-1
c
         do 398 j=0,i
c
            call scapol(maxnv(i),d1aux(0,i),maxnv(j),
     &           d1aux(0,j),y1)
c
            if (maxnw(i,j).gt.maxnw(j,i)) then
               maxij=maxnw(i,j)
               minij=maxnw(j,i)
               do 310 k=minij+1,maxij
                  tij(k)= -d2aux(i,j,k)
 310           continue
            else if (maxnw(i,j).lt.maxnw(j,i)) then
               maxij=maxnw(j,i)
               minij=maxnw(i,j)
               do 311 k=minij+1,maxij
                  tij(k)= -d2aux(j,i,k)
 311           continue
            else
               maxij=maxnw(i,j)
               minij=maxij
            endif
c
            do 330 k=0,minij
               tij(k)= -d2aux(i,j,k) -d2aux(j,i,k)
 330        continue
c
            call scapol(maxij,tij,ng,tvq,y2)
c
            if (i.eq.j) then
               hessd(i+1)= 2.0d+0 * (y1+y2)
            else
               kh= i*(i-1)/2 + (j+1)
               hessl(kh)= 2.0d+0 * (y1+y2)
            endif
c
 398     continue
 399  continue
c
      return
      end
