      subroutine rslti(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      integer ipar(*),flag,nclock
c
c     ipar(1)=number of inputs
c     first ipar(1) inputs are normal inputs
c       the rest are used to reset the internal states 
c     rpar(1:nx*nx)=A
c     rpar(nx*nx+1:nx*nx+nx*ipar(1))=B
c     rpar(nx*nx+nx*ipar(1)+1:nx*nx+nx*ipar(1)+nx*ny)=C
c     rpar(nx*nx+nx*ipar(1)+nx*ny+1:nx*nx+nx*ipar(1)+nx*ny+ny*ipar(1))=D
c
      integer i
c
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''rslti     t='',e10.3,'' flag='',i1)') t,flag
      endif

      la=1
      lb=nx*nx+la
      lc=lb+nx*ipar(1)


      goto(10,20) flag
      return
 10   continue 

c     out=c*x+d*u
      ld=lc+nx*nout
      call dmmul(rpar(lc),nout,x,nx,out,nout,nout,nx,1)
      call dmmul1(rpar(ld),nout,u,ipar(1),out,nout,nout,ipar(1),1)
      return
c     
 20   continue
c     
      if (nclock.gt.0)then
c     Resets states
         do 25 i=1,nx
            out(i)=u(i+ipar(1)+(nclock-1)*nx)
 25      continue

      else   
c     out=a*x+b*u
         call dmmul(rpar(la),nx,x,nx,out,nx,nx,nx,1)
         call dmmul1(rpar(lb),nx,u,ipar(1),out,nx,nx,ipar(1),1)
      endif
      return

      end
