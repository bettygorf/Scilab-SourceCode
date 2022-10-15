C/MEMBR ADD NAME=FRONT,SSI=0
      subroutine front(neq,q,nbout,w)
c!but
c     cette routine calcule le nombre de racines  du polynome q(z) qui
c     sont situees a l'exterieur du cercle unite .
c!liste d'appel
c     subroutine front(neq,q,nbout,w)
c     dimension q(0:*),w(*)
c     Entree :
c     - neq . est le degre du polynome q(z)
c     - q   . le tableau du polynome en question
c
c     Sortie :
c     -nbout . est le nombre de racine a l'exterieur du  du cercle unite
c     tableau de travail
c     -w 3*neq+1
c!
      implicit double precision (a-h,o-z)
      dimension q(0:*),w(*)
c
      logical fail
      common/comall/nall
c
      lpol=1
      lzr=lpol+neq+1
      lzi=lzr+neq
      lzmod=lpol
      lfree=lzi+neq
C
      call dcopy(neq+1,q,1,w(lpol),-1)
      call rpoly(w(lpol),neq,w(lzr),w(lzi),fail)
      call modul(neq,w(lzr),w(lzi),w(lzmod))
c
      nbout=0
      nbon=0
      do 110 i=1,neq
         if (w(lzmod-1+i).gt.1.0d+0) then
            nbout=nbout+1
         endif
         if (w(lzmod-1+i).eq.1.0d+0) then
            nbon=nbon+1
         endif
 110  continue
c
      return
      end
