      subroutine cdummy(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Scicos block simulator
c     Dummy state space x'=0
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny

c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Cdummy     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.2) then
         xd(1)=0.0d0
      endif
      end
