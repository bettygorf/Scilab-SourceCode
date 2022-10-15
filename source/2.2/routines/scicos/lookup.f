      subroutine lookup(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),u(*),rpar(*),out(*),z(*)
      double precision du,dout
      integer ipar(*),flag
      integer i
      common /dbcos/ idb
c
c     rpar(1:n)  =  u coordinate discretisation must be strictly increasing
c     rpar(n+1:2*n)  =  y coordinate discretisation
c
      if(idb.eq.1) then
         write(6,'(''lookup t='',e10.3,'' flag='',i1)') t,flag
      endif

      if(flag.eq.1) then
         n=nrpar/2
         if(n.gt.2) then
            do 10 i=2,n-1
               if (u(1).le.rpar(i)) goto 20
 10         continue
         else
            if(n.eq.1) then
               out(1)=rpar(2)
               return
            endif
            i=2
         endif
 20      continue
         du=rpar(i)-rpar(i-1)
         dout=rpar(n+i)-rpar(n+i-1)
         out(1)=rpar(n+i)-(rpar(i)-u(1))*dout/du
      endif

      return
      end
