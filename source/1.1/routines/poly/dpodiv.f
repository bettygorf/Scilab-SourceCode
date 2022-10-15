C/MEMBR ADD NAME=DPODIV,SSI=0
      subroutine dpodiv(a,b,na,nb  )
      implicit double precision (a-h,o-z)
      dimension a(*),b(*)
c
c     1. a: avant execution c'est le tableau des coefficients du
c    1polynome dividende range suivant les puissances croissantes
c    2de la variable (ordre na+1).
c    3apres execution,contient dans les nb premiers elements
c    4le tableau des coefficients du reste ordonne suivant les
c    5puissances croissantes, et dans les (na-nb+1) derniers elements,
c    6le tableau des coefficients du polynome quotient range suivant
c    7les puissances croissantes de la variable.
c     2. b: tableau des coefficients du polynome diviseur range suivant
c    1les puissances croissantes de la variable (ordre nb+1).
c     3. na: degre du polynome a.
c     4. nb: degre du polynome b.
c
      l=na-nb+1
    2 if(l)5,5,3
    3 n=l+nb
      q=a(n)/b(nb+1)
      nb1=nb+1
      do4 i=1,nb1
      n1=nb-i+2
      n2=n-i+1
   4  a(n2)=a(n2)-b(n1)*q
      a(n)=q
      l=l-1
      goto 2
   5  continue
      return
      end
