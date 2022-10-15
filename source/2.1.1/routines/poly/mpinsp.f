C/MEMBR ADD NAME=MPINSP,SSI=0
      subroutine mpinsp(dep1,lig1,col1,v1,d1,v2,d2,dep2,
     & lig2,col2,depr,ligr,colr,ierr)
c!but
c
c     Cette subroutine pretraite l'insertion  d'une
c     matrice de polynomes mat2 dans une autre mat1 d'apres deux
c     vecteurs.Pour calculer le  volume qu'occupera le resultat
c
c!parametres d'appel
c
c     call mpinsp(dep1,lig1,col1,v1,d1,v2,d2,dep2,lig2,col2
c    & ,depr,ligr,colr)
c
c     ou
c
c     dep1: matrice entiere qui donne les deplacements relatifs des
c           elements de mat1
c
c     lig1, col1: entiers, dimensions de mat1
c
c     v1: vecteur entier
c
c     d1: longueur du vecteur v1
c
c     v2, d2: analogues aux anterieurs
c
c     dep2, lig2, col2: analogues aux correspondents 1
c
c     depr: contient les information issues du pretraitement:
c           depr(1) contient le volume des coeff de la matrice resultat
c           depr(1+i) contient un pointeur vers dep1 si positif
c                                          vers dep2 si negatif
c                                          vers 0 si nul
c
c     ligr, colr: entiers dimensions de la matrice de sortie
c                 depr. S'ils ne sont pas connus au prealable
c                 peuvent etre calcules par la subroutine dimin.
c
c     ierr: si 0 terminaison correcte,
c           sinon les dimensions de mat2 ne sont pas compatibles
c
c
c     attention!: aucune de matrices dep1, dep2 ou depr ne
c     doit coincider. Dans le cas contraire, les resultats seraient
c     imprevisibles.
c
c!auteur:
c     carlos klimann, inria, 12-XI-85.
c
c
c!
      integer dep1(*),v1(*),v2(*),dep2(*),depr(*)
      integer lig1,col1,d1,d2,lig2,col2,ligr,colr,ierr
c
      integer volr
c
      ierr=0
      volr=0
      if (d1.eq.0.or.d2.eq.0) return
c
c     cas ou d1 ou d2 sont negatifs
c
      if(d1.gt.0.or.d2.gt.0) goto 10
      if(lig1.ne.lig2.or.col1.ne.col2) goto 50
c
      ir=lig1*col1+1
      do 05 i=1,ir
   05 depr(i+1)=-i
      volr=dep2(ir)-dep2(1)
      goto 999
c
   10 if(d1.lt.0) then
      if(max(1,lig1).ne.lig2) goto 50
c
c   toutes les lignes pour un choix de colonnes
c
      kr=1
      volr=0
      do 16 jr=1,colr
c la colonne jr est elle a modifier ?
      id2=0
      do 11 i=1,d2
   11 if(v2(i).eq.jr) id2=i
      if(id2.eq.0) goto 13
c oui
      k2=lig2*(id2-1)
      do 12 ir=1,ligr
      kr=kr+1
      depr(kr)=-(k2+ir)
   12 continue
      volr=volr+dep2(k2+ligr+1)-dep2(k2+1)
      go to 16
c non
   13 if(jr.le.col1) then
c la colonne designee existe dans mat1
      k1=(jr-1)*lig1
      do 14 ir=1,ligr
      kr=kr+1
   14 depr(kr)=(k1+ir)
      volr=volr+dep1(k1+ligr+1)-dep1(k1+1)
      goto 16
      endif
c     si non, inserer un string vide
      do 15 ir=1,ligr
      kr=kr+1
   15 depr(kr)=0
      volr=volr+ligr
   16 continue
      goto 999
      endif
c
      if(d2.lt.0) then
      if(col1.ne.max(1,col2)) goto 50
c
c toutes les colonnes pour un choix de lignes
c
      do 26 ir=1,ligr
      kr=ir+1-ligr
c la ligne ir est elle a modifier ?
      id1=0
      do 21 i=1,d1
   21 if(v1(i).eq.ir) id1=i
      if(id1.eq.0) goto 23
c oui
      k2=id1-lig2
      do 22 jr=1,colr
      kr=kr+ligr
      k2=k2+lig2
      depr(kr)=-k2
      volr=volr+dep2(k2+1)-dep2(k2)
   22 continue
      go to 26
c non
   23 if(ir.le.lig1) then
c la ligne designee existe dans mat1
      k1=ir-lig1
      do 24 jr=1,colr
      kr=kr+ligr
      k1=k1+lig1
      volr=volr+dep1(k1+1)-dep1(k1)
   24 depr(kr)=k1
      goto 26
      endif
c     si non, inserer des zeros
      do 25 jr=1,colr
      kr=kr+ligr
   25 depr(kr)=0
      volr=volr+colr
   26 continue
      goto 999
      endif
c
c cas general
c
      kr=2
      do 40 jr=1,colr
c la colonne jr est elle a modifier ?
      id2=0
      do 30 i=1,d2
      if(v2(i).eq.jr) id2=i
   30 continue
c
      if(id2.eq.0) goto 35
c
      do 34 ir=1,ligr
c la ligne ir est-elle a modifier
      id1=0
      do 31 i=1,d1
      if(v1(i).eq.ir) id1=i
   31 continue
c
      if(id1.eq.0) goto 32
c
      k2=id1+lig2*(id2-1)
      depr(kr)=-k2
      kr=kr+1
      volr=volr+dep2(k2+1)-dep2(k2)
      go to 34
c
   32 if(ir.gt.lig1.or.jr.gt.col1) goto 33
      k1=ir+lig1*(jr-1)
      depr(kr)=k1
      kr=kr+1
      volr=volr+dep1(k1+1)-dep1(k1)
      goto 34
c
   33 depr(kr)=0
      kr=kr+1
      volr=volr+1
   34 continue
      goto 40
c non
c toutes les lignes de la colonne designee
   35 if(jr.gt.col1) goto 38
      k1=(jr-1)*lig1
      do 36 ir=1,lig1
      depr(kr)=k1+ir
   36 kr=kr+1
      volr=volr+dep1(k1+lig1+1)-dep1(k1+1)
      if(lig1.ge.ligr) goto 40
      do 37 ir=lig1+1,ligr
      depr(kr)=0
   37 kr=kr+1
      volr=volr+ligr-lig1
      goto 40
   38 do 39 ir=1,ligr
      depr(kr)=0
   39 kr=kr+1
      volr=volr+ligr
   40 continue
c
  999 depr(1)=volr
      return
   50 ierr=1
      return
      end
