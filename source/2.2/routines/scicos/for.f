      subroutine for(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag
c
          common /dbcos/ idb
c
      if(idb.eq.1) then
         write(6,'(''For       t='',e10.3,'' flag='',i1)') t,flag
      endif
c
      if(flag.eq.1) then
         out(1)=z(1)
      elseif(flag.eq.2) then
         if(nclock.eq.1) then
            z(2)=u(1)
            z(1)=1
         else
            z(1)=z(1)+1
         endif
      elseif(flag.eq.3) then
         if(nclock.eq.1) then
            if(u(1).ge.1) then
               out(1)=t-1.d0
               out(2)=t
            else
               out(1)=t-1.d0
               out(2)=t-1.d0
            endif
         else
            if(z(1).ge.z(2)) then
               out(1)=t
               out(2)=t-1.d0
            else
               out(1)=t-1.d0
               out(2)=t
            endif
         endif
      endif
      end

