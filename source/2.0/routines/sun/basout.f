c     gestion des sorties sur le "standard output"
c     ================================== ( Inria    ) =============
c  
C     deux version une pour un scilab standard 
C     une pour le nouveau xscilab 
      subroutine basout(io,lunit,string)
      character*(*) string
      call xscion(iflag)
      if (iflag.eq.0) then 
         call basout1(io,lunit,string)
      else
         call basout2(io,lunit,string)
      endif
      end
      subroutine basou1(lunit,string)
      character*(*) string
      call xscion(iflag)
      if (iflag.eq.0) then 
         call basou11(lunit,string)
      else
         call basou12(lunit,string)
      endif
      end
c     gestion des sorties sur le "standard output" cas scilab 
c     ================================== ( Inria    ) =============
c     
      subroutine basout1(io,lunit,string)
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
      entry basou11(lunit,string)
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
c     ================================== ( Inria    ) =============
c     gestion des sorties sur le "standard output" cas xscilab 
      subroutine basout2(io,lunit,string)
      character*(*) string
      include '../stack.h'
      io=0
      if(lct(1).eq.-1) return
      if(lct(2).gt.0) then
         if(lct(1)+2.gt.lct(2)) then
            lct(1)=0
            call xscimore(ich)
            if(ich.eq.1) then
               lct(1)=-1
               io=-1
               return
            endif
         else
            lct(1)=lct(1)+1
         endif
      endif
      if (lunit.eq.wte) then 
         call xscistring(string,len(string))
         if(wio.ne.0) write(wio,'(a)') string
      else
         write(lunit,'(a)') string
      endif
      return
      end
      subroutine basou12(lunit,string)
      character*(*) string
      include '../stack.h'
      if (lunit.eq.wte) then 
         buf = string//char(0)
         call xscisncr(buf)
         if(wio.ne.0) write(wio,'(a,$)') string
      else
         write(lunit,'(a,$)') string
      endif
      return
      end
