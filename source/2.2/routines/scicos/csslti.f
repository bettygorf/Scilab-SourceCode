      subroutine csslti(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     continuous state space linear system simulator
c     rpar(1:nx*nx)=A
c     rpar(nx*nx+1:nx*nx+nx*nu)=B
c     rpar(nx*nx+nx*nu+1:nx*nx+nx*nu+nx*ny)=C
c     rpar(nx*nx+nx*nu+nx*ny+1:nx*nx+nx*nu+nx*ny+ny*nu)=D
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Csslti   t='',e10.3,'' flag='',i1)') t,flag
      endif

      la=1
      lb=nx*nx+la
      lc=lb+nx*nu


      if(flag.eq.1) then
c    out=c*x+d*u     
         ld=lc+nx*nout
         call dmmul(rpar(lc),nout,x,nx,out,nout,nout,nx,1)
         call dmmul1(rpar(ld),nout,u,nu,out,nout,nout,nu,1)
      elseif(flag.eq.2) then
c     out=a*x+b*u
         call dmmul(rpar(la),nx,x,nx,out,nx,nx,nx,1)
         call dmmul1(rpar(lb),nx,u,nu,out,nx,nx,nu,1)
      endif
      return
      end
