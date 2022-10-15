      subroutine xchar(line,k)
c     ======================================================================
c     routine systeme dependente  pour caracteres speciaux
c     ======================================================================
c effacement de la ligne : retourner  k>99
c fin de ligne : retourner k=99
c effacement du caractere precedent :retourner k=-1
c ignorer le caractere : retourner k=0
c
c     Copyright INRIA
      include '../stack.h'
c
      integer blank
      integer k
      character line*(*)
      data blank/40/
c
      if(ichar(line(1:1)).eq.0) then
c     prise en compte de la marque de fin de chaine C
c     dans le cas d'un appel de scilab par un programme C
         k=99
      elseif(ichar(line(1:1)).eq.9) then
c     tab remplace par un blanc
         k=blank+1
      elseif(ichar(line(1:1)).eq.10) then
c     \n remplace par un eol
         k=99
      else
         k=0
      endif
c
      end
