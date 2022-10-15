C/MEMBR ADD NAME=WATFAC,SSI=0
      subroutine watfac(neq,q,nface,newrap,w)
c!but
c     Cette procedure est charge de determiner quelle est
c     la face franchie par la trajectoire du gradient.
c!liste d'appel
c     subroutine watfac(neq,q,nface,newrap,w)
c     dimension q(0:neq),w(3*neq+1)
c
c     Entrees :
c     - neq. est toujours le degre du polynome q(z)
c     - q. est le tableau des coefficients de ce polynome.
c
c     Sortie  :
c     - nface contient l indice de la face que le chemin
c       de la recherche a traverse.
c       Les valeurs possibles de nface sont: 0 pour la face
c       complexe, 1 pour la face 'z+1' et -1 pour la face  'z-1'.
c     - newrap est un parametre indiquant s'il est necessaire
c       ou pas d'effectuer un nouveau un rapprochement.
c
c     Tableaux de travail
c     - w : 3*neq+1
c!
      implicit double precision (a-h,o-z)
      dimension q(0:*),w(*)
      logical fail
c
      lpol=1
      lzr=lpol+neq+1
      lzi=lzr+neq
      lzmod=lpol
      lfree=lzi+neq
c
      call dcopy(neq+1,q,1,w(lpol),-1)
      call rpoly(w(lpol),neq,w(lzr),w(lzi),fail)
      call modul(neq,w(lzr),w(lzi),w(lzmod))
c
      nmod1=0
      do 110 j=1,neq
         if (w(lzmod-1+j).ge.1.0d+0) then
            nmod1=nmod1+1
            if(nmod1.eq.1) indi=j
         endif
 110  continue
c
      if (nmod1.eq.2) then
         if(w(lzi-1+indi).eq.0.0d+0) then
            newrap=1
            return
         else
            nface=0
         endif
      endif
c
      if (nmod1.eq.1) then
         if (w(lzr-1+indi).gt.0.0d+0) then
            nface=-1
         else
            nface=1
         endif
      endif
c
      newrap=0
c
      return
      end
