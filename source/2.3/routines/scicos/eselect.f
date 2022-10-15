      subroutine eselect(flag,nevprt,t,xd,x,nx,z,nz,tvec,ntvec,
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
      integer iu
c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''ifthel     t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      iu=max(min(int(u(1)),ipar(1)),1)
      if(flag.eq.3) then
            tvec(iu)=t
      endif
      end
