C/MEMBR ADD NAME=STORL2,SSI=0
      subroutine storl2(neq,tq,imin,tabc,iback,ntback,tback,nch,
     $     mxsol,ierr)
c!but
c     Lorsque un minimum local vient d'etre determine, cette
c     procedure est appelee afin de verifier son originalite,
c     et si elle est effective, de le stocker dans le tableau
c     en construction, correspondant au degre de la recherche
c     en cours. S'il n'est pas de ce degre, il est alors range
c     dans le tableau 'tback' qui contient tout minimum origi-
c     nal obtenu apres une sortie de face.
c!liste d'appel
c     entrees :
c     - neq. est le degre du minimum nouvellement obtenu.
c     - tq. est le tableau contenant ses coefficients
c     - imin. est le nombre des minimums de meme degre,
c        deja reveles.
c     - tabc. etant le tableau contenant ces minimums.
c     - iback. est le nombre de minimums de degre
c        quelconque, reveles apres une sortie de face.
c     - ntback. est un tableau entier unicolonne contenant
c        les degres de ces polynomes.
c     - tback. est le tableau ou sont stockes ces polynomes.
c        Ainsi, le ieme polynome, de degre ntback(i), a
c        ses coeff dans la ieme ligne, c-a-d de tback(i,0)
c        a tback(i,ntback(i)-1).
c     - nch. est un parametre entier indiquant s'il s'agit
c        d'un minimum de meme degre que celui de la recherche
c        en cours, ou bien d'une sortie de face.
c
c     sorties :
c     - peuvent etre modifies: imin, tabc, iback, ntback,
c        tback, suivant le tableau ou a ete stocke le minimum tq
c!
      implicit double precision (a-h,o-y)
      dimension tq(0:*),tabc(mxsol,0:*),ntback(iback),tback(mxsol,0:*)
c
      common/sortie/nwf,info,ll
c
      ierr=0
      if (nch.lt.-2) goto 200
      if (imin.eq.0) goto 400
c
c     ---- test sur l'originalite du nouveau min -----------------------
c
c     ---- par rapport a tabc.
c
      do 120 im=1,imin
c
         diff0=0.0d+0
         do 110 ij=0,neq-1
            diff0=diff0+(tq(ij)-tabc(im,ij))**2
 110     continue
         diff0=sqrt(diff0)
c
         if (diff0.lt.1.0d-03) then
            if(info.gt.0) call outl2(80,0,0,x,x,x,x)
            return
         endif
c
 120  continue
c
c     ---- par rapport a tback.
c
c     - Situation des polynomes de meme degre. -
c
 200  if (nch.lt.0 .and. iback.gt.0) then
         jsup= iback + 1
         jinf= 0
c
         do 210 j=iback,1,-1
            if (jsup.gt.j .and. ntback(j).gt.neq) jsup=j
 210     continue
         do 220 j=1,iback
            if (jinf.lt.j .and. ntback(j).lt.neq) jinf=j
 220     continue
c
c     - Controle de l'originalite. -
c
         if ((jsup-jinf).gt.1) then
c
            do 240 j=jinf+1,jsup-1
c
               diff0=0.0d+0
               do 230 i=0,neq-1
                  diff0=diff0+(tq(i)-tback(j,i))**2
 230           continue
               diff0= sqrt(diff0)
c
               if (diff0.lt.1.0d-03) then
                  if(info.gt.0) call outl2(80,0,0,x,x,x,x)
                  return
               endif
c
 240        continue
         endif
      endif
c
c     -------- classement du nouveau minimum -----
c     ---- dans tback.
c
 300  if(iback.eq.mxsol) then
         ierr=7
         return
      endif
      if (nch.lt.0) then
c
         if (iback.eq.0) then
c
            do 310 i=0,neq-1
               tback(1,i)=tq(i)
 310        continue
            ntback(1)=neq
c
         else if (jsup.gt.iback) then
c
            do 330 i=0,neq-1
               tback(jsup,i)=tq(i)
 330        continue
            ntback(iback+1)=neq
c
         else
c
            do 350 j=iback,jsup,-1
               do 340 i=0,ntback(j)-1
                  tback(j+1,i)=tback(j,i)
 340           continue
               ntback(j+1)=ntback(j)
 350        continue
c
            do 370 i=0,neq-1
               tback(jsup,i)=tq(i)
 370        continue
            ntback(jsup)=neq
c
         endif
c
         iback= iback + 1
         if(info.gt.1) call outl2(81,neq,neq,x,x,x,x)
         return
c
      endif
c
c     -------- dans tabc.
 400  continue
      if(imin.eq.mxsol) then
         ierr=7
         return
      endif
      paux=phi(tq,neq)
c
      if (imin.eq.0) then
c
         do 410 ij=0,neq-1
            tabc(1,ij)= tq(ij)
 410     continue
         tabc(1,neq)= paux
         imin=imin+1
c
      else
c
         do 490 im=imin,1,-1
c
            if (paux.gt.tabc(im,neq).and.im.eq.imin) then
c
               do 420 ij=0,neq-1
                  tabc(imin+1,ij)=tq(ij)
 420           continue
               tabc(imin+1,neq)=paux
               imin=imin+1
               return
c
            else if (paux.gt.tabc(im,neq)) then
c
               do 440 in=imin,im+1,-1
                  do 430 ij=0,neq
                     tabc(in+1,ij)=tabc(in,ij)
 430              continue
 440           continue
               do 450 ij=0,neq-1
                  tabc(im+1,ij)=tq(ij)
 450           continue
               tabc(im+1,neq)=paux
               imin=imin+1
               return
c
            else if (im.eq.1) then
c
               do 470 in=imin,1,-1
                  do 460 ij=0,neq
                     tabc(in+1,ij)=tabc(in,ij)
 460              continue
 470           continue
               do 480 ij=0,neq-1
                  tabc(1,ij)=tq(ij)
 480           continue
               tabc(1,neq)=paux
               imin=imin+1
c
            endif
c
 490     continue
c
      endif
c
      return
      end
