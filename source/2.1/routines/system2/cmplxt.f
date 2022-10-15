      function cmplxt(istk,ni)
c!but
c     etant donne le code (ou une portion de code correspondant 
c     a un ensemble d'"operations") d'une macro compilee de scilab 
c     cette  fonction en retourne le nombre d'"operations" au 
c     niveau 1.
c!
      integer istk(ni),cmplxt
c     

      parameter (nsiz=6)
      integer op
c     
      if(ni.eq.0) then
         cmplxt=0
         return
      endif
c
      icount=0
      lc=1
 10   continue
      if(lc.le.ni)  then
         op=istk(lc)

         icount=icount+1
c     
         if(op.eq.1) then
c     stackp
            lc=lc+1+nsiz
            goto 10
         elseif(op.eq.2) then
c     stackg
            lc=lc+nsiz+3
            goto 10
         elseif(op.eq.3) then
c     string
            lc=lc+2+istk(lc+1)
            goto 10
         elseif(op.eq.4) then
c     defmat
            lc=lc+1
            goto 10
         elseif(op.eq.5) then
c     allops
            lc=lc+4
            goto 10
         elseif(op.eq.6) then
c     num
            lc=lc+3
            goto 10
         elseif(op.eq.7) then
c     for
            nc=istk(lc+1)
            lc=lc+nc+2
            nc=istk(lc)
            lc=lc+1+nsiz+nc
            goto 10
         elseif(op.eq.8.or.op.eq.9) then
c     if - while
            if(istk(lc+1).gt.0) then
c     ancienne version
               lc=lc+2
               nc=istk(lc)+istk(lc+1)+istk(lc+2)
               lc=lc+3+nc
            else
c     nouvelle version               
               nc=-istk(lc+1)
               lc=lc+nc
            endif
            goto 10
         elseif(op.eq.10) then
c     select
            nc=istk(lc+1)
            lc=lc+nc
            goto 10
         elseif(op.ge.12.and.op.le.15) then
c     pause,break,abort,eol
            lc=lc+1
            goto 10
         elseif(op.eq.16) then 
            lc=lc+2
            icount=icount-1
            goto 10
         elseif(op.ge.100) then
c     matfns
            lc=lc+4
            goto 10
         elseif(op.ge.99) then
c     matfns
            lc=lc+1
            goto 10
         else
c     code errone
            cmplxt=-1
            write(6,'(''cmplxt : code erronne :'',i10)') op
            return
         endif
      endif
      
      cmplxt=icount
      end
