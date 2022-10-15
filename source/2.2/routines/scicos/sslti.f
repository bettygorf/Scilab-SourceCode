      subroutine sslti(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag
c
c     rpar(1:nx*nx)=A
c     rpar(nx*nx+1:nx*nx+nx*nu)=B
c     rpar(nx*nx+nx*nu+1:nx*nx+nx*nu+nx*ny)=C
c     rpar(nx*nx+nx*nu+nx*ny+1:nx*nx+nx*nu+nx*ny+ny*nu)=D
c
      integer i,j,p
c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''sslti     t='',e10.3,'' flag='',i1)') t,flag
      endif


      la=1
      lb=nx*nx+la
      lc=lb+nx*nu


      goto(10,30) flag
      return
 10   continue
c     out=c*x+d*u     
      ld=lc+nx*nout
      call dmmul(rpar(lc),nout,x,nx,out,nout,nout,nx,1)
      call dmmul1(rpar(ld),nout,u,nu,out,nout,nout,nu,1)
      return
c
 30   continue
c     out=a*x+b*u
      call dmmul(rpar(la),nx,x,nx,out,nx,nx,nx,1)
      call dmmul1(rpar(lb),nx,u,nu,out,nx,nx,nu,1)
      return
      end
