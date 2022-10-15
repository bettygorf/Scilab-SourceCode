      subroutine mfclck(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     multifrequency clock
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''mfclck     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.4) then
         z(1)=0
      elseif(flag.eq.2) then
         z(1)=z(1)+1
         if (z(1).eq.ipar(1)) z(1)=0
      elseif(flag.eq.3) then
         if (z(1).eq.ipar(1)-1) then
            out(1)=t-1.0d0
            out(2)=t+rpar(1)
         else
            out(1)=t+rpar(1)
            out(2)=t-1.0d0
         endif
      endif
      return
      end

