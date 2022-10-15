      subroutine userlk(k)
      include '../stack.h'
c interfaces liees dynamiquement.
      k=k/100
      if(k.gt.nlink.or.k.le.0) then
         write(buf,'(''Invalid interface number'',i3)') k
         call error(9999)
         return
      endif
      call dyncall(k-1)
cc fin
      return
c
      end
