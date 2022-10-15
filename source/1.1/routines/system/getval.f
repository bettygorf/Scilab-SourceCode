      subroutine getval(s)
      double precision s
c
c     form numerical value
c
c
      include '../stack.h'
c
      fin=0
      s = 0.0d+0
   10 if (char1 .gt. 9) return
      s = 10.0d+0*s + char1
      call getch
      go to 10
      end
