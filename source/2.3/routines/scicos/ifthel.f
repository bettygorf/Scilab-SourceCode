      subroutine ifthel(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
     &     rpar,nrpar,ipar,nipar,u,nu)
c     Scicos block simulator
c     if-then-else block
c     if event input exits from then or else clock ouputs based
c     on the sign of the unique input (if input>0 then  else )
c
      double precision t,xd(*),x(*),z(*),tvec(*),rpar(*),u(*)
      integer flag,nevprt,nx,nz,ntvec,nrpar,ipar(*)
      integer nipar,nu

c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''ifthel     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if(flag.eq.3) then
         if(u(1).le.0.d0) then
            tvec(1)=t-1.0d0
            tvec(2)=t
         else
            tvec(2)=t-1.0d0
            tvec(1)=t
         endif
      endif
      end
