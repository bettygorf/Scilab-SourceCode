      subroutine  msgstxt(txt)
      include '../stack.h'
      character txt*(*)
      call basout(io,wte,txt)
      return
      end
