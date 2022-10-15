      subroutine fsurfd(neq,t,y,ng,gout,rpar,ipar)
C    SUBROUTINE G(neq,t,y,ng,gout,rpar,ipar)
C    DIMENSION y(neq),gout(ng),
c!
c user interface for scilab dasrt function
c surface crossing definition
c!
      include '../stack.h'
c
      integer ires,ipar(*)
      double precision t,y(*),gout(*),rpar(*)
c
      integer it1,neq,ng
c
      character*6    namer,namej,names,nam1
      common /dassln/ namer,namej,names

      call majmin(6,names,nam1)
c
c 
c INSERT CALL TO YOUR OWN ROUTINE HERE 
c the routine gr1 is an example: it is called when the
c string 'gr1' is given as a parameter 
c in the calling sequence of scilab's dasrt built-in
c function 
c+
      if(nam1.eq.'gr1') then
      call gr1 (neq, t, y, ng, gout, rpar, ipar)
      return
      endif
c
      if(nam1.eq.'gr2') then
      call gr2 (neq, t, y, ng, gout, rpar, ipar)
      return
      endif
c+
c     dynamic link
      call tlink(names,0,it1)
      if(it1.le.0) goto 2000
      call dyncall(it1-1,neq,t,y,ng,gout,rpar,ipar)
cc fin
      return
c
 2000 ires=-2
      buf=names
      call error(50)
      return
      end

C
      subroutine gr1 (neq, t, y, ng, groot, rpar, ipar)
      INTEGER neq, ng,ipar(*)
      DOUBLE PRECISION t, y(*), groot(*),rpar(*)
      groot(1) = ((2.0D0*LOG(y(1)) + 8.0D0)/t - 5.0D0)*y(1)
      groot(2) = LOG(y(1)) - 2.2491D0
      RETURN
      END

      subroutine gr2 (neq, t, y, ng, groot, rpar, ipar)
      INTEGER neq, ng, ipar(*)
      DOUBLE PRECISION t, y, groot,rpar(*)
      DIMENSION y(*), groot(*)
      groot(1) = y(1)
      RETURN
      END

