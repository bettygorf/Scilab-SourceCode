      subroutine basout(io,lunit,string)
c     gestion des sorties sur le "standard output"
c     ================================== ( Inria    ) =============
c     
      character*(*) string
      include '../stack.h'
c     
      character form*10,ch*1
c     
      form='(a)'
      io=0
      if(lct(1).eq.-1) return
      if(lct(2).gt.0) then
         if(lct(1)+2.gt.lct(2)) then
            lct(1)=0
cc    sauf ibm cdc
            write(wte, '('' more ?'',$)')
            read(rte,'(a1,$)') ch
cc    standard
cc    write(wte, '('' more ?'')')
cc    read(rte,'(a1)') ch
cc    fin version
            if(ch.ne.' ') then
               lct(1)=-1
               io=-1
               return
            endif
         else
            lct(1)=lct(1)+1
         endif
      endif
      goto 10
c     
c     ====================================================================
c     
      entry basou1(lunit,string)
cc    sauf ibm cdc
      form='(a,$)'
cc    standard
cc    form='(a)'
cc    fin version
c     
 10   write(lunit,form) string
      if(lunit.eq.wte.and.wio.ne.0) write(wio,form) string
c     
      return
      end
