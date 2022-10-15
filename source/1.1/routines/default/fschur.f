      integer function fschur(lsize,alpha,beta,s,p)
c!purpose
c      interface pour les external fortran ou C de la fonction  schur
c!
      include '../stack.h'
      integer lsize,folhp,find
      double precision alpha,beta,s,p
c
      character*6   namef,name1
      common/cschur/namef
c
      fschur=0
      call majmin(6,namef,name1)
c
c pour interfacer d'autre fonctions, modifier les lignes qui suivent en
c fonction du nom de la ou des routines a appeler
c+
      if(name1.eq.'c'.or.name1.eq.'cont') then
        fschur=folhp(lsize,alpha,beta,s,p)
        return
      endif
      if(name1.eq.'d'.or.name1.eq.'disc') then
        fschur=find(lsize,alpha,beta,s,p)
        return
      endif
c+
c sous programmes lies dynamiquement.
      it1=nlink+1
 1001 it1=it1-1
      if(it1.le.0) goto 2000
      if(tablin(it1).ne.namef) goto 1001
cc sun unix
      call dyncall(it1-1,lsize,alpha,beta,s,p)
cc fin
      return
c erreur sur le nom du sous programme
c
 2000 buf=namef
      call error(50)
      return
      end
