      subroutine tcslti(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
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
         write(6,'(''Tcslti   t='',e10.3,'' flag='',i1)') t,flag
      endif
      nuu=nu-nx      
      la=1
      lb=nx*nx+la
      lc=lb+nx*nuu

      
      if(flag.eq.1) then
c     out=c*x+d*u     
         ld=lc+nx*nout
         call dmmul(rpar(lc),nout,x,nx,out,nout,nout,nx,1)
         call dmmul1(rpar(ld),nout,u,nuu,out,nout,nout,nuu,1)
      elseif(flag.eq.2) then
         if(nclock.eq.0) then
c     out=a*x+b*u
            call dmmul(rpar(la),nx,x,nx,out,nx,nx,nx,1)
            call dmmul1(rpar(lb),nx,u,nuu,out,nx,nx,nuu,1)
         elseif(nclock.eq.1) then
            call dcopy(nx,u(nuu+1),1,x,1)
         endif
      endif
      return
      end
