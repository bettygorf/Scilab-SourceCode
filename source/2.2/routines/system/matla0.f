      subroutine matla0( ini1,bu1)
c
c ====================================================================
c     main routine
c ====================================================================

c
      character*(*) bu1
      integer       ini1
c
      INCLUDE '../stack.h'
      integer iadr
      integer init
c
      iadr(l)=l+l-1
c
c ------------------------------
c appel au parseur d instruction
c ------------------------------
c
      icall=0
      krec=99999
      include '../callinter.h'
 9999 goto 60
 200  return
c
      end
