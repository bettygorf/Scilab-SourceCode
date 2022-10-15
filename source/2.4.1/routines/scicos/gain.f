      subroutine gain(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Copyright INRIA

c     Scicos block simulator
c     input to output Gain
c     rpar=gain matrix
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny

c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Gain     t='',e10.3,'' flag='',i1)') t,flag
      endif
      call dmmul(rpar,ny,u,nu,y,ny,ny,nu,1)
      end
