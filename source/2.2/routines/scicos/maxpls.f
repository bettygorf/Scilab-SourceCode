      subroutine maxpls(t,x,nx,z,nz,u,nu,rpar,nrpar,ipar,nipar,nclock,
     &     out,nout,flag)
c     delay
c!
      double precision t,x(*),z(*),u(*),rpar(*),out(*)
      integer ipar(*),flag,i,mi
c
      if(flag.eq.1.and.nout.eq.1) then
         out(1)=z(1)
      elseif(flag.eq.2) then
         if (nclock.gt.1) then
            z(nclock)=z(nclock)+1
            mi=100000
            do 5 i=2,nz
               mi=min(int(z(i)),mi)
 5          continue
            if (mi.ge.1) then
               do 7 i=2,nz
                  z(i)=z(i)-1.0d0
 7             continue
               z(1)=z(1)+1.0d0
            endif
         else
            z(1)=max(int(z(1))-1,0)
         endif
      elseif(flag.eq.3) then
         if(int(z(1)).eq.1) then
            out(1)=t-1.0d0
            do 15 i=2,nout
               out(i)=rpar(1)+t
 15         continue
            return
         endif
         if(int(z(1)).ge.2) then
            out(1)=t
            do 18 i=2,nout
               out(i)=rpar(1)+t
 18         continue
            return
         endif
         do 20 i=1,nout
            out(i)=t-1.0d0
 20      continue
      endif
      end
