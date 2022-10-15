      subroutine andlog(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Scicos block simulator
c     Logical and block
c     if event input exists synchronuously, output is 1 else -1
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny

c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Andlog     t='',e10.3,'' flag='',i1)') t,flag
      endif

c
      if(flag.eq.1) then
         if(nevprt.ne.3) then
            y(1)=-1.0d0
         else
            y(1)=1.0d0
         endif
      endif
      return
      end
