      subroutine samphold(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu,y,ny)
c     Copyright INRIA

c     Scicos block simulator
c     returns sample and hold  of the input
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*),y(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu,ny

      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''samphold t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if(flag.eq.1) then
         do 15 i=1,nu
            y(i)=u(i)
 15      continue
      endif
      end
