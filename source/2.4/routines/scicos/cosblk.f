      subroutine cosblk(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Copyright INRIA

c     Scicos block simulator
c     Outputs cos(u(i))
c     
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny

c     
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Cosblk   t='',e10.3,'' flag='',i1)') t,flag
      endif

      do 15 i=1,nu
         y(i)=cos(u(i))
 15   continue
      end
