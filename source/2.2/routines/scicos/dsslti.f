      subroutine dsslti(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     discrete state space linear system simulator
c     rpar(1:nx*nx)=A
c     rpar(nx*nx+1:nx*nx+nx*nu)=B
c     rpar(nx*nx+nx*nu+1:nx*nx+nx*nu+nx*ny)=C
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag

      la=1
      lb=nz*nz+la
      lc=lb+nz*nu

      if(flag.eq.1) then
c    out=c*x
         ld=lc+nz*nout
         call dmmul(rpar(lc),nout,z,nz,out,nout,nout,nz,1)
         call dmmul1(rpar(ld),nout,u,nu,out,nout,nout,nu,1)
      elseif(flag.eq.2) then
c     x+=a*x+b*u
         call dcopy(nz,z,1,out,1)
         call dmmul(rpar(la),nz,out,nz,z,nz,nz,nz,1)
         call dmmul1(rpar(lb),nz,u,nu,z,nz,nz,nu,1)
      endif
      return
      end

