      subroutine gensqr(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     discrete state space linear system simulator
c!
c           
      common /dbcos/ idb
c
c
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c
      if(idb.eq.1) then
         write(6,'(''gensqr     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
         out(1)=z(1)
      elseif(flag.eq.2) then
         z(1)=-z(1)
      elseif(flag.eq.3) then
         out(1)=t+rpar(1)
      endif
      return
      end

