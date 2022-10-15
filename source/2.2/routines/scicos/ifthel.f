      subroutine ifthel(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c!
c     if-then-else block
c     if event input exits from then or else clock ouputs based
c     on the sign of the unique input (if input>0 then  else )
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Select     t='',e10.3,'' flag='',i1)') t,flag
      endif

c
      if(flag.eq.3) then
         if(u(1).le.0.d0) then
            out(1)=t-1.0d0
            out(2)=t
         else
            out(2)=t-1.0d0
            out(1)=t
         endif
      endif
      return
      end
