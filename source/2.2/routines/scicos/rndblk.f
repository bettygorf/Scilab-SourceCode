      subroutine rndblk(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      double precision urand,sr,si,t1
      integer ipar(*),flag
      integer halt
      common /coshlt/ halt
      common /dbcos/ idb
c
c     ipar(1) 
c            0 : uniform
c            1 : normal
c     rpar(1:nout)=mean
c     rpar(nout+1:2*nout)=deviation
c     rpar(2*nout+1)=dt 
c
      if(idb.eq.1) then
         write(6,'(''rndblk     t='',e10.3,'' flag='',i1)') t,flag
      endif

c     
      if(flag.eq.1) then
         do 10 i=1,nout
            out(i)=rpar(i)+rpar(nout+i)*z(i+1)
 10      continue
      elseif(flag.eq.2.or.flag.eq.4) then
c     uniform
         if(ipar(1).eq.0) then
            iy=int(z(1))
            do 20 i=1,nz-1
               z(i+1)=urand(iy)
 20         continue
         else
            iy=int(z(1))
c     normal
            do 30 i=1,nz-1
 75            sr=2.0d+0*urand(iy)-1.0d+0
               si=2.0d+0*urand(iy)-1.0d+0
               t1 = sr*sr+si*si
               if (t1 .gt. 1.0d+0) go to 75
               z(i+1) = sr*sqrt(-2.0d+0*log(t1)/t1)
 30         continue
         endif
         z(1)=iy
      elseif(flag.eq.3) then
         out(1)=t+rpar(2*(nz-1)+1)
      endif
      return
      end
