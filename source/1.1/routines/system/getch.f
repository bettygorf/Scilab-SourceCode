      subroutine getch
c
c     get next character
c
c
      include '../stack.h'
c
      integer eol
      data eol/99/
c
      l = lpt(4)
      char1 = lin(l)
cMAJ
      if(fin.eq.0) char1=abs(char1)
      if (char1 .ne. eol) lpt(4) = l + 1
      return
      end
