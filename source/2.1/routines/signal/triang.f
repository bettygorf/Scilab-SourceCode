C/MEMBR ADD NAME=TRIANG,SSI=0
      subroutine triang(demi,ieo,win)
c!
c sous-programme:  triang
c fenetre triangulaire
c en double precision
c acheve le 05/12/85
c ecrit par philippe touron
c
c
c                   parametres entrants
c                  -------------------
c  demi, l'ordre de la demi-fenetre (entier)
c  ieo , indicateur de parite (entier=a 0 si ordre pair et 1 sinon)
c
c                   parametres sortants
c                  -------------------
c  win, les valeurs de la demi-fenetre (tableau de reels qui doit
c        dans un programme appelant etre dimensionner a ordr)
c
c                   variables internes
c                  ------------------
c xcompt,compt: compteur de boucle et indice de tableau en reel
c         (resp. en entier)
c
c sous programmes appeles: aucun
c
c!
      double precision win(*),xcompt
      integer compt,demi,ieo
c
      do 10 compt=1,demi
      xcompt=dble(compt)-1.0d+0
      if(ieo.eq.0)xcompt=xcompt+0.50d+0
      win(compt)=1.0d+0-xcompt/dble(demi)
10    continue
      return
      end
