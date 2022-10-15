      subroutine evtdly(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     event delay
c     delay=rpar(1)
c!      
      common /dbcos/ idb
c

      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c
      if(idb.eq.1) then
         write(6,'(''Evtdly     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if(flag.eq.3) then
         out(1)=t+rpar(1)
      endif
      return
      end
