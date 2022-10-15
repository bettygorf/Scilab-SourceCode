      subroutine zcross(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,l
c
c     ipar(1:nu)=threshold values
c     
      common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''Zcross     t='',e10.3,'' flag='',i1)') t,flag
      endif

      if (flag.eq.3) then
         l=nclock*nout
         do 10 i=1,nout
            out(i)=rpar(l+i)+t  
 10      continue
      endif
      end
